import 'models/station.dart';

/// Configuración central de la app.
///
/// TODO: Reemplaza los valores de `*StreamUrl` con las URLs de transmisión
/// reales de cada estación cuando estén disponibles.
class AppConfig {
  AppConfig._();

  static const String zStreamUrl = 'https://rtn.cdnstream1.com/2567_96.aac';

  static const String website = 'https://hisradio.com';
  static const String facebook = 'https://facebook.com/hisradioz';
  static const String instagram = 'https://instagram.com/hisradioz';

  static const String studioPhone = '+17871234567';
  static const String messageNumber = '+17871234567';
  static const String prayerLine = '+17871234567';
  static const String commentsLine = '+17871234567';
}

const List<Station> kStations = [
  Station(
    name: 'HIS Radio Z',
    slogan: '¡La vida subida de tono!',
    streamUrl: AppConfig.zStreamUrl,
    logo: StationLogoType.z,
  ),
];
