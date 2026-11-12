import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/map_routing.dart';
import '../../state/app_scope.dart';
import '../../widgets/common.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final address = state.tr('contact_address');

    return StepScaffold(
      title: state.tr('contact_title'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.place_rounded, color: AppColors.gold),
                    const SizedBox(width: 8),
                    Text(state.tr('contact_address_label'),
                        style: const TextStyle(
                            color: AppColors.darkGreen,
                            fontWeight: FontWeight.w800,
                            fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 10),
                SelectableText(
                  state.digits(address),
                  style: TextStyle(
                      color: AppColors.ink.withAlpha(210), height: 1.9, fontSize: 14),
                ),
                const SizedBox(height: 10),
                Text(
                  state.digits(state.tr('contact_hours')),
                  style: const TextStyle(
                      color: AppColors.darkGreen, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                TextButton.icon(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await Clipboard.setData(ClipboardData(text: address));
                    messenger.showSnackBar(
                        SnackBar(content: Text(state.tr('contact_copied'))));
                  },
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: Text(state.tr('contact_copy_address')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () => openExternal(
                context, Uri(scheme: 'tel', path: AppConfig.phone)),
            icon: const Icon(Icons.phone_in_talk_rounded),
            label: Text(
                '${state.tr('contact_call')}  ${state.digits(AppConfig.phone)}'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              final ok = await MapRouting.open();
              if (!ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.tr('map_launch_failed'))));
              }
            },
            icon: const Icon(Icons.map_outlined),
            label: Text(state.tr('contact_map')),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => openExternal(
                context, Uri(scheme: 'mailto', path: AppConfig.email)),
            icon: const Icon(Icons.mail_outline_rounded),
            label: Text(state.tr('contact_email')),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => openExternal(context,
                Uri.parse('https://instagram.com/${AppConfig.instagramUser}')),
            icon: const Icon(Icons.camera_alt_outlined),
            label: Text('${state.tr('contact_instagram')}  @${AppConfig.instagramUser}'),
          ),
        ],
      ),
    );
  }
}
