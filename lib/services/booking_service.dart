import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get available flights
  Future<List<Map<String, dynamic>>> getAvailableFlights() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('flights').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting flights: $e');
      return [];
    }
  }

  // Get booked seats for a specific flight
  Future<List<String>> getBookedSeats(String flightId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('flightId', isEqualTo: flightId)
          .get();
      
      List<String> bookedSeats = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['seatNumber'] != null) {
          bookedSeats.add(data['seatNumber']);
        }
      }
      return bookedSeats;
    } catch (e) {
      print('Error getting booked seats: $e');
      return [];
    }
  }

  // Book a seat
  Future<bool> bookSeat({
    required String flightId,
    required String seatNumber,
    required String flightName,
    required String departure,
    required String destination,
    required String date,
    required double price,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return false;

      // Check if seat is already booked
      List<String> bookedSeats = await getBookedSeats(flightId);
      if (bookedSeats.contains(seatNumber)) {
        return false;
      }

      // Create booking
      await _firestore.collection('bookings').add({
        'userId': user.uid,
        'userEmail': user.email,
        'flightId': flightId,
        'flightName': flightName,
        'seatNumber': seatNumber,
        'departure': departure,
        'destination': destination,
        'date': date,
        'price': price,
        'bookingDate': FieldValue.serverTimestamp(),
        'status': 'confirmed',
      });

      return true;
    } catch (e) {
      print('Error booking seat: $e');
      return false;
    }
  }

  // Get user's bookings
  Future<List<Map<String, dynamic>>> getUserBookings() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return [];

      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: user.uid)
          .orderBy('bookingDate', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting user bookings: $e');
      return [];
    }
  }

  // Cancel booking
  Future<bool> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).delete();
      return true;
    } catch (e) {
      print('Error canceling booking: $e');
      return false;
    }
  }
} 