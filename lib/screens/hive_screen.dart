import 'package:flutter/material.dart';
import '../../databases/hive_service.dart';
import '../../models/user_settings_model.dart';

class HiveScreen extends StatefulWidget {
  const HiveScreen({super.key});

  @override
  State<HiveScreen> createState() => _HiveScreenState();
}

class _HiveScreenState extends State<HiveScreen> {
  static const String _boxName = 'user_settings';
  static const String _key = 'settings';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isDarkMode = false;
  String _language = 'English';

  UserSettingsModel? _savedSettings;
  final HiveService _hiveService = HiveService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _hiveService.getItem<UserSettingsModel>(_boxName, _key);
    setState(() {
      _savedSettings = settings;
      if (settings != null) {
        _nameController.text = settings.userName;
        _emailController.text = settings.email;
        _isDarkMode = settings.isDarkMode;
        _language = settings.language;
      }
    });
  }

  Future<void> _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      final settings = UserSettingsModel(
        userName: _nameController.text,
        email: _emailController.text,
        isDarkMode: _isDarkMode,
        language: _language,
      );
      await _hiveService.saveItem<UserSettingsModel>(_boxName, _key, settings);
      await _loadSettings();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Settings saved to Hive!')));
      }
    }
  }

  Future<void> _updateSettings() async {
    if (_formKey.currentState!.validate()) {
      final settings = UserSettingsModel(
        userName: _nameController.text,
        email: _emailController.text,
        isDarkMode: _isDarkMode,
        language: _language,
      );
      await _hiveService.saveItem<UserSettingsModel>(_boxName, _key, settings);
      await _loadSettings();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Settings updated!')));
      }
    }
  }

  Future<void> _deleteSettings() async {
    await _hiveService.deleteItem(_boxName, _key);
    setState(() {
      _savedSettings = null;
      _nameController.clear();
      _emailController.clear();
      _isDarkMode = false;
      _language = 'English';
    });
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Settings deleted!')));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Hive - User Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
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
                      'User Settings Form',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'User Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter name' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter email' : null,
                          ),
                          const SizedBox(height: 12),
                          SwitchListTile(
                            title: const Text('Dark Mode'),
                            value: _isDarkMode,
                            onChanged: (value) =>
                                setState(() => _isDarkMode = value),
                          ),
                          DropdownButtonFormField<String>(
                            value: _language,
                            decoration: const InputDecoration(
                              labelText: 'Language',
                              border: OutlineInputBorder(),
                            ),
                            items: ['English', 'Spanish', 'French', 'Arabic']
                                .map(
                                  (lang) => DropdownMenuItem(
                                    value: lang,
                                    child: Text(lang),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) => setState(() => _language = value!),
                          ),
                        ],
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
                    onPressed: _saveSettings,
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
                    onPressed: _updateSettings,
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
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _deleteSettings,
              icon: const Icon(Icons.delete, color: Colors.white),
              label: const Text('Delete', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const Text(
              'Stored Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_savedSettings != null)
              Card(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDataRow('User Name', _savedSettings!.userName),
                      _buildDataRow('Email', _savedSettings!.email),
                      _buildDataRow(
                        'Dark Mode',
                        _savedSettings!.isDarkMode ? 'Yes' : 'No',
                      ),
                      _buildDataRow('Language', _savedSettings!.language),
                    ],
                  ),
                ),
              )
            else
              const Text(
                'No data stored yet.',
                style: TextStyle(color: Colors.grey),
              ),
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
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
