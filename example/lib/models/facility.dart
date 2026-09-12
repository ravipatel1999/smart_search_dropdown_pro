import 'package:flutter/material.dart';

class Facility {
  final String id;
  final String name;
  final String location;
  final String category;
  final String status;
  final Color statusColor;
  final double rating;
  final int reviewCount;
  final bool isOpen;
  final IconData icon;
  final Color avatarColor;
  final bool isRecent;
  final bool isPopular;

  const Facility({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.status,
    required this.statusColor,
    required this.rating,
    required this.reviewCount,
    required this.isOpen,
    required this.icon,
    required this.avatarColor,
    this.isRecent = false,
    this.isPopular = false,
  });

  static const List<Facility> mockFacilities = [
    Facility(
      id: '1',
      name: 'Sunshine Hospital',
      location: 'New Delhi, India',
      category: 'Multi-speciality',
      status: 'Active',
      statusColor: Colors.green,
      rating: 4.5,
      reviewCount: 120,
      isOpen: true,
      icon: Icons.local_hospital_rounded,
      avatarColor: Colors.orange,
      isRecent: true,
    ),
    Facility(
      id: '2',
      name: 'Everest Hospital',
      location: 'Bhopal, Madhya Pradesh',
      category: 'Multi-speciality',
      status: 'Partner',
      statusColor: Colors.blue,
      rating: 4.2,
      reviewCount: 98,
      isOpen: true,
      icon: Icons.local_hospital_rounded,
      avatarColor: Colors.teal,
      isRecent: true,
    ),
    Facility(
      id: '3',
      name: 'City Care Hospital',
      location: 'Indore, Madhya Pradesh',
      category: 'General Hospital',
      status: 'Pending',
      statusColor: Colors.amber,
      rating: 4.8,
      reviewCount: 210,
      isOpen: false,
      icon: Icons.local_hospital_rounded,
      avatarColor: Colors.cyan,
      isPopular: true,
    ),
    Facility(
      id: '4',
      name: 'LifeLine Medical Center',
      location: 'Mumbai, Maharashtra',
      category: 'General Hospital',
      status: 'Inactive',
      statusColor: Colors.red,
      rating: 4.0,
      reviewCount: 75,
      isOpen: true,
      icon: Icons.medical_services_rounded,
      avatarColor: Colors.indigo,
      isPopular: true,
    ),
    Facility(
      id: '5',
      name: 'Apex Medical Center',
      location: 'Bangalore, Karnataka',
      category: 'Specialty Clinic',
      status: 'Active',
      statusColor: Colors.green,
      rating: 4.7,
      reviewCount: 145,
      isOpen: true,
      icon: Icons.health_and_safety_rounded,
      avatarColor: Colors.purple,
    ),
  ];
}
