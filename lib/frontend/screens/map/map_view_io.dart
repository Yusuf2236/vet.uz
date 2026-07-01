import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Faqat Android/iOS'da haqiqiy Yandex xarita qaytaradi.
/// Linux/macOS/Windows desktop'da — `null` (ekran fallback ishlatadi),
/// chunki Yandex MapKit u platformalarda mavjud emas.
Widget? platformYandexMap() {
  if (Platform.isAndroid || Platform.isIOS) {
    return const _YandexMapView();
  }
  return null;
}

/// Toshkent markazidagi Yandex xaritasi.
/// (API kalit native sozlamada: Android MainActivity / iOS AppDelegate.)
class _YandexMapView extends StatefulWidget {
  const _YandexMapView();

  @override
  State<_YandexMapView> createState() => _YandexMapViewState();
}

class _YandexMapViewState extends State<_YandexMapView> {
  // Toshkent markazi
  static const Point _tashkent = Point(
    latitude: 41.311081,
    longitude: 69.240562,
  );

  @override
  Widget build(BuildContext context) {
    return YandexMap(
      onMapCreated: (YandexMapController controller) {
        controller.moveCamera(
          CameraUpdate.newCameraPosition(
            const CameraPosition(target: _tashkent, zoom: 11),
          ),
        );
      },
    );
  }
}
