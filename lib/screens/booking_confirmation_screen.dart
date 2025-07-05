import 'package:flutter/material.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String flightName;
  final String seatNumber;
  final String date;

  BookingConfirmationScreen({
    required this.flightName,
    required this.seatNumber,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking Confirmation')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 100),
              SizedBox(height: 20),
              Text(
                'Booking Confirmed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Text('Flight: $flightName'),
              Text('Seat: $seatNumber'),
              Text('Date: $date'),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('Back to Home'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
