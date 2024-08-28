import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tripsage/screens/like_page.dart';
import 'package:tripsage/screens/visited_page.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:like_button/like_button.dart';
import 'package:async_button_builder/async_button_builder.dart';

class SecondPage extends StatefulWidget {
  final int heroTag;
  final List<String> likedPlaces;
  final Map<String, String> tourPlanData;

  const SecondPage({
    Key? key,
    required this.heroTag,
    required this.likedPlaces,
    required this.tourPlanData,
  }) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int _currentIndex = 0;
  final Set<Marker> _markers = {};
  late List<String> _likedPlaces;
  late List<String> _visitedPlaces;
  late List<Map<String, String>> _landmarksData;

  @override
  void initState() {
    super.initState();
    _likedPlaces = widget.likedPlaces;
    _visitedPlaces = [];
    _loadCSV();
  }

  Future<void> _loadCSV() async {
    final rawData = await rootBundle.loadString('assets/tripsage_DB_Seoul.csv');
    List<List<dynamic>> listData =
        const CsvToListConverter().convert(rawData, eol: '\n');
    _landmarksData = listData.skip(1).map((data) {
      return {
        'id': data[0].toString(),
        'name': data[1].toString(),
        'category': data[2].toString(),
        'description': data[3].toString(),
        'landmark_en': data[4].toString(),
        'category_en': data[5].toString(),
        'explanation_en': data[6].toString(),
        'gps': data[7].toString(),
        'address': data[8].toString(),
      };
    }).toList();

    _addMarkers();
  }

  LatLng _parseGPS(String gpsString) {
    final cleanedString = gpsString.replaceAll(RegExp(r'[^\d.,-]'), '');
    final parts = cleanedString.split(',');

    final lat = double.parse(parts[0].trim());
    final lng = double.parse(parts[1].trim());

    return LatLng(lat, lng);
  }

  void _addMarkers() {
    for (var landmark in _landmarksData) {
      LatLng position = _parseGPS(landmark['gps']!);

      _markers.add(
        _createMarker(
          position,
          landmark['name']!,
          landmark['address']!,
          landmark['description']!,
        ),
      );
    }

    setState(() {});
  }

  Marker _createMarker(
      LatLng position, String title, String snippet, String description) {
    return Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: InfoWindow(
        title: title,
        snippet: snippet,
        onTap: () {
          _showActionDialog(title, description);
        },
      ),
    );
  }

  void _showActionDialog(String title, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(description),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LikeButton(
                    size: 30,
                    onTap: (bool isLiked) async {
                      if (!isLiked) {
                        setState(() {
                          _likedPlaces.add(title);
                        });
                      }
                      await Future.delayed(Duration(milliseconds: 1200));
                      return !isLiked;
                    },
                  ),
                  AsyncButtonBuilder(
                    child: const Text(
                      'Visited Here',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    loadingWidget: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                    successWidget: const Icon(
                      Icons.check,
                      color: Colors.purpleAccent,
                    ),
                    onPressed: () async {
                      await Future.delayed(Duration(seconds: 2));
                      setState(() {
                        _visitedPlaces.add(title);
                      });
                    },
                    loadingSwitchInCurve: Curves.bounceInOut,
                    loadingTransitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1.0),
                          end: const Offset(0, 0),
                        ).animate(animation),
                        child: child,
                      );
                    },
                    builder: (context, child, callback, state) {
                      return IconButton(
                        iconSize: 30,
                        icon: child,
                        onPressed: callback,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      GoogleMapWidget(likedPlaces: _likedPlaces, markers: _markers),
      LikePage(
          likedPlaces: _likedPlaces,
          tourPlanData: widget.tourPlanData), // tourPlanData 전달
      VisitedPage(visitedPlaces: _visitedPlaces),
      const Center(child: Text("Profile")),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.purple,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite_border),
            title: const Text("Likes"),
            selectedColor: Colors.pink,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.search),
            title: const Text("Search"),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}

class GoogleMapWidget extends StatefulWidget {
  final List<String> likedPlaces;
  final Set<Marker> markers;

  const GoogleMapWidget({
    Key? key,
    required this.likedPlaces,
    required this.markers,
  }) : super(key: key);

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController _mapController;
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng _kGwanghwamun = LatLng(37.5759, 126.9769);

  static const CameraPosition _initialPosition = CameraPosition(
    target: _kGwanghwamun,
    zoom: 14.0,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _initialPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _mapController = controller;
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          markers: widget.markers,
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.1,
          right: 10,
          child: FloatingActionButton(
            onPressed: _goToInitialPosition,
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }

  Future<void> _goToInitialPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(_kGwanghwamun),
    );
  }
}
