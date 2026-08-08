import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import '../theme/app_theme.dart';
import '../widgets/app_top_bar.dart';
import 'player_screen.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppTopBar(),
        Container(
          width: double.infinity,
          color: kGreyBg,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: const Text(
            'HIS Radio Z',
            style: TextStyle(
              color: kGrey,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _Card(
                icon: const Icon(Icons.mic),
                title: 'Micrófono Z en vivo',
                detail: 'Escucha el segmento en vivo',
                onTap: () => openPlayerScreen(context),
              ),
              const SizedBox(height: 12),
              _Card(
                icon: const Icon(Icons.phone),
                title: 'Llamar al estudio',
                detail: AppConfig.studioPhone,
                onTap: () => _launch(context, 'tel:${AppConfig.studioPhone}'),
              ),
              const SizedBox(height: 12),
              _Card(
                icon: const Icon(Icons.chat_bubble),
                title: 'Enviar mensaje al estudio',
                detail: 'Envíanos un mensaje de texto',
                onTap: () => _launch(context, 'sms:${AppConfig.messageNumber}'),
              ),
              const _SectionTitle('Oración - Comentarios'),
              _Card(
                icon: const Icon(Icons.phone),
                title: 'Línea de oración',
                detail: AppConfig.prayerLine,
                onTap: () => _launch(context, 'tel:${AppConfig.prayerLine}'),
              ),
              const SizedBox(height: 12),
              _Card(
                icon: const Icon(Icons.phone),
                title: 'Línea de comentarios',
                detail: AppConfig.commentsLine,
                onTap: () => _launch(context, 'tel:${AppConfig.commentsLine}'),
              ),
              const SizedBox(height: 12),
              _Card(
                icon: const Icon(Icons.language),
                title: 'Visitar sitio web',
                detail: AppConfig.website,
                onTap: () => _launch(context, AppConfig.website),
              ),
              const _SectionTitle('Redes sociales'),
              _Card(
                icon: const FaIcon(FontAwesomeIcons.facebookF),
                title: 'Facebook',
                detail: 'Síguenos en Facebook',
                onTap: () => _launch(context, AppConfig.facebook),
              ),
              const SizedBox(height: 12),
              _Card(
                icon: const FaIcon(FontAwesomeIcons.instagram),
                title: 'Instagram',
                detail: 'Síguenos en Instagram',
                onTap: () => _launch(context, AppConfig.instagram),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launch(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && context.mounted) _toast(context, 'No se pudo abrir: $url');
    } catch (e) {
      if (context.mounted) _toast(context, 'No se pudo abrir: $url');
    }
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 24, 2, 12),
      child: Text(
        title,
        style: const TextStyle(
          color: kGrey,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget icon;
  final String title;
  final String detail;
  final VoidCallback onTap;

  const _Card({
    required this.icon,
    required this.title,
    required this.detail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: kBlack,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconTheme(
                    data: const IconThemeData(color: kYellow, size: 22),
                    child: icon,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: kBlack,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        detail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: kGrey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: kGreyLight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
