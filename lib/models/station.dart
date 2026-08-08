enum StationLogoType { z, speaker, waves, vinyl }

class Station {
  final String name;
  final String slogan;
  final String streamUrl;
  final StationLogoType logo;

  const Station({
    required this.name,
    required this.slogan,
    required this.streamUrl,
    required this.logo,
  });
}
