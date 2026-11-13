import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../state/app_scope.dart';
import '../../widgets/common.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  bool _otpStep = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _otp.dispose();
    super.dispose();
  }

  void _requestOtp() {
    final state = AppScope.of(context);
    if (!isValidIranMobile(_phone.text)) {
      setState(() => _error = state.tr('auth_phone_error'));
      return;
    }
    try {
      final result = state.requestLocalOtp(_phone.text);
      _otp.text = result.testCode;
      setState(() {
        _otpStep = true;
        _error = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.tr('auth_otp_sent'))));
    } on FormatException {
      setState(() => _error = state.tr('auth_phone_error'));
    }
  }

  void _verify() {
    final state = AppScope.of(context);
    if (_otp.text.trim() != '1234') {
      setState(() => _error = state.tr('auth_otp_error'));
      return;
    }
    try {
      state.verifyLocalOtp(name: _name.text, code: _otp.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.tr('auth_success'))));
      Navigator.of(context).pop();
    } on FormatException {
      setState(() => _error = state.tr('auth_otp_error'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(state.tr('auth_title'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.workspace_premium_rounded, color: AppColors.gold, size: 34),
                const SizedBox(height: 10),
                Text(state.tr('auth_vip_title'), style: const TextStyle(color: AppColors.darkGreen, fontSize: 19, fontWeight: FontWeight.w900)),
                const SizedBox(height: 7),
                Text(state.tr('auth_vip_body'), style: const TextStyle(color: AppColors.ink, height: 1.7, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (!_otpStep) ...[
            TextField(
              controller: _name,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: state.tr('auth_name'), prefixIcon: const Icon(Icons.person_outline_rounded)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: state.tr('auth_phone'), hintText: '09123456789', prefixIcon: const Icon(Icons.phone_android_rounded)),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(onPressed: _requestOtp, icon: const Icon(Icons.sms_outlined), label: Text(state.tr('auth_request_otp'))),
          ] else ...[
            Text(state.tr('auth_code_sent'), style: const TextStyle(color: AppColors.ink, height: 1.6)),
            const SizedBox(height: 12),
            TextField(
              controller: _otp,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(labelText: state.tr('auth_otp'), prefixIcon: const Icon(Icons.password_rounded)),
            ),
            Text(state.tr('auth_test_code'), style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800)),
            const SizedBox(height: 18),
            ElevatedButton.icon(onPressed: _verify, icon: const Icon(Icons.verified_user_outlined), label: Text(state.tr('auth_verify'))),
            TextButton(onPressed: () => setState(() => _otpStep = false), child: Text(state.tr('auth_change_phone'))),
          ],
          if (_error != null) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: const Color(0xFFFBEDEA),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFD9A199)),
              ),
              child: Text(_error!, style: const TextStyle(color: Color(0xFF7A281C), height: 1.5)),
            ),
          ],
        ],
      ),
    );
  }
}
