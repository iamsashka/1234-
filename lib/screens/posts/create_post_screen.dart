import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/notifications.dart';
import '../../presentation/bloc/posts/posts_bloc.dart';
import '../../widgets/custom_button.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostsBloc, PostsState>(
      listener: (context, state) {
        if (state is PostOperationSuccess) {
          NotificationService.showSnackBar(
            context: context,
            message: state.message,
          );
          Navigator.pop(context);
        } else if (state is PostsError) {
          NotificationService.showSnackBar(
            context: context,
            message: state.message,
            isError: true,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Создать пост'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 50 * _slideAnimation.value),
                child: child,
              );
            },
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Новый пост',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Поделитесь своими мыслями',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Заголовок',
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: Validators.validateTitle,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: 'Содержание',
                      prefixIcon: Icon(Icons.description),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 8,
                    validator: Validators.validateContent,
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<PostsBloc, PostsState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Создать пост',
                        isLoading: state is PostsLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<PostsBloc>().add(
                              CreatePost(
                                title: _titleController.text,
                                content: _contentController.text,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}