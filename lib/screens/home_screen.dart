import 'package:flutter/material.dart';

import 'hive_screen.dart';
import 'shared_prefs_screen.dart';
import 'secure_storage_screen.dart';
import 'sqflite_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Local Storage Tutorial',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose a Storage Type',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap any card to explore CRUD operations',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildStorageCard(
                    context,
                    title: 'Hive',
                    subtitle: 'NoSQL - User Settings',
                    description:
                        'Fast key-value local database for storing user preferences and settings.',
                    icon: Icons.inventory_2,
                    color: Colors.deepPurple,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HiveScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStorageCard(
                    context,
                    title: 'SharedPreferences',
                    subtitle: 'Key-Value - App Settings',
                    description:
                        'Lightweight storage for simple key-value pairs like toggles and preferences.',
                    icon: Icons.settings,
                    color: Colors.blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SharedPrefsScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStorageCard(
                    context,
                    title: 'Secure Storage',
                    subtitle: 'Encrypted - Auth Tokens',
                    description:
                        'Encrypted storage for sensitive data like authentication tokens and keys.',
                    icon: Icons.lock,
                    color: Colors.teal,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SecureStorageScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStorageCard(
                    context,
                    title: 'SQLite (sqflite)',
                    subtitle: 'Relational - Posts Data',
                    description:
                        'Full SQL database for structured data with complex queries and relationships.',
                    icon: Icons.storage,
                    color: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SqfliteScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: color, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
