import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _isAscending = true; // Track sorting order
  String _sortField = 'Date'; // Track the selected sorting field

  // Sample ticket data
  List<Map<String, String>> _tickets = [
    {'status': 'en cours', 'date': '15-06-2022', 'time': '11:45'},
    {'status': 'en attente', 'date': '14-06-2024', 'time': '10:30'},
    {'status': 'en cours', 'date': '16-06-2024', 'time': '09:15'},
    {'status': 'en attente', 'date': '11-06-2024', 'time': '08:00'},
    {'status': 'en cours', 'date': '14-06-2024', 'time': '07:45'},
    {'status': 'en attente', 'date': '13-06-2024', 'time': '07:30'},
  ];

  // Function to sort tickets based on the selected field and order
  void _sortTickets() {
    setState(() {
      _tickets.sort((a, b) {
        int comparison;
        if (_sortField == 'Date') {
          comparison = a['date']!.compareTo(b['date']!);
        } else if (_sortField == 'Status') {
          comparison = a['status']!.compareTo(b['status']!);
        } else {
          comparison = a['time']!.compareTo(b['time']!);
        }
        return _isAscending ? comparison : -comparison;
      });
      _isAscending = !_isAscending; // Toggle sorting order
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE42320),
        title: const Text(
          'Liste des Tiquets',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Search and Filter Row
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 2,
                              blurRadius: 13,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Search TextField
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'chercher',
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                                ),
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ),
                            // Vertical Divider
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.grey.shade300,
                              margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                            // Dropdown for Sorting Field
                            DropdownButton<String>(
                              underline: const SizedBox(), // Removes the underline
                              value: _sortField,
                              items: <String>['Date', 'Status', 'Time']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _sortField = newValue!;
                                  _sortTickets();
                                });
                              },
                            ),
                            // Sort Icon with GestureDetector
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: _sortTickets, // Sort tickets on tap
                                child: Icon(
                                  _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              // Tickets List
              Expanded(
                child: ListView.builder(
                  itemCount: _tickets.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: const Text(
                        'En panne',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        _tickets[index]['status']!,
                        style: TextStyle(
                          color: _tickets[index]['status'] == 'en cours' ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _tickets[index]['date']!,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            _tickets[index]['time']!,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}