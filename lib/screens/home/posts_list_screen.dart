import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/notifications.dart';
import '../../../domain/entities/post_entity.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/posts/posts_bloc.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/post_card.dart';
import '../posts/create_post_screen.dart';
import '../posts/edit_post_screen.dart';

class PostsListScreen extends StatefulWidget {
  const PostsListScreen({super.key});

  @override
  State<PostsListScreen> createState() => _PostsListScreenState();
}

class _PostsListScreenState extends State<PostsListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
    
    context.read<PostsBloc>().add(LoadPosts());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostsBloc, PostsState>(
      listener: (context, state) {
        if (state is PostOperationSuccess) {
          NotificationService.showNotification(
            title: 'Успех',
            body: state.message,
          );
          NotificationService.showSnackBar(
            context: context,
            message: state.message,
          );
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
          title: const Text('Мои посты'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                NotificationService.showNotification(
                  title: 'Уведомление',
                  body: 'Это тестовое уведомление',
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _showLogoutDialog();
              },
            ),
          ],
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: BlocBuilder<PostsBloc, PostsState>(
            builder: (context, state) {
              if (state is PostsLoading) {
                return const LoadingWidget(message: 'Загрузка постов...');
              }
              
              if (state is PostsError) {
                return ErrorDisplayWidget(
                  message: state.message,
                  onRetry: () {
                    context.read<PostsBloc>().add(LoadPosts());
                  },
                );
              }
              
              if (state is PostsLoaded) {
                if (state.posts.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildPostsList(state.posts);
              }
              
              return const SizedBox.shrink();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreatePostScreen()),
            ).then((_) {
              context.read<PostsBloc>().add(LoadPosts());
            });
          },
          icon: const Icon(Icons.add),
          label: const Text('Создать пост'),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.post_add,
            size: 100,
            color: Colors.grey.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'Здесь пока нет постов',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Нажмите кнопку + чтобы создать первый пост',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsList(List<PostEntity> posts) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PostsBloc>().add(LoadPosts());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final canModify = context.read<PostsBloc>().canModifyPost(post);
          
          return PostCard(
            post: post,
            canModify: canModify,
            onEdit: canModify
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditPostScreen(post: post),
                      ),
                    ).then((_) {
                      context.read<PostsBloc>().add(LoadPosts());
                    });
                  }
                : null,
            onDelete: canModify
                ? () {
                    _showDeleteDialog(post);
                  }
                : null,
          );
        },
      ),
    );
  }

  void _showDeleteDialog(PostEntity post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление поста'),
        content: Text('Вы уверены, что хотите удалить пост "${post.title}"?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PostsBloc>().add(DeletePost(postId: post.id));
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}