import 'package:flutter/material.dart';
import '../services/booking_service.dart';
import 'booking_confirmation_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String flightId;
  final String flightName;
  final String departure;
  final String destination;
  final String date;
  final double price;

  SeatSelectionScreen({
    required this.flightId,
    required this.flightName,
    required this.departure,
    required this.destination,
    required this.date,
    required this.price,
  });

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final BookingService _bookingService = BookingService();
  String? selectedSeat;
  List<String> bookedSeats = [];
  bool _isLoading = true;

  final List<String> seats = [
    'A1', 'A2', 'A3', 'A4', 'A5', 'A6',
    'B1', 'B2', 'B3', 'B4', 'B5', 'B6',
    'C1', 'C2', 'C3', 'C4', 'C5', 'C6',
    'D1', 'D2', 'D3', 'D4', 'D5', 'D6',
    'E1', 'E2', 'E3', 'E4', 'E5', 'E6',
  ];

  @override
  void initState() {
    super.initState();
    _loadBookedSeats();
  }

  Future<void> _loadBookedSeats() async {
    try {
      final booked = await _bookingService.getBookedSeats(widget.flightId);
      setState(() {
        bookedSeats = booked;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading seat data: $e')),
      );
    }
  }

  void _confirmBooking() async {
    if (selectedSeat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a seat')),
      );
      return;
    }

    // Check if seat is already booked
    if (bookedSeats.contains(selectedSeat)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This seat is already booked. Please select another seat.')),
      );
      return;
    }

    final success = await _bookingService.bookSeat(
      flightId: widget.flightId,
      seatNumber: selectedSeat!,
      flightName: widget.flightName,
      departure: widget.departure,
      destination: widget.destination,
      date: widget.date,
      price: widget.price,
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmationScreen(
            flightName: widget.flightName,
            seatNumber: selectedSeat!,
            date: widget.date,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to book seat. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Seat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBookedSeats,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flight Info Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.flightName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(widget.departure),
                              const SizedBox(width: 16),
                              const Icon(Icons.arrow_forward),
                              const SizedBox(width: 16),
                              Text(widget.destination),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('Date: ${widget.date}'),
                          Text('Price: \$${widget.price.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Seat Legend
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Available'),
                      const SizedBox(width: 16),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Booked'),
                      const SizedBox(width: 16),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Selected'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Seat Grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: seats.length,
                      itemBuilder: (context, index) {
                        final seat = seats[index];
                        final isBooked = bookedSeats.contains(seat);
                        final isSelected = selectedSeat == seat;
                        
                        Color seatColor;
                        if (isBooked) {
                          seatColor = Colors.red;
                        } else if (isSelected) {
                          seatColor = Colors.blue;
                        } else {
                          seatColor = Colors.green;
                        }

                        return GestureDetector(
                          onTap: isBooked ? null : () {
                            setState(() {
                              selectedSeat = seat;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: seatColor,
                              borderRadius: BorderRadius.circular(8),
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 2)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                seat,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isBooked ? 10 : 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: selectedSeat != null ? _confirmBooking : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Confirm Booking',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
