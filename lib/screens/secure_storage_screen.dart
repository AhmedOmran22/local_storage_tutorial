import 'package:flutter/material.dart';
import '../../databases/secure_storage_service.dart';

class SecureStorageScreen extends StatefulWidget {
  const SecureStorageScreen({super.key});

  @override
  State<SecureStorageScreen> createState() => _SecureStorageScreenState();
}

class _SecureStorageScreenState extends State<SecureStorageScreen> {
  final _tokenController = TextEditingController();
  final _refreshTokenController = TextEditingController();
  final _userIdController = TextEditingController();

  String? _storedToken;
  String? _storedRefreshToken;
  String? _storedUserId;

  @override
  void initState() {
    super.initState();
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    final token = await SecureStorageService.read(key: 'auth_token');
    final refreshToken = await SecureStorageService.read(key: 'refresh_token');
    final userId = await SecureStorageService.read(key: 'user_id');

    setState(() {
      _storedToken = token;
      _storedRefreshToken = refreshToken;
      _storedUserId = userId;
    });
  }

  Future<void> _saveTokens() async {
    if (_tokenController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter an auth token')));
      return;
    }

    await SecureStorageService.write(
      key: 'auth_token',
      value: _tokenController.text,
    );

    if (_refreshTokenController.text.isNotEmpty) {
      await SecureStorageService.write(
        key: 'refresh_token',
        value: _refreshTokenController.text,
      );
    }

    if (_userIdController.text.isNotEmpty) {
      await SecureStorageService.write(
        key: 'user_id',
        value: _userIdController.text,
      );
    }

    await _loadStoredData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tokens saved to Secure Storage!')),
      );
    }
  }

  Future<void> _readTokens() async {
    await _loadStoredData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tokens loaded from Secure Storage!')),
      );
    }
  }

  Future<void> _updateToken() async {
    if (_tokenController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a new token')));
      return;
    }

    await SecureStorageService.write(
      key: 'auth_token',
      value: _tokenController.text,
    );
    await _loadStoredData();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Token updated!')));
    }
  }

  Future<void> _deleteTokens() async {
    await SecureStorageService.delete(key: 'auth_token');
    await SecureStorageService.delete(key: 'refresh_token');
    await SecureStorageService.delete(key: 'user_id');

    setState(() {
      _storedToken = null;
      _storedRefreshToken = null;
      _storedUserId = null;
      _tokenController.clear();
      _refreshTokenController.clear();
      _userIdController.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('All tokens deleted!')));
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _refreshTokenController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Secure Storage - Auth Tokens',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Auth Token Management',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Store sensitive auth tokens securely (encrypted)',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _tokenController,
                      decoration: const InputDecoration(
                        labelText: 'Auth Token',
                        hintText: 'Enter your auth token',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.vpn_key),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _refreshTokenController,
                      decoration: const InputDecoration(
                        labelText: 'Refresh Token (optional)',
                        hintText: 'Enter refresh token',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.refresh),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _userIdController,
                      decoration: const InputDecoration(
                        labelText: 'User ID (optional)',
                        hintText: 'Enter user ID',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveTokens,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text('Save', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _readTokens,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text('Read', style: TextStyle(color: Colors.white)),
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
                    onPressed: _updateToken,
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
                    onPressed: _deleteTokens,
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
            const SizedBox(height: 24),
            const Divider(),
            const Text(
              'Encrypted Stored Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDataRow('Auth Token', _storedToken ?? 'Not set'),
                    const Divider(),
                    _buildDataRow('Refresh Token', _storedRefreshToken ?? 'Not set'),
                    const Divider(),
                    _buildDataRow('User ID', _storedUserId ?? 'Not set'),
                  ],
                ),
              ),
            ),
            if (_storedToken != null) ...[
              const SizedBox(height: 8),
              Card(
                color: Colors.green[50],
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.lock, color: Colors.green),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Data is securely encrypted on device',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value.length > 30 ? '${value.substring(0, 30)}...' : value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}
