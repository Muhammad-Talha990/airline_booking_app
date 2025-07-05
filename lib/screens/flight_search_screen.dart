import 'package:flutter/material.dart';
import 'flight_results_screen.dart'; // Import the results screen

class FlightSearchScreen extends StatefulWidget {
  @override
  _FlightSearchScreenState createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  String fromCity = 'Karachi';
  String toCity = 'Islamabad';
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _searchFlights() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightResultsScreen(
          from: fromCity,
          to: toCity,
          date:
              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Flights')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: fromCity,
              decoration: InputDecoration(labelText: 'From'),
              items: ['Karachi', 'Lahore', 'Islamabad', 'Quetta']
                  .map((city) => DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => fromCity = value!),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: toCity,
              decoration: InputDecoration(labelText: 'To'),
              items: ['Karachi', 'Lahore', 'Islamabad', 'Quetta']
                  .map((city) => DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => toCity = value!),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date'),
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _searchFlights,
              child: Text('Search Flights'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
