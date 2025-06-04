// features/order_tracking/presentation/screens/order_tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// A screen that displays real-time order tracking information.
/// 
/// This screen shows:
/// * A map with the current location of the order
/// * Markers for the store, delivery location, and current position
/// * A route line showing the delivery path
/// * A stepper widget indicating the order status
class OrderTrackingScreen extends StatefulWidget {
  /// The unique identifier for the order being tracked.
  /// 
  /// This ID is used to fetch real-time updates about the order's
  /// location and status from the backend service.
  final String orderId;

  /// Creates an order tracking screen.
  /// 
  /// The [orderId] parameter is required and must correspond to an
  /// existing order in the system. This ID is used to track the
  /// specific order's progress and location.
  const OrderTrackingScreen({required this.orderId, super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final MapController _mapController = MapController();
  final LatLng _center = LatLng(1.3521, 103.8198); // Singapore coordinates
  final List<Marker> _markers = [];
  final List<Polyline> _polylines = [];
  int _currentStep = 1;

  @override
  void initState() {
    super.initState();
    _addMarkersAndPolyline();
  }

  void _addMarkersAndPolyline() {
    // Mock locations
    final storeLocation = LatLng(1.3521, 103.8198);
    final deliveryLocation = LatLng(1.3000, 103.8000);
    final currentLocation = LatLng(1.3200, 103.8100);

    setState(() {
      _markers.addAll([
        // Store marker
        Marker(
          point: storeLocation,
          width: 80,
          height: 80,
          builder: (context) => const Tooltip(
            message: 'Curry Puff Master',
            child: Icon(Icons.store, color: Colors.red, size: 30),
          ),
        ),
        // Delivery location marker
        Marker(
          point: deliveryLocation,
          width: 80,
          height: 80,
          builder: (context) => const Tooltip(
            message: 'Your Location',
            child: Icon(Icons.location_on, color: Colors.blue, size: 30),
          ),
        ),
        // Rider marker
        Marker(
          point: currentLocation,
          width: 80,
          height: 80,
          builder: (context) => const Tooltip(
            message: 'Your Puff!',
            child: Icon(Icons.delivery_dining, color: Colors.green, size: 30),
          ),
        ),
      ]);

      _polylines.add(
        Polyline(
          points: [storeLocation, currentLocation, deliveryLocation],
          color: Colors.blue,
          strokeWidth: 4.0,
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
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _center,
                zoom: 12.0,
                maxZoom: 18.0,
                minZoom: 6.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.currypuffmaster.app',
                ),
                MarkerLayer(markers: _markers),
                PolylineLayer(polylines: _polylines),
              ],
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}