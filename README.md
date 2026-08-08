# HIS Radio Z

Aplicación móvil (Flutter) para escuchar **HIS Radio Z** en vivo, ver la playlist de canciones reproducidas, acceder al podcast y ponerse en contacto con el estudio (llamadas, mensajes, oración, redes sociales).

## Requisitos

- Flutter SDK `^3.12.2` (Dart 3.12 o superior)
- Android Studio / Xcode según la plataforma objetivo
- Conexión a internet (streaming y carátulas de iTunes)

## Puesta en marcha

```bash
# 1. Instalar dependencias
flutter pub get

# 2. Ejecutar en un dispositivo/emulador
flutter run

# 3. (Opcional) Build de release
flutter build apk --release        # Android
flutter build ios --release        # iOS
```

## Cómo se configura (manual)

Toda la configuración de la app vive en `lib/config.dart`. No es necesario tocar nada más del código para cambiar estaciones, enlaces o teléfonos.

### 1. URL de transmisión (stream)

En `lib/config.dart`:

```dart
static const String zStreamUrl = 'https://rtn.cdnstream1.com/2567_96.aac';
```

Reemplázala por la URL real del stream de la estación (puede ser `.aac`, `.mp3`, `.m3u8`, etc.). La app soporta metadatos ICY: si el servidor los envía, el título y el artista en pantalla se actualizan automáticamente.

### 2. Contacto y redes sociales

Mismas constantes en `lib/config.dart`:

```dart
static const String website = 'https://hisradio.com';
static const String facebook = 'https://facebook.com/hisradioz';
static const String instagram = 'https://instagram.com/hisradioz';

static const String studioPhone = '+17871234567';   // tel:
static const String messageNumber = '+17871234567'; // sms:
static const String prayerLine = '+17871234567';    // tel:
static const String commentsLine = '+17871234567';  // tel:
```

> Los números deben ir con código de país (`+1`, `+52`, etc.) porque se abren con los esquemas `tel:` y `sms:`.

### 3. Lista de estaciones

`kStations` en `lib/config.dart`. Cada estación se define con el modelo `Station` (`lib/models/station.dart`):

```dart
const List<Station> kStations = [
  Station(
    name: 'HIS Radio Z',
    slogan: '¡La vida subida de tono!',
    streamUrl: AppConfig.zStreamUrl,
    logo: StationLogoType.z,
  ),
];
```

| Campo      | Descripción                                          |
| ---------- | ---------------------------------------------------- |
| `name`     | Nombre visible de la estación                        |
| `slogan`   | Eslogan que aparece como subtítulo                   |
| `streamUrl`| URL de la transmisión                                |
| `logo`     | Tipo de logo (ver abajo)                             |

Para añadir estaciones, agrega más entradas a `kStations`. La primera de la lista es la que se reproduce por defecto (`PlayerController` usa `kStations.first`).

### 4. Tipos de logo

En `lib/models/station.dart`, el enum `StationLogoType` define qué logo se dibuja cuando no hay carátula de canción disponible:

```dart
enum StationLogoType { z, speaker, waves, vinyl }
```

Los estilos se dibujan en `lib/widgets/station_badge.dart`. Si creas una estación, asígnale el tipo que corresponda o añade uno nuevo en el badge.

### 5. Playlist de muestra (tracks)

En `lib/utils/artwork.dart`, la lista `kSampleTracks` es el contenido de ejemplo que se muestra en la pantalla **Playlist** antes de que haya historial real:

```dart
const List<SampleTrack> kSampleTracks = [ /* ... */ ];
```

Cada `SampleTrack` tiene `title`, `artist` y `artworkUrl`. `artworkForTitle()` devuelve la carátula local cuando una canción del stream coincide con alguno de estos títulos; si no, la app la busca en iTunes.

### 6. Colores y tema

En `lib/theme/app_theme.dart` se definen los colores de la marca y `buildTheme()`:

```dart
const Color kYellow = Color(0xFFFFCE00); // color principal de la marca
const Color kBlack = Color(0xFF000000);
// ... resto de la paleta
```

### 7. Nombre de la aplicación

- Android: `android:label` en `android/app/src/main/AndroidManifest.xml`
- iOS: `CFBundleDisplayName` en `ios/Runner/Info.plist`

### 8. Título de la app (navegador de tareas / `MaterialApp`)

En `lib/main.dart`:

```dart
title: 'HIS Radio Z',
```

## Estructura del proyecto

```
lib/
├── main.dart                 # Punto de entrada y MaterialApp
├── config.dart               # ⚙️ TODA la configuración (stream, contactos, estaciones)
├── models/
│   ├── station.dart          # Modelo Station y enum StationLogoType
│   └── track.dart            # Modelo Track (historial/playlist)
├── controllers/
│   ├── player_controller.dart# Reproducción con just_audio + metadatos ICY
│   └── nav_controller.dart   # Índice de la navegación inferior
├── screens/
│   ├── app_shell.dart        # Scaffold principal, drawer y navegación
│   ├── home_screen.dart      # Escuchar en vivo
│   ├── playlist_screen.dart  # Reproduciendo ahora / reproducido antes
│   ├── podcast_screen.dart   # Podcast
│   ├── connect_screen.dart   # Contacto y redes
│   └── player_screen.dart    # Pantalla del reproductor
├── theme/app_theme.dart      # Paleta de colores y tema Material 3
├── utils/artwork.dart        # SampleTracks y búsqueda local de carátulas
└── widgets/                  # Widgets reutilizables (top bar, bottom nav, mini player…)
```

## Cómo tiene que ser (reglas de estructura)

- **Toda la configuración** (URLs, teléfonos, redes, estaciones) **únicamente** en `lib/config.dart`. Nunca hardcodear una URL o un teléfono dentro de una pantalla o controlador.
- Las estaciones se agregan como entradas de `kStations`, nunca editando pantallas.
- `PlayerController` es un singleton (`PlayerController.instance`) y emite cambios con `notifyListeners()`; las pantallas se suscriben con `AnimatedBuilder`.
- Las carátulas se resuelven en este orden: 1) metadatos ICY del stream, 2) coincidencia en `kSampleTracks`, 3) búsqueda en iTunes (`_lookupArtwork`).
- Los textos de la interfaz están en español.
- Los widgets visuales van en `lib/widgets/`, las pantallas en `lib/screens/` y la lógica en `lib/controllers/`.

## Tests

```bash
flutter test
```

Incluye `test/widget_test.dart` y `test/logo_preview_test.dart`.

## Dependencias principales

- `just_audio` — reproducción de audio (streaming)
- `url_launcher` — llamadas (`tel:`), SMS (`sms:`) y enlaces externos
- `font_awesome_flutter` — iconos de redes sociales
