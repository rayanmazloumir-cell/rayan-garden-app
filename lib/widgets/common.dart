import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/theme/app_colors.dart';
import '../data/api/api_exception.dart';
import '../state/app_scope.dart';
import '../state/app_state.dart';

/// Total number of steps shown in the booking progress bar.
const int kBookingSteps = 7;

/// Page frame for every booking step: title, progress bar, body, bottom button.
class StepScaffold extends StatelessWidget {
  const StepScaffold({
    super.key,
    required this.title,
    required this.child,
    this.step,
    this.bottom,
    this.actions,
  });

  final String title;
  final int? step;
  final Widget child;
  final Widget? bottom;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          ...?actions,
          TextButton(
            onPressed: state.toggleLanguage,
            child: Text(state.tr('lang_switch')),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (step != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.digits(state.tr('step_of',
                          {'n': '$step', 't': '$kBookingSteps'})),
                      style: TextStyle(
                        color: AppColors.ink.withAlpha(150),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: step! / kBookingSteps,
                        minHeight: 6,
                        backgroundColor: AppColors.gold.withAlpha(50),
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(child: child),
            if (bottom != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: bottom,
              ),
          ],
        ),
      ),
    );
  }
}

/// Rounded warm-white card used across the app.
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.onTap, this.padding});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.whiteWarm,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.gold.withAlpha(90)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.gold),
          const SizedBox(height: 14),
          Text(state.tr('loading'),
              style: TextStyle(color: AppColors.ink.withAlpha(170))),
        ],
      ),
    );
  }
}

/// Friendly text for an [ApiException] in the current language.
String describeError(AppState state, ApiException e) {
  if (e.statusCode == 403) return state.tr('err_forbidden');
  final server = e.serverMessage;
  if (server != null && server.isNotEmpty && !const {'bad', 'method', 'server', 'forbidden'}.contains(server.toLowerCase().trim())) return server;
  switch (e.kind) {
    case ApiErrorKind.network:
      return state.tr('err_network');
    case ApiErrorKind.timeout:
      return state.tr('err_timeout');
    case ApiErrorKind.format:
      return state.tr('err_format');
    case ApiErrorKind.server:
    case ApiErrorKind.rejected:
      return state.tr('err_server');
  }
}

/// Error message with optional technical details (useful to report a problem).
class ErrorBox extends StatelessWidget {
  const ErrorBox({super.key, required this.error});

  final ApiException error;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFBEDEA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD9A199)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline_rounded, color: Color(0xFFA33A2B)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  describeError(state, error),
                  style: const TextStyle(
                      color: Color(0xFF7A281C), height: 1.7, fontSize: 14),
                ),
              ),
            ],
          ),
          if (error.kind == ApiErrorKind.server || error.kind == ApiErrorKind.network)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(state.tr('error_recovery_hint'), style: TextStyle(color: AppColors.ink.withAlpha(175), fontSize: 12, height: 1.6)),
            ),
        ],
      ),
    );
  }
}

/// Full-area error with a retry button.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, required this.onRetry});

  final ApiException error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 30),
        ErrorBox(error: error),
        const SizedBox(height: 18),
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(state.tr('retry')),
        ),
      ],
    );
  }
}

/// Opens a tel:/mailto:/https: link; shows a message when it is impossible.
Future<void> openExternal(BuildContext context, Uri uri) async {
  final state = AppScope.read(context);
  final messenger = ScaffoldMessenger.of(context);
  var ok = false;
  try {
    ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    ok = false;
  }
  if (!ok) {
    messenger.showSnackBar(SnackBar(content: Text(state.tr('launch_failed'))));
  }
}

/// Chevron that points in the "forward" direction for the current text direction.
IconData forwardIcon(BuildContext context) =>
    Directionality.of(context) == TextDirection.rtl
        ? Icons.chevron_left_rounded
        : Icons.chevron_right_rounded;
