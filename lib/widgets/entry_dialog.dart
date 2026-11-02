import 'package:flutter/material.dart';

import '../models/schedule_entry.dart';

// Shows the add/edit dialog. Returns the entry the user typed,
// or null if they cancelled.
Future<ScheduleEntry?> showEntryDialog(
  BuildContext context, {
  ScheduleEntry? existing,
}) {
  return showDialog<ScheduleEntry>(
    context: context,
    builder: (_) => _EntryDialog(existing: existing),
  );
}

class _EntryDialog extends StatefulWidget {
  final ScheduleEntry? existing;
  const _EntryDialog({this.existing});

  @override
  State<_EntryDialog> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<_EntryDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _subject = TextEditingController(
    text: widget.existing?.subject ?? '',
  );
  late final TextEditingController _room = TextEditingController(
    text: widget.existing?.room ?? '',
  );

  @override
  void dispose() {
    _subject.dispose();
    _room.dispose();
    super.dispose();
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      ScheduleEntry(
        id: widget.existing?.id, // keeps the same id when editing
        subject: _subject.text.trim(),
        room: _room.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return AlertDialog(
      title: Text(isEdit ? 'Edit class' : 'Add class'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _subject,
              decoration: const InputDecoration(labelText: 'Subject'),
              validator: _required,
            ),
            TextFormField(
              controller: _room,
              decoration: const InputDecoration(labelText: 'Room'),
              validator: _required,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: Text(isEdit ? 'Save' : 'Add')),
      ],
    );
  }
}
