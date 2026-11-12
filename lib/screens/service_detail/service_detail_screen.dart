import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../state/app_scope.dart';
import '../../widgets/common.dart';
import '../calendar/calendar_screen.dart';

class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final service = state.service;
    if (service == null) {
      return StepScaffold(
        title: state.tr('detail_title'),
        child: const SizedBox.shrink(),
      );
    }
    final minutes = state.durationOf(service);
    final description = (service.description != null && service.description!.isNotEmpty)
        ? service.description!
        : state.tr('detail_default_desc');

    return StepScaffold(
      title: state.tr('detail_title'),
      step: 2,
      bottom: ElevatedButton.icon(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const CalendarScreen()),
        ),
        icon: const Icon(Icons.calendar_month_rounded),
        label: Text(state.tr('detail_book')),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        children: [
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.displayName(state.isFa),
                  style: const TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (minutes != null) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded,
                          color: AppColors.gold, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${state.tr('detail_duration')}: ${state.digits(state.tr('duration_min', {'n': '$minutes'}))}',
                        style: const TextStyle(
                            color: AppColors.ink, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
                for (final row in [
                  if (service.price != null)
                    '${state.tr('detail_price')}: ${state.digits(service.price!)}',
                  if (service.deposit != null)
                    '${state.tr('detail_deposit')}: ${state.digits(service.deposit!)}',
                ]) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.payments_outlined,
                          color: AppColors.gold, size: 20),
                      const SizedBox(width: 8),
                      Text(row,
                          style: const TextStyle(
                              color: AppColors.ink, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
                const SizedBox(height: 18),
                Text(
                  state.tr('detail_about'),
                  style: const TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                      color: AppColors.ink.withAlpha(200), height: 1.9, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
