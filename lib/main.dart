import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'core/themes/app_theme.dart';
import 'core/utils/notifications.dart';
import 'data/datasources/firebase_auth_datasource.dart';
import 'data/datasources/firestore_datasource.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/post_repository.dart';
import 'domain/usecases/auth/sign_in_usecase.dart';
import 'domain/usecases/auth/sign_up_usecase.dart';
import 'domain/usecases/auth/sign_out_usecase.dart';
import 'domain/usecases/auth/reset_password_usecase.dart';
import 'domain/usecases/posts/get_posts_usecase.dart';
import 'domain/usecases/posts/create_post_usecase.dart';
import 'domain/usecases/posts/update_post_usecase.dart';
import 'domain/usecases/posts/delete_post_usecase.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/posts/posts_bloc.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/posts_list_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Инициализация уведомлений
  await NotificationService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) {
            final authDataSource = FirebaseAuthDataSource();
            final authRepository = AuthRepository(authDataSource);
            return AuthBloc(
              signInUseCase: SignInUseCase(authRepository),
              signUpUseCase: SignUpUseCase(authRepository),
              signOutUseCase: SignOutUseCase(authRepository),
              resetPasswordUseCase: ResetPasswordUseCase(authRepository),
            )..add(AuthCheckRequested());
          },
        ),
        BlocProvider<PostsBloc>(
          create: (context) {
            final firestoreDataSource = FirestoreDataSource();
            final postRepository = PostRepository(firestoreDataSource);
            return PostsBloc(
              getPostsUseCase: GetPostsUseCase(postRepository),
              createPostUseCase: CreatePostUseCase(postRepository),
              updatePostUseCase: UpdatePostUseCase(postRepository),
              deletePostUseCase: DeletePostUseCase(postRepository),
            );
          },
        ),
      ],
      child: MaterialApp(
        title: 'Firebase Posts App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const PostsListScreen();
            } else if (state is AuthUnauthenticated) {
              return const LoginScreen();
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}