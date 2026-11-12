import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/jalali.dart';
import '../../data/api/api_exception.dart';
import '../../state/app_scope.dart';
import '../../widgets/common.dart';
import '../result/result_screen.dart';

class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen({super.key});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  ApiException? _error;

  Future<void> _submit() async {
    final state = AppScope.read(context);
    if (state.submitting) return;
    setState(() => _error = null);
    try {
      await state.submit();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const ResultScreen()),
        (route) => route.isFirst,
      );
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final service = state.service;
    final date = state.date;
    final slot = state.slot;
    final minutes = service == null ? null : state.durationOf(service);

    final rows = <MapEntry<String, String>>[
      MapEntry(state.tr('confirm_service'), service?.displayName(state.isFa) ?? ''),
      if (minutes != null)
        MapEntry(state.tr('confirm_duration'),
            state.digits(state.tr('duration_min', {'n': '$minutes'}))),
      if (service?.price != null)
        MapEntry(state.tr('detail_price'), state.digits(service!.price!)),
      if (service?.deposit != null)
        MapEntry(state.tr('detail_deposit'), state.digits(service!.deposit!)),
      MapEntry(
        state.tr('confirm_date'),
        date == null
            ? ''
            : '${state.digits(jalaliLongDate(date, state.isFa))}\n${isoDate(date)}',
      ),
      MapEntry(state.tr('confirm_time'), slot == null ? '' : state.digits(slot.label)),
      MapEntry(state.tr('confirm_name'), state.name),
      MapEntry(state.tr('confirm_phone'), state.digits(state.phone)),
      MapEntry(state.tr('confirm_notes'),
          state.notes.isEmpty ? state.tr('confirm_none') : state.notes),
    ];

    return StepScaffold(
      title: state.tr('confirm_title'),
      step: 7,
      bottom: ElevatedButton.icon(
        onPressed: state.submitting ? null : _submit,
        icon: state.submitting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.check_circle_outline_rounded),
        label: Text(state.submitting
            ? state.tr('confirm_submitting')
            : state.tr('confirm_submit')),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        children: [
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Column(
              children: [
                for (var i = 0; i < rows.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: AppColors.gold.withAlpha(60)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 84,
                          child: Text(
                            rows[i].key,
                            style: TextStyle(
                              color: AppColors.ink.withAlpha(150),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            rows[i].value,
                            style: const TextStyle(
                              color: AppColors.darkGreen,
                              fontWeight: FontWeight.w700,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.gold),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.tr('confirm_notice'),
                  style: TextStyle(
                      color: AppColors.ink.withAlpha(180), fontSize: 13, height: 1.8),
                ),
              ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 14),
            ErrorBox(error: _error!),
            if (_error!.kind == ApiErrorKind.timeout ||
                _error!.kind == ApiErrorKind.network) ...[
              const SizedBox(height: 10),
              Text(
                state.tr('confirm_uncertain'),
                style: TextStyle(
                    color: AppColors.ink.withAlpha(190), fontSize: 13, height: 1.8),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
