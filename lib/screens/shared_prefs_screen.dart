import 'package:flutter/material.dart';
import '../../databases/prefs_service.dart';

class SharedPrefsScreen extends StatefulWidget {
  const SharedPrefsScreen({super.key});

  @override
  State<SharedPrefsScreen> createState() => _SharedPrefsScreenState();
}

class _SharedPrefsScreenState extends State<SharedPrefsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  int _volume = 50;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _isDarkMode = PrefsService.getBool('isDarkMode');
      _notificationsEnabled = PrefsService.getBool('notificationsEnabled');
      _selectedLanguage = PrefsService.getString('language') ?? 'English';
      _volume = int.tryParse(PrefsService.getString('volume') ?? '50') ?? 50;
    });
  }

  void _saveAllSettings() {
    PrefsService.setBool('isDarkMode', _isDarkMode);
    PrefsService.setBool('notificationsEnabled', _notificationsEnabled);
    PrefsService.setString('language', _selectedLanguage);
    PrefsService.setString('volume', _volume.toString());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All settings saved to SharedPreferences!')),
    );
  }

  void _readSettings() {
    _loadSettings();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings loaded from SharedPreferences!')),
    );
  }

  void _deleteAllSettings() async {
    await PrefsService.removeData(key: 'isDarkMode');
    await PrefsService.removeData(key: 'notificationsEnabled');
    await PrefsService.removeData(key: 'language');
    await PrefsService.removeData(key: 'volume');

    setState(() {
      _isDarkMode = false;
      _notificationsEnabled = true;
      _selectedLanguage = 'English';
      _volume = 50;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('All settings cleared!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'SharedPreferences - App Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
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
                      'App Settings',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      subtitle: const Text('Enable dark theme'),
                      value: _isDarkMode,
                      onChanged: (value) => setState(() => _isDarkMode = value),
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Notifications'),
                      subtitle: const Text('Enable push notifications'),
                      value: _notificationsEnabled,
                      onChanged: (value) =>
                          setState(() => _notificationsEnabled = value),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Language'),
                      trailing: DropdownButton<String>(
                        value: _selectedLanguage,
                        underline: const SizedBox(),
                        items: ['English', 'Spanish', 'French', 'Arabic']
                            .map(
                              (lang) =>
                                  DropdownMenuItem(value: lang, child: Text(lang)),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedLanguage = value!),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Volume'),
                      subtitle: Slider(
                        thumbColor: Colors.blue,
                        activeColor: Colors.blue,
                        value: _volume.toDouble(),
                        min: 0,
                        max: 100,
                        divisions: 10,
                        label: '$_volume%',
                        onChanged: (value) =>
                            setState(() => _volume = value.round()),
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
                    onPressed: _saveAllSettings,
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
                    onPressed: _readSettings,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Read'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _deleteAllSettings,
              icon: const Icon(Icons.delete, color: Colors.white),
              label: const Text('Clear All', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const Text(
              'Current Stored Values:',
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
                    _buildDataRow('Dark Mode', _isDarkMode ? 'true' : 'false'),
                    _buildDataRow(
                      'Notifications',
                      _notificationsEnabled ? 'true' : 'false',
                    ),
                    _buildDataRow('Language', _selectedLanguage),
                    _buildDataRow('Volume', '$_volume'),
                  ],
                ),
              ),
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
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
