import 'package:emee/pages/chatroom/chatroom_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class ActivePage extends StatefulWidget {
  const ActivePage({super.key});

  @override
  State<ActivePage> createState() => _ActivePageState();
}

class _ActivePageState extends State<ActivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Report'),
      ),
      body: StreamBuilder(
        stream: getAdminLocation(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError) {
            return Center(child: Text("Error : ${snapshot.error}"),);
          }
      
          if(!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No data"));
          }
          return Column(
            children: [
              Text(
                'hi'
              )
              // SizedBox(
              //   height: 200,
              //   width: double.infinity,
              //   child: FlutterMap(
              //     mapController: MapController(),
              //     options : MapOptions(
              //       initialCenter: selectedLatLng,
              //       initialZoom: 17,
              //       onTap: (tapPosition, latLng) {
              //         setState(() {
              //           selectedLatLng = latLng;
              //         });
              //         if (_mapReady) {
              //           _mapController.move(latLng, 16);
              //         }
              //       },
              //     ),
              //     children : [
              //       TileLayer(
              //         urlTemplate: 'https://api.maptiler.com/maps/base-v4/{z}/{x}/{y}.png?key=P40e2FSbT2joZsUYelmi',
              //         userAgentPackageName: 'com.example.emee',
              //       ),
              //       RichAttributionWidget(
              //         attributions: [
              //           TextSourceAttribution(
              //             '© MapTiler © OpenStreetMap contributors',
              //             // onTap: () => launchUrl(
              //             //   Uri.parse('https://www.maptiler.com/copyright/'),
              //             // ),
              //           ),
              //         ],
              //       ),
              //       MarkerLayer(
              //         markers: [
              //           Marker(
              //             point: selectedLatLng,
              //             width: 40,
              //             height: 40,
              //             child: const Icon(
              //               Icons.location_pin,
              //               color: Colors.red,
              //               size: 40,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ]
              //   ),
              // ),
            ],
          );
        }
      ),
    );
  }
}