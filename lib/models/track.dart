class Track {
  final String title;
  final String artist;
  final DateTime when;
  final String? artworkUrl;

  const Track({
    required this.title,
    required this.artist,
    required this.when,
    this.artworkUrl,
  });
}
