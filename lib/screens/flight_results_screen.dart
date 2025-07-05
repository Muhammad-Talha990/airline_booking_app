import 'package:flutter/material.dart';
import 'seat_selection_screen.dart';

class FlightResultsScreen extends StatelessWidget {
  final String from;
  final String to;
  final String date;

  FlightResultsScreen({
    required this.from,
    required this.to,
    required this.date,
  });

  final List<Map<String, String>> dummyFlights = [
    {
      'flight': 'PK-301',
      'airline': 'PIA',
      'time': '12:00 PM - 2:30 PM',
      'price': '18000',
    },
    {
      'flight': 'AB-721',
      'airline': 'Airblue',
      'time': '1:30 PM - 3:45 PM',
      'price': '16500',
    },
    {
      'flight': 'EY-121',
      'airline': 'SereneAir',
      'time': '4:00 PM - 6:00 PM',
      'price': '19500',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Flights')),
      body: ListView.builder(
        itemCount: dummyFlights.length,
        itemBuilder: (context, index) {
          final flight = dummyFlights[index];
          return Card(
            margin: EdgeInsets.all(12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Side: Flight Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${flight['airline']} ${flight['flight']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('From: $from → $to'),
                        Text('Time: ${flight['time']}'),
                        Text('Date: $date'),
                      ],
                    ),
                  ),

                  // Right Side: Price and Book Button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rs. ${flight['price']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeatSelectionScreen(
                                flightName:
                                    '${flight['airline']} ${flight['flight']}',
                              ),
                            ),
                          );
                        },
                        child: Text('Book Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
