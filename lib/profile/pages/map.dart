import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app2/auth/bloc/sandyq_list_bloc.dart';
import 'package:flutter_app2/models/models.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:ui' as ui;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controllerCompleter = Completer();
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Marker? currentLocationMarker;

  static const CameraPosition _defaultLocation = CameraPosition(
    target: LatLng(43.2389, 76.8897),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    context.read<SandyqListBloc>().add(FetchReasstarans());
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (!_controllerCompleter.isCompleted) {
      _controllerCompleter.complete(controller);
    }
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Разрешение на местоположение отклонено');
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      debugPrint('Разрешение на местоположение навсегда отклонено');
      return;
    }
    debugPrint('Разрешение на местоположение получено');
  }

  Future<BitmapDescriptor> _createCustomMarker() async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = ui.Canvas(pictureRecorder);
    const size = ui.Size(40, 40);

    final paint = ui.Paint()..color = const Color.fromARGB(255, 255, 255, 255);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.account_circle_outlined.codePoint),
        style: const TextStyle(
          color: Color.fromARGB(255, 14, 13, 13),
          fontSize: 40,
          fontFamily: 'MaterialIcons',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        size.height / 2 - textPainter.height / 2,
      ),
    );

    final image = await pictureRecorder.endRecording().toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }

  Future<LatLng> _getLatLngFromAddress(String? address, int index) async {
    if (address != null && address.trim().isNotEmpty) {
      final fullAddress = "${address.trim()}, Казахстан";
      try {
        List<Location> locations = await locationFromAddress(fullAddress);
        if (locations.isNotEmpty) {
          debugPrint(
            "✅ Геокодинг '$fullAddress' → ${locations.first.latitude}, ${locations.first.longitude}",
          );
          return LatLng(locations.first.latitude, locations.first.longitude);
        }
      } catch (e) {
        debugPrint("❌ Ошибка геокодинга для '$fullAddress': $e");
      }
    }
    debugPrint("⚠️ Фолбэк для индекса $index");
    return LatLng(43.2389 + (index * 0.005), 76.8897 + (index * 0.005));
  }

  Future<void> _updateMarkersFromApi(List<ReasstaransList> restaurants) async {
    debugPrint(
      "=== Начинаем строить маркеры: ${restaurants.length} ресторанов",
    );

    List<Future<Marker>> markerFutures = [];
    for (int i = 0; i < restaurants.length; i++) {
      markerFutures.add(_buildMarker(restaurants[i], i));
    }

    final List<Marker> apiMarkers = await Future.wait(markerFutures);
    debugPrint("=== Маркеры готовы: ${apiMarkers.length} штук");

    if (!mounted) return;

    setState(() {
      markers = {...markers, ...apiMarkers};
    });

    final controller = await _controllerCompleter.future;
    if (!mounted) return;

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(target: LatLng(43.2389, 76.8897), zoom: 12),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final nearbyMarkers = markers
        .where((m) => _isNearAlmaty(m.position))
        .toSet();

    if (nearbyMarkers.isNotEmpty) {
      controller.animateCamera(
        CameraUpdate.newLatLngBounds(_getBounds(nearbyMarkers), 80),
      );
    }
  }

  bool _isNearAlmaty(LatLng pos) {
    const almatyLat = 43.2389;
    const almatyLng = 76.8897;
    final latDiff = (pos.latitude - almatyLat).abs();
    final lngDiff = (pos.longitude - almatyLng).abs();
    return latDiff < 0.5 && lngDiff < 0.5;
  }

  Future<Marker> _buildMarker(ReasstaransList res, int index) async {
    debugPrint(
      "=== Ресторан #$index: name=${res.name}, address=${res.address}",
    );
    final position = await _getLatLngFromAddress(res.address, index);
    debugPrint(
      "=== Позиция #$index: ${position.latitude}, ${position.longitude}",
    );

    return Marker(
      markerId: MarkerId(res.id.toString()),
      position: position,
      infoWindow: InfoWindow(
        title: res.name ?? 'Ресторан',
        snippet: res.address ?? 'Адрес не указан',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
  }

  LatLngBounds _getBounds(Set<Marker> allMarkers) {
    if (allMarkers.isEmpty) {
      return LatLngBounds(
        southwest: _defaultLocation.target,
        northeast: _defaultLocation.target,
      );
    }
    double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;
    for (var m in allMarkers) {
      if (m.position.latitude < minLat) minLat = m.position.latitude;
      if (m.position.latitude > maxLat) maxLat = m.position.latitude;
      if (m.position.longitude < minLng) minLng = m.position.longitude;
      if (m.position.longitude > maxLng) maxLng = m.position.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  // ✅ Вынесли логику кнопки в отдельный метод с mounted проверками
  Future<void> _onLocationButtonPressed() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // ✅ Проверяем mounted после каждого await
      if (!mounted) return;

      final controller = await _controllerCompleter.future;
      if (!mounted) return;

      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ),
      );

      final customIcon = await _createCustomMarker();
      if (!mounted) return;

      setState(() {
        currentLocationMarker = Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(title: 'Ваше местоположение'),
          icon: customIcon,
        );
      });
    } catch (e) {
      debugPrint('Ошибка получения местоположения: $e');
      if (!mounted) return;
      final controller = await _controllerCompleter.future;
      if (!mounted) return;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(_defaultLocation),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SandyqListBloc, SandyqListState>(
      buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
      listener: (context, state) async {
        debugPrint(
          "=== STATE: isLoading=${state.isLoading}, users=${state.users.length}",
        );
        if (!state.isLoading && state.users.isNotEmpty) {
          await _updateMarkersFromApi(state.users);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: _defaultLocation,
                markers: {
                  ...markers,
                  currentLocationMarker,
                }.whereType<Marker>().toSet(),
                zoomControlsEnabled: false,
              ),
              if (state.isLoading)
                const Center(child: CircularProgressIndicator()),
              Positioned(
                right: 16,
                bottom: 100,
                child: Column(
                  children: [
                    FloatingActionButton(
                      mini: true,
                      onPressed: () async {
                        final controller = await _controllerCompleter.future;
                        if (!mounted) return;
                        controller.animateCamera(CameraUpdate.zoomIn());
                      },
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.add, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      mini: true,
                      onPressed: () async {
                        final controller = await _controllerCompleter.future;
                        if (!mounted) return;
                        controller.animateCamera(CameraUpdate.zoomOut());
                      },
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.remove, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            // ✅ Используем вынесенный метод
            onPressed: _onLocationButtonPressed,
            backgroundColor: const Color.fromRGBO(210, 49, 49, 1),
            child: const Icon(Icons.location_searching, color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}
