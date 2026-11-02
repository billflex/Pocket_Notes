import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../models/schedule_entry.dart';
import '../widgets/entry_dialog.dart';

class HomeScreen extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ScheduleEntry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load(); // loads the saved records when the app launches
  }

  Future<void> _load() async {
    final rows = await AppDatabase.instance.getAll();
    if (!mounted) return;
    setState(() {
      _entries = rows;
      _loading = false;
    });
  }

  Future<void> _add() async {
    final entry = await showEntryDialog(context);
    if (entry == null) return;
    await AppDatabase.instance.insert(entry);
    await _load();
  }

  Future<void> _edit(ScheduleEntry old) async {
    final updated = await showEntryDialog(context, existing: old);
    if (updated == null) return;
    await AppDatabase.instance.update(updated);
    await _load();
  }

  Future<void> _delete(ScheduleEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this class?'),
        content: Text('${entry.subject} (${entry.room}) will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await AppDatabase.instance.delete(entry.id!);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pocket Notes'),
        actions: [
          Icon(widget.isDark ? Icons.dark_mode : Icons.light_mode),
          Switch(value: widget.isDark, onChanged: widget.onThemeChanged),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
          ? const Center(child: Text('No classes yet. Tap + to add one.'))
          : ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (_, i) {
                final e = _entries[i];
                return ListTile(
                  title: Text(e.subject),
                  subtitle: Text('Room: ${e.room}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _edit(e),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _delete(e),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
    );
  }
}
