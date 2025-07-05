import 'package:flutter/material.dart';
import 'flight_search_screen.dart'; // import this


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Airline Booking Home')),
      body: Center(
        child: ElevatedButton(
          child: Text('Search Flights'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FlightSearchScreen()),
            );
          },
        ),
      ),
    );
  }
}
