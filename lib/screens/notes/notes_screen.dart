import 'package:flutter/material.dart';

import '../../state/app_scope.dart';
import '../../widgets/common.dart';
import '../confirm/confirm_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    _notes = TextEditingController(text: AppScope.read(context).notes);
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  void _next() {
    AppScope.read(context).setNotes(_notes.text);
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ConfirmScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return StepScaffold(
      title: state.tr('notes_title'),
      step: 6,
      bottom: ElevatedButton(
        onPressed: _next,
        child: Text(state.tr('continue')),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        children: [
          TextField(
            controller: _notes,
            minLines: 5,
            maxLines: 8,
            maxLength: 500,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: state.tr('notes_label'),
              hintText: state.tr('notes_hint'),
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }
}
