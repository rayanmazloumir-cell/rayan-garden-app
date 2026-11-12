import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/jalali.dart';
import '../../state/app_scope.dart';
import '../../state/app_state.dart';
import '../../widgets/common.dart';
import '../contact/contact_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  /// Shows the server status as sent; only a few universal English words are
  /// translated for readability. Anything else is displayed unchanged.
  String _statusText(AppState state, String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'pending':
        return state.tr('status_pending');
      case 'confirmed':
        return state.tr('status_confirmed');
      case 'cancelled':
      case 'canceled':
        return state.tr('status_cancelled');
      default:
        return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final result = state.result;
    if (result == null) {
      return StepScaffold(
        title: state.tr('result_title'),
        child: const SizedBox.shrink(),
      );
    }
    final service = state.service;
    final date = state.date;
    final slot = state.slot;

    return StepScaffold(
      title: state.tr('result_title'),
      bottom: ElevatedButton(
        onPressed: () {
          state.resetBooking();
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: Text(state.tr('result_home')),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        children: [
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.darkGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: AppColors.gold, size: 40),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            state.tr('result_success'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.darkGreen,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(state.tr('result_ref'),
                    style: TextStyle(color: AppColors.ink.withAlpha(160))),
                const SizedBox(height: 8),
                SelectableText(
                  result.ref,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                if (result.status != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withAlpha(40),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${state.tr('result_status')}: ${_statusText(state, result.status!)}',
                      style: const TextStyle(
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await Clipboard.setData(ClipboardData(text: result.ref));
                    messenger.showSnackBar(
                        SnackBar(content: Text(state.tr('result_copied'))));
                  },
                  icon: const Icon(Icons.copy_rounded),
                  label: Text(state.tr('result_copy')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            state.tr('result_keep'),
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.ink.withAlpha(170), fontSize: 13),
          ),
          if (service != null && date != null && slot != null) ...[
            const SizedBox(height: 14),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.displayName(state.isFa),
                      style: const TextStyle(
                          color: AppColors.darkGreen,
                          fontWeight: FontWeight.w800,
                          fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(
                    state.digits(
                        '${jalaliLongDate(date, state.isFa)} · ${slot.label}'),
                    style: TextStyle(color: AppColors.ink.withAlpha(200)),
                  ),
                ],
              ),
            ),
          ],
          if (result.payment.isNotEmpty) ...[
            const SizedBox(height: 14),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.tr('result_payment'),
                      style: const TextStyle(
                          color: AppColors.darkGreen,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  for (final e in result.payment.entries)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: SelectableText('${e.key}: ${e.value}',
                          style: const TextStyle(height: 1.6)),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ContactScreen()),
            ),
            icon: const Icon(Icons.place_outlined),
            label: Text(state.tr('home_contact')),
          ),
        ],
      ),
    );
  }
}
