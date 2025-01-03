import 'package:aqar_detailes/data.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(Data.lat, Data.lng),
    zoom: 17,
  );

  Set<Marker> marker = {
    Marker(
      markerId: const MarkerId("1"),
      position: LatLng(Data.lat, Data.lng),
      infoWindow: InfoWindow(
        title: Data.isDragable ? "Drag The Marker to RealEstate location" : Data.DetailesRE[0]['Title'],
      ),
      draggable: Data.isDragable ? true : false,
      onDragEnd: (LatLng location) {
        Data.lat = location.latitude;
        Data.lng = location.longitude;
        print("=========================================");
        print("Lat: ${Data.lat}");
        print("Lng: ${Data.lng}");
        print("=========================================");
      },
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: GoogleMap(
          markers: marker,
          mapType: MapType.hybrid,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {},
        ),
      ),
    );
  }
}
