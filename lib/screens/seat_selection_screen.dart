import 'package:flutter/material.dart';
import 'booking_confirmation_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String flightName;

  SeatSelectionScreen({required this.flightName});

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  String? selectedSeat;

  final List<String> seats = [
    'A1', 'A2', 'A3', 'A4',
    'B1', 'B2', 'B3', 'B4',
    'C1', 'C2', 'C3', 'C4',
    'D1', 'D2', 'D3', 'D4',
  ];

  void _confirmBooking() {
    if (selectedSeat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a seat')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmationScreen(
          flightName: widget.flightName,
          seatNumber: selectedSeat!,
          date: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select a Seat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: seats.map((seat) {
                final isSelected = selectedSeat == seat;
                return ChoiceChip(
                  label: Text(seat),
                  selected: isSelected,
                  selectedColor: Colors.green,
                  onSelected: (_) {
                    setState(() => selectedSeat = seat);
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _confirmBooking,
              child: Text('Confirm Booking'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
