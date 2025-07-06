import 'package:flutter/material.dart';
import 'flight_results_screen.dart';

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
    if (fromCity == toCity) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Departure and destination cannot be the same'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightResultsScreen(
          from: fromCity,
          to: toCity,
          date: "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Flights'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.lightBlue],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Find Your Perfect Flight',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Search for flights to your destination',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Search Form Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // From City
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'From',
                            prefixIcon: const Icon(Icons.flight_takeoff),
                            border: const OutlineInputBorder(),
                            suffixIcon: PopupMenuButton<String>(
                              icon: const Icon(Icons.arrow_drop_down),
                              onSelected: (value) {
                                setState(() => fromCity = value);
                              },
                              itemBuilder: (context) => [
                                'Karachi', 'Lahore', 'Islamabad', 'Quetta',
                                'Peshawar', 'Multan', 'Faisalabad'
                              ].map((city) => PopupMenuItem(
                                value: city,
                                child: Text(city),
                              )).toList(),
                            ),
                          ),
                          controller: TextEditingController(text: fromCity),
                        ),
                        const SizedBox(height: 20),
                        
                        // To City
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'To',
                            prefixIcon: const Icon(Icons.flight_land),
                            border: const OutlineInputBorder(),
                            suffixIcon: PopupMenuButton<String>(
                              icon: const Icon(Icons.arrow_drop_down),
                              onSelected: (value) {
                                setState(() => toCity = value);
                              },
                              itemBuilder: (context) => [
                                'Karachi', 'Lahore', 'Islamabad', 'Quetta',
                                'Peshawar', 'Multan', 'Faisalabad'
                              ].map((city) => PopupMenuItem(
                                value: city,
                                child: Text(city),
                              )).toList(),
                            ),
                          ),
                          controller: TextEditingController(text: toCity),
                        ),
                        const SizedBox(height: 20),
                        
                        // Date Selection
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 12),
                                Text(
                                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                const Text(
                                  'Select Date',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Search Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _searchFlights,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Search Flights',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
