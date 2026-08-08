class SampleTrack {
  final String title;
  final String artist;
  final String artworkUrl;

  const SampleTrack({
    required this.title,
    required this.artist,
    required this.artworkUrl,
  });
}

const List<SampleTrack> kSampleTracks = [
  SampleTrack(
    title: 'Billion Years',
    artist: 'Trip Lee, Taylor Hill',
    artworkUrl:
        'https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/a8/29/6a/a8296a14-ff68-9869-aff3-b1c3bb022712/195497141487.jpg/300x300bb.jpg',
  ),
  SampleTrack(
    title: 'Enough',
    artist: 'Branan Murphy',
    artworkUrl:
        'https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/0d/b3/6c/0db36cac-00b3-c182-e41d-8ce8fcebf5e2/886446688893.jpg/300x300bb.jpg',
  ),
  SampleTrack(
    title: 'Solo',
    artist: 'Ryan Ellis',
    artworkUrl:
        'https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/03/3b/55/033b550e-2285-2d8d-6288-9ebcc010f345/196871173438.jpg/300x300bb.jpg',
  ),
  SampleTrack(
    title: 'Miracles',
    artist: 'KB, Lecrae',
    artworkUrl:
        'https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/c9/dd/f1/c9ddf168-71ac-e2be-ab36-2cdf3d30d762/196871242509.jpg/300x300bb.jpg',
  ),
];

String? artworkForTitle(String title) {
  final t = title.trim().toLowerCase();
  for (final s in kSampleTracks) {
    if (t.contains(s.title.toLowerCase())) return s.artworkUrl;
  }
  return null;
}
