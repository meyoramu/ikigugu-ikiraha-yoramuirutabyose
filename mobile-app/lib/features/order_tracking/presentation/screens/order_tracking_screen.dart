// features/order_tracking/presentation/screens/order_tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(1.3521, 103.8198); // Singapore coordinates
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  int _currentStep = 1;

  @override
  void initState() {
    super.initState();
    _addMarkersAndPolyline();
  }

  void _addMarkersAndPolyline() {
    // Mock locations
    const storeLocation = LatLng(1.3521, 103.8198);
    const deliveryLocation = LatLng(1.3000, 103.8000);
    const currentLocation = LatLng(1.3200, 103.8100);

    setState(() {
      _markers.add(
        const Marker(
          markerId: MarkerId('store'),
          position: storeLocation,
          infoWindow: InfoWindow(title: 'Curry Puff Master'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
      
      _markers.add(
        const Marker(
          markerId: MarkerId('delivery'),
          position: deliveryLocation,
          infoWindow: InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
      
      _markers.add(
        Marker(
          markerId: const MarkerId('rider'),
          position: currentLocation,
          infoWindow: const InfoWindow(title: 'Your Puff!'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
      
      _polylines.add(
        const Polyline(
          polylineId: PolylineId('route'),
          points: [storeLocation, currentLocation, deliveryLocation],
          color: Colors.blue,
          width: 5,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Order'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 12.0,
              ),
              markers: _markers,
              polylines: _polylines,
            ),
          ),
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              onStepTapped: (step) => setState(() => _currentStep = step),
              steps: const [
                Step(
                  title: Text('Order Placed'),
                  content: Text('Your puff is being prepared'),
                  isActive: true,
                ),
                Step(
                  title: Text('On the Way'),
                  content: Text('Your puff is out for delivery'),
                  isActive: true,
                ),
                Step(
                  title: Text('Delivered'),
                  content: Text('Enjoy your puff!'),
                  isActive: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}