import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderPickLocationController extends GetxController {

  RxBool isLoading = false.obs;
  RxString locationPicker = "".obs;

  GoogleMapController? mapController;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  final Rx<LatLng> initialPosition = const LatLng(0, 0).obs; // Dhaka
  final Rx<LatLng> cameraTarget = const LatLng(0, 0).obs;

  final RxSet<Marker> markers = <Marker>{}.obs;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    Future.delayed(Duration(microseconds: 120),() async {
      await plannerPickLocationPlaceLatLng();
    });
  }

  Future<void> moveToLocation({
    required double lat,
    required double lng,
    required String title,
  }) async {
    final position = LatLng(lat, lng);
    latitude.value = lat;
    longitude.value = lng;
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 15),
      ),
    );

    markers.value = {
      Marker(
        markerId: const MarkerId("selected_place"),
        position: position,
        infoWindow: InfoWindow(title: title),
      ),
    };
  }

  Future<void> pickLocationFromMap(LatLng position) async {
    latitude.value = position.latitude;
    longitude.value = position.longitude;
    initialPosition.value = position;
    cameraTarget.value = position;
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;
      locationPicker.value = "${place.street} ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
    } catch (_) {
      locationPicker.value = "${position.latitude}, ${position.longitude}";
    }

    markers.value = {
      Marker(
        markerId: const MarkerId("selected_place"),
        position: position,
        infoWindow: InfoWindow(title: locationPicker.value),
      ),
    };
  }

  void onCameraMove(CameraPosition position) {
    cameraTarget.value = position.target;
  }

  Future<void> pickCameraCenterLocation() async {
    await pickLocationFromMap(cameraTarget.value);
  }

  /// Check & request permission
  static Future<void> _handlePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permission permanently denied';
    }
  }

  /// Get current position
  static Future<Position> getCurrentPosition() async {
    await _handlePermission();
    return await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.best));
  }

  /// Get address from latitude & longitude
  Future<void> plannerPickLocationPlaceLatLng() async {
    await getCurrentPosition().then((position) async {
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;
      locationPicker.value = "${place.street} ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
      initialPosition.value = LatLng(latitude.value, longitude.value);
      cameraTarget.value = initialPosition.value;
      isLoading.value = false;
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: initialPosition.value, zoom: 15),
        ),
      );

      markers.value = {
        Marker(
          markerId: const MarkerId("selected_place"),
          position: initialPosition.value,
          infoWindow: InfoWindow(title: locationPicker.value),
        ),
      };
    });
  }


}
