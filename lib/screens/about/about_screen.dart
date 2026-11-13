import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../state/app_scope.dart';
import '../../widgets/common.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(state.tr('about_title'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Center(
            child: Container(
              width: 108,
              height: 108,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(color: AppColors.darkGreen, borderRadius: BorderRadius.circular(32), boxShadow: [BoxShadow(color: AppColors.darkGreen.withAlpha(35), blurRadius: 24, offset: const Offset(0, 10))]),
              child: ClipRRect(borderRadius: BorderRadius.circular(22), child: Image.asset('assets/images/rayan_garden_logo.jpg', fit: BoxFit.contain)),
            ),
          ),
          const SizedBox(height: 18),
          Center(child: Text(state.tr('app_name'), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: AppColors.darkGreen))),
          const SizedBox(height: 6),
          Center(child: Text(state.tr('about_tagline'), style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, letterSpacing: 1.2))),
          const SizedBox(height: 28),
          AppCard(
            child: Column(children: [
              _InfoRow(icon: Icons.verified_outlined, label: state.tr('about_version'), value: AppConfig.versionLabel),
              const Divider(height: 26),
              _InfoRow(icon: Icons.schedule_rounded, label: state.tr('about_hours'), value: '${AppConfig.openingTime} – ${AppConfig.closingTime}'),
            ]),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(state.tr('about_management_title'), style: const TextStyle(color: AppColors.darkGreen, fontSize: 17, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(state.tr('about_management_body'), style: const TextStyle(height: 1.7, color: AppColors.ink)),
              const SizedBox(height: 14),
              Row(children: [const Icon(Icons.cloud_done_outlined, color: AppColors.success), const SizedBox(width: 8), Expanded(child: Text(state.tr('about_backend_preserved'), style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w700)))]),
            ]),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(state.tr('about_local_backend_title'), style: const TextStyle(color: AppColors.darkGreen, fontSize: 17, fontWeight: FontWeight.w800)),
                const SizedBox(height: 7),
                Text(state.tr('about_local_backend_body'), style: const TextStyle(color: AppColors.ink, height: 1.65, fontSize: 13)),
                const SizedBox(height: 12),
                Text(state.tr('about_registered_count', {'n': '${state.localBackend.customers.length}'}), style: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    final result = state.sendLocalPromotionalSms();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.tr('about_sms_sent', {'n': '${result.recipientCount}'}))));
                  },
                  icon: const Icon(Icons.sms_rounded),
                  label: Text(state.tr('about_send_sms')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(onPressed: state.toggleLanguage, icon: const Icon(Icons.translate_rounded), label: Text(state.tr('about_switch_language'))),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.creamDeep, borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: AppColors.darkGreen, size: 21)),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(color: AppColors.muted))),
        Text(value, style: const TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.w800)),
      ]);
}
