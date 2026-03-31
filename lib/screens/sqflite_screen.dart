import 'package:flutter/material.dart';
import '../../databases/sqflite_service.dart';
import '../../models/post_model.dart';

class SqfliteScreen extends StatefulWidget {
  const SqfliteScreen({super.key});

  @override
  State<SqfliteScreen> createState() => _SqfliteScreenState();
}

class _SqfliteScreenState extends State<SqfliteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _usernameController = TextEditingController();
  final _captionController = TextEditingController();
  final _likesController = TextEditingController();

  final SqfliteService _sqfliteService = SqfliteService();
  List<PostModel> _posts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => _isLoading = true);
    final result = await _sqfliteService.getAll(table: 'posts');
    setState(() {
      _posts = result.map((json) => PostModel.fromJson(json)).toList();
      _isLoading = false;
    });
  }

  Future<void> _createPost() async {
    if (_formKey.currentState!.validate()) {
      final post = PostModel(
        id: _idController.text,
        username: _usernameController.text,
        userImage: 'https://i.pravatar.cc/150?img=${_idController.text}',
        imageUrl: 'https://picsum.photos/seed/${_idController.text}/400/400',
        caption: _captionController.text,
        likes: int.tryParse(_likesController.text) ?? 0,
      );

      await _sqfliteService.insert(table: 'posts', data: post.toJson());
      await _loadPosts();
      _clearForm();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Post created in SQLite!')));
      }
    }
  }

  Future<void> _readPosts() async {
    await _loadPosts();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loaded ${_posts.length} posts from SQLite!')),
      );
    }
  }

  Future<void> _updatePost() async {
    if (_idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter post ID to update')),
      );
      return;
    }

    final existingIndex = _posts.indexWhere((p) => p.id == _idController.text);
    if (existingIndex == -1) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Post not found')));
      }
      return;
    }

    final updatedPost = PostModel(
      id: _idController.text,
      username: _usernameController.text,
      userImage: _posts[existingIndex].userImage,
      imageUrl: _posts[existingIndex].imageUrl,
      caption: _captionController.text,
      likes: int.tryParse(_likesController.text) ?? 0,
    );

    await _sqfliteService.update(
      table: 'posts',
      id: int.parse(_idController.text),
      data: updatedPost.toJson(),
    );
    await _loadPosts();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Post updated!')));
    }
  }

  Future<void> _deletePost() async {
    if (_idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter post ID to delete')),
      );
      return;
    }

    final existingIndex = _posts.indexWhere((p) => p.id == _idController.text);
    if (existingIndex == -1) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Post not found')));
      }
      return;
    }

    await _sqfliteService.delete(table: 'posts', id: int.parse(_idController.text));
    await _loadPosts();
    _clearForm();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Post deleted!')));
    }
  }

  Future<void> _deleteAllPosts() async {
    await _sqfliteService.deleteAll(table: 'posts');
    await _loadPosts();
    _clearForm();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All posts deleted!')));
    }
  }

  void _clearForm() {
    _idController.clear();
    _usernameController.clear();
    _captionController.clear();
    _likesController.clear();
  }

  void _fillForm(PostModel post) {
    _idController.text = post.id;
    _usernameController.text = post.username;
    _captionController.text = post.caption;
    _likesController.text = post.likes.toString();
  }

  @override
  void dispose() {
    _idController.dispose();
    _usernameController.dispose();
    _captionController.dispose();
    _likesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'SQLite - Posts CRUD',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Post Form',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _idController,
                              decoration: const InputDecoration(
                                labelText: 'Post ID',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _captionController,
                              decoration: const InputDecoration(
                                labelText: 'Caption',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _likesController,
                              decoration: const InputDecoration(
                                labelText: 'Likes',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _createPost,
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            'Create',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _readPosts,
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text(
                            'Read',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _updatePost,
                          icon: const Icon(Icons.edit, color: Colors.white),
                          label: const Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _deletePost,
                          icon: const Icon(Icons.delete, color: Colors.white),
                          label: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _deleteAllPosts,
                    icon: const Icon(Icons.delete_sweep, color: Colors.white),
                    label: const Text(
                      'Delete All',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  Text(
                    'Stored Posts (${_posts.length}):',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_posts.isEmpty)
                    const Text(
                      'No posts stored yet.',
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    ...List.generate(_posts.length, (index) {
                      final post = _posts[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(post.userImage),
                          ),
                          title: Text(post.username),
                          subtitle: Text(
                            post.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.favorite,
                                size: 16,
                                color: Colors.red,
                              ),
                              Text('${post.likes}'),
                            ],
                          ),
                          onTap: () => _fillForm(post),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
