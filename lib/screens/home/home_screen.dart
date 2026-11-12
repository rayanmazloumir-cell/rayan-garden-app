import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../state/app_scope.dart';
import '../../widgets/common.dart';
import '../about/about_screen.dart';
import '../contact/contact_screen.dart';
import '../services/services_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _TopBar(state: state)),
            SliverToBoxAdapter(child: _Hero(state: state)),
            SliverToBoxAdapter(child: _QuickActions(state: state)),
            SliverToBoxAdapter(child: _SectionHeading(title: state.tr('home_services_title'), action: state.tr('home_view_all'))),
            SliverToBoxAdapter(child: _ServiceHighlights(state: state)),
            SliverToBoxAdapter(child: _ExperienceCard(state: state)),
            SliverToBoxAdapter(child: _FooterLinks(state: state)),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.state});
  final dynamic state;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 12),
        child: Row(children: [
          Container(width: 51, height: 51, padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.darkGreen, borderRadius: BorderRadius.circular(17)), child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset('assets/images/rayan_garden_logo.jpg', fit: BoxFit.contain))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(state.tr('app_name'), style: const TextStyle(color: AppColors.darkGreen, fontSize: 20, fontWeight: FontWeight.w900)), const SizedBox(height: 2), Text(state.tr('home_overline'), style: const TextStyle(color: AppColors.gold, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w800))])),
          IconButton(onPressed: state.toggleLanguage, tooltip: state.tr('lang_switch'), icon: const Icon(Icons.translate_rounded, color: AppColors.darkGreen)),
          IconButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const AboutScreen())), tooltip: state.tr('about_title'), icon: const Icon(Icons.tune_rounded, color: AppColors.darkGreen)),
        ]),
      );
}

class _Hero extends StatelessWidget {
  const _Hero({required this.state});
  final dynamic state;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(alignment: AlignmentDirectional.bottomStart, children: [
            AspectRatio(aspectRatio: 0.94, child: Image.asset('assets/images/rayan_garden_home.png', width: double.infinity, fit: BoxFit.cover)),
            Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, AppColors.darkGreen.withAlpha(225)])))),
            Padding(padding: const EdgeInsets.fromLTRB(22, 22, 22, 23), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7), decoration: BoxDecoration(color: AppColors.gold.withAlpha(225), borderRadius: BorderRadius.circular(30)), child: Text(state.tr('home_badge'), style: const TextStyle(color: AppColors.darkGreen, fontSize: 11, fontWeight: FontWeight.w900))),
              const SizedBox(height: 12),
              Text(state.tr('home_tagline'), style: const TextStyle(color: Colors.white, fontSize: 29, height: 1.25, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(state.tr('home_location'), style: const TextStyle(color: AppColors.goldLight, fontSize: 13, fontWeight: FontWeight.w700)),
            ])),
          ]),
        ),
      );
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.state});
  final dynamic state;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 24), child: Column(children: [
        ElevatedButton.icon(onPressed: () { state.resetBooking(); Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ServicesScreen())); }, icon: const Icon(Icons.calendar_month_rounded), label: Text(state.tr('home_book'))),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: OutlinedButton.icon(onPressed: () => openExternal(context, Uri(scheme: 'tel', path: AppConfig.phone)), icon: const Icon(Icons.phone_in_talk_rounded, size: 19), label: Text(state.tr('home_call')))),
          const SizedBox(width: 10),
          Expanded(child: OutlinedButton.icon(onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ContactScreen())), icon: const Icon(Icons.place_outlined, size: 19), label: Text(state.tr('home_contact_short')))),
        ]),
      ]));
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.action});
  final String title;
  final String action;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(22, 0, 22, 12), child: Row(children: [Expanded(child: Text(title, style: const TextStyle(color: AppColors.darkGreen, fontSize: 20, fontWeight: FontWeight.w900))), Text(action, style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w800))]));
}

class _ServiceHighlights extends StatelessWidget {
  const _ServiceHighlights({required this.state});
  final dynamic state;
  @override
  Widget build(BuildContext context) => SizedBox(height: 128, child: ListView.separated(padding: const EdgeInsets.symmetric(horizontal: 20), scrollDirection: Axis.horizontal, itemCount: 5, separatorBuilder: (_, __) => const SizedBox(width: 12), itemBuilder: (_, i) {
        final labels = ['home_service_bride', 'home_service_formal', 'home_service_children', 'home_service_family', 'home_service_cafe'];
        final mins = [120, 180, 60, 60, 120];
        final icons = [Icons.favorite_border_rounded, Icons.auto_awesome_rounded, Icons.child_care_rounded, Icons.groups_rounded, Icons.local_cafe_rounded];
        return Container(width: 155, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: i.isEven ? AppColors.darkGreen : AppColors.forest, borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: AppColors.darkGreen.withAlpha(22), blurRadius: 14, offset: const Offset(0, 6))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icons[i], color: AppColors.goldLight, size: 24), const Spacer(), Text(state.tr(labels[i]), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)), const SizedBox(height: 3), Text(state.digits(state.tr('duration_min', {'n': '${mins[i]}'})), style: const TextStyle(color: AppColors.goldLight, fontSize: 11, fontWeight: FontWeight.w700))]));
      }));
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.state});
  final dynamic state;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(20, 27, 20, 18), child: AppCard(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.creamDeep, borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.auto_awesome_rounded, color: AppColors.gold)), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(state.tr('home_intro_title'), style: const TextStyle(color: AppColors.darkGreen, fontSize: 16, fontWeight: FontWeight.w900)), const SizedBox(height: 7), Text(state.tr('home_intro_body'), style: const TextStyle(color: AppColors.ink, height: 1.75, fontSize: 13))]))])));
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks({required this.state});
  final dynamic state;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 30), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [TextButton.icon(onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const AboutScreen())), icon: const Icon(Icons.info_outline_rounded, size: 18), label: Text(state.tr('about_title'))), const SizedBox(width: 8), Text('v${AppConfig.versionLabel}', style: const TextStyle(color: AppColors.muted, fontSize: 11))]));
}
