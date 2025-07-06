import 'package:flutter/material.dart';
import '../services/booking_service.dart';
import 'seat_selection_screen.dart';

class FlightResultsScreen extends StatefulWidget {
  final String from;
  final String to;
  final String date;

  FlightResultsScreen({
    required this.from,
    required this.to,
    required this.date,
  });

  @override
  _FlightResultsScreenState createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends State<FlightResultsScreen> {
  final BookingService _bookingService = BookingService();
  List<Map<String, dynamic>> flights = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  Future<void> _loadFlights() async {
    setState(() => _isLoading = true);
    try {
      // For demo purposes, we'll create dummy flights
      // In a real app, this would come from the booking service
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        flights = [
          {
            'id': 'flight_1',
            'flight': 'PK-301',
            'airline': 'PIA',
            'time': '12:00 PM - 2:30 PM',
            'price': 18000.0,
            'departure': widget.from,
            'destination': widget.to,
            'date': widget.date,
          },
          {
            'id': 'flight_2',
            'flight': 'AB-721',
            'airline': 'Airblue',
            'time': '1:30 PM - 3:45 PM',
            'price': 16500.0,
            'departure': widget.from,
            'destination': widget.to,
            'date': widget.date,
          },
          {
            'id': 'flight_3',
            'flight': 'EY-121',
            'airline': 'SereneAir',
            'time': '4:00 PM - 6:00 PM',
            'price': 19500.0,
            'departure': widget.from,
            'destination': widget.to,
            'date': widget.date,
          },
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading flights: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Flights'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFlights,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : flights.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.flight,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No flights found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try different dates or routes',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadFlights,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: flights.length,
                    itemBuilder: (context, index) {
                      final flight = flights[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Flight Header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${flight['airline']} ${flight['flight']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          flight['time'],
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Text(
                                      'Available',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // Route Info
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.flight_takeoff, size: 16),
                                            const SizedBox(width: 8),
                                            Text(
                                              flight['departure'],
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.flight_land, size: 16),
                                            const SizedBox(width: 8),
                                            Text(
                                              flight['destination'],
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward, size: 20),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // Price and Book Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Price',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Rs. ${flight['price'].toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SeatSelectionScreen(
                                            flightId: flight['id'],
                                            flightName: '${flight['airline']} ${flight['flight']}',
                                            departure: flight['departure'],
                                            destination: flight['destination'],
                                            date: flight['date'],
                                            price: flight['price'],
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Book Now'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
