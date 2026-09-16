import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_search_dropdown_pro/smart_search_dropdown.dart';

/// Patient model for healthcare demonstration.
class Patient {
  final String id;
  final String name;
  final String mrn;
  final int age;
  final String gender;
  final String primaryCondition;

  const Patient({
    required this.id,
    required this.name,
    required this.mrn,
    required this.age,
    required this.gender,
    required this.primaryCondition,
  });

  @override
  String toString() => '$name (MRN: $mrn)';
}

/// Simulated healthcare patient database repository.
class HealthcareRepository {
  static final List<Patient> _mockPatients = List.generate(
    100,
    (index) => Patient(
      id: 'P-${1000 + index}',
      name:
          '${const ['Eleanor Vance', 'James Wilson', 'Sophia Martinez', 'Marcus Chen', 'Amara Okafor', 'Liam O\'Connor', 'Elena Rostova', 'Aarav Patel', 'Chloe Dubois', 'Noah Kowalski'][index % 10]} ${index + 1}',
      mrn: 'MRN-${90000 + index}',
      age: 20 + (index * 7) % 65,
      gender: index % 2 == 0 ? 'Female' : 'Male',
      primaryCondition: [
        'Type 2 Diabetes',
        'Hypertension',
        'Asthma',
        'Coronary Artery Disease',
        'Rheumatoid Arthritis',
      ][index % 5],
    ),
  );

  /// Simulated API search with artificial latency for testing race condition safety.
  static Future<DropdownPageResult<Patient>> fetchPatients({
    required String query,
    required int page,
    int pageSize = 10,
    int delayMs = 300,
  }) async {
    await Future.delayed(Duration(milliseconds: delayMs));

    final q = query.trim().toLowerCase();
    final filtered = _mockPatients.where((p) {
      if (q.isEmpty) return true;
      return p.name.toLowerCase().contains(q) ||
          p.mrn.toLowerCase().contains(q) ||
          p.primaryCondition.toLowerCase().contains(q);
    }).toList();

    final startIndex = (page - 1) * pageSize;
    if (startIndex >= filtered.length) {
      return DropdownPageResult(items: [], hasMore: false);
    }

    final endIndex = (startIndex + pageSize < filtered.length)
        ? startIndex + pageSize
        : filtered.length;

    final items = filtered.sublist(startIndex, endIndex);
    final hasMore = endIndex < filtered.length;

    return DropdownPageResult(items: items, hasMore: hasMore);
  }
}

/// Healthcare Patient Lookup Demo Screen.
class PatientDemoScreen extends StatefulWidget {
  const PatientDemoScreen({super.key});

  @override
  State<PatientDemoScreen> createState() => _PatientDemoScreenState();
}

class _PatientDemoScreenState extends State<PatientDemoScreen> {
  Patient? _selectedPatient;
  List<Patient> _selectedTeam = [];
  final SmartDropdownController<Patient> _controller = SmartDropdownController<Patient>();
  String _lastSimulatedQuery = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Healthcare Search Demo'),
        backgroundColor: const Color(0xFF006699),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue.shade50,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 24),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.local_hospital, color: Color(0xFF006699), size: 32),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Healthcare EHR Patient Search with MRN & Stale Response Protection',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004466),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Text(
              'Single Patient Search (Paged Loader)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SmartSearchDropdown<Patient>(
              controller: _controller,
              labelText: 'Select Patient *',
              hintText: 'Search by Name, MRN, or Condition...',
              prefixIcon: const Icon(Icons.person_search, color: Color(0xFF006699)),
              loader: (query, page) => HealthcareRepository.fetchPatients(
                query: query,
                page: page,
                pageSize: 10,
              ),
              itemLabelBuilder: (patient) => patient.name,
              itemSubtitleBuilder: (patient) =>
                  'MRN: ${patient.mrn} • Age: ${patient.age} • ${patient.primaryCondition}',
              itemAvatarBuilder: (patient) => CircleAvatar(
                backgroundColor: const Color(0xFF006699).withValues(alpha: 0.15),
                child: Text(
                  patient.name.characters.first,
                  style: const TextStyle(
                    color: Color(0xFF006699),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onChanged: (patient) {
                setState(() {
                  _selectedPatient = patient;
                });
              },
            ),
            const SizedBox(height: 24),
            if (_selectedPatient != null)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Patient Details',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const Divider(),
                      Text(
                        _selectedPatient!.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('MRN: ${_selectedPatient!.mrn}'),
                      Text('Age/Gender: ${_selectedPatient!.age} / ${_selectedPatient!.gender}'),
                      Text('Primary Condition: ${_selectedPatient!.primaryCondition}'),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 32),
            const Text(
              'Multi-Patient Care Team Selection',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SmartSearchDropdown<Patient>.multi(
              labelText: 'Assign Patients to Care Group',
              hintText: 'Search patients...',
              prefixIcon: const Icon(Icons.groups, color: Color(0xFF006699)),
              loader: (query, page) => HealthcareRepository.fetchPatients(
                query: query,
                page: page,
                pageSize: 10,
              ),
              itemLabelBuilder: (p) => p.name,
              itemSubtitleBuilder: (p) => 'MRN: ${p.mrn}',
              onMultiChanged: (patients) {
                setState(() {
                  _selectedTeam = patients;
                });
              },
            ),
            const SizedBox(height: 16),
            if (_selectedTeam.isNotEmpty)
              Wrap(
                spacing: 8,
                children: _selectedTeam
                    .map((p) => Chip(
                          avatar: const Icon(Icons.badge, size: 16),
                          label: Text('${p.name} (${p.mrn})'),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 32),
            Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Race Condition & Stale Response Simulation',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Last Query Executed: $_lastSimulatedQuery'),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.flash_on),
                      label: const Text('Simulate Rapid Out-of-Order Queries'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006699),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        setState(() {
                          _lastSimulatedQuery = 'Fired: "A" (500ms delay) then "B" (100ms delay)';
                        });
                        // Fire query 'A' with 500ms delay
                        _controller.setSearchQuery('A');
                        // Immediately fire query 'B' with 100ms delay
                        await Future.delayed(const Duration(milliseconds: 50));
                        _controller.setSearchQuery('B');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
