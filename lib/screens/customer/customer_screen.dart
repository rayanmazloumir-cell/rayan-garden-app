import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../state/app_scope.dart';
import '../../widgets/common.dart';
import '../notes/notes_screen.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    final state = AppScope.read(context);
    state.markFormStarted();
    _name = TextEditingController(text: state.name);
    _phone = TextEditingController(text: state.phone);
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _next() {
    final state = AppScope.read(context);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    state.setCustomer(_name.text, _phone.text);
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NotesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return StepScaffold(
      title: state.tr('form_title'),
      step: 5,
      bottom: ElevatedButton(
        onPressed: _next,
        child: Text(state.tr('continue')),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          children: [
            TextFormField(
              controller: _name,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              maxLength: 80,
              decoration: InputDecoration(
                labelText: state.tr('form_name'),
                prefixIcon: const Icon(Icons.person_outline_rounded),
                counterText: '',
              ),
              validator: (v) =>
                  isValidName(v ?? '') ? null : state.tr('form_name_err'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              textDirection: TextDirection.ltr,
              maxLength: 20,
              decoration: InputDecoration(
                labelText: state.tr('form_phone'),
                hintText: state.tr('form_phone_hint'),
                prefixIcon: const Icon(Icons.phone_iphone_rounded),
                counterText: '',
              ),
              validator: (v) =>
                  isValidIranMobile(v ?? '') ? null : state.tr('form_phone_err'),
              onFieldSubmitted: (_) => _next(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.verified_user_outlined,
                    size: 18, color: AppColors.gold),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.tr('form_no_login'),
                    style: TextStyle(
                        color: AppColors.ink.withAlpha(170), fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
