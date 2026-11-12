import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../state/app_scope.dart';
import '../../widgets/common.dart';
import '../contact/contact_screen.dart';
import '../services/services_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _Header()),
              SliverToBoxAdapter(child: _Hero()),
              SliverToBoxAdapter(child: _Actions()),
              SliverToBoxAdapter(child: _Intro()),
              SliverToBoxAdapter(child: SizedBox(height: 28)),
            ],
          ),
        ),
      );
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      child: Row(children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFE5C399),
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/rayan_garden_logo.jpg',
            width: 48,
            height: 48,
            fit: BoxFit.contain, // show the whole logo, never crop it
            errorBuilder: (context, error, stackTrace) => const Text(
              'R',
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 29,
                fontWeight: FontWeight.w800,
                fontFamily: 'serif',
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(state.tr('app_name'),
                  style: const TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  )),
              const SizedBox(height: 2),
              const Text('RAYAN GARDEN',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 10,
                    letterSpacing: 2.2,
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
        ),
        TextButton(
          onPressed: state.toggleLanguage,
          child: Text(state.tr('lang_switch')),
        ),
      ]),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(alignment: AlignmentDirectional.bottomStart, children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Image.asset(
              'assets/images/rayan_garden_home.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 150,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xCC10251E)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.tr('home_location'),
                    style: const TextStyle(
                      color: Color(0xFFE6D7AD),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 7),
                Text(state.tr('home_tagline'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      height: 1.35,
                      fontWeight: FontWeight.w800,
                    )),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: [
        ElevatedButton.icon(
          onPressed: () {
            state.resetBooking();
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ServicesScreen()),
            );
          },
          icon: const Icon(Icons.calendar_month_rounded),
          label: Text(state.tr('home_book')),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () =>
              openExternal(context, Uri(scheme: 'tel', path: AppConfig.phone)),
          icon: const Icon(Icons.phone_in_talk_rounded),
          label: Text(state.tr('home_call')),
        ),
        const SizedBox(height: 4),
        TextButton.icon(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const ContactScreen()),
          ),
          icon: const Icon(Icons.place_outlined),
          label: Text(state.tr('home_contact')),
        ),
      ]),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(state.tr('home_intro_title'),
            style: const TextStyle(
              color: AppColors.darkGreen,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            )),
        const SizedBox(height: 8),
        Text(
          state.tr('home_intro_body'),
          style: TextStyle(
              color: AppColors.ink.withAlpha(199), fontSize: 14, height: 1.9),
        ),
      ]),
    );
  }
}
