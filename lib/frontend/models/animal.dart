import 'package:flutter/material.dart';

/// Foydalanuvchi hayvoni (Mening hayvonlarim ekrani uchun).
class Animal {
  final String name;
  final String type; // Qoramol, It, Mushuk, Parranda...
  final String breed;
  final String age;
  final String health; // holat matni
  final bool healthy;
  final IconData icon;
  final List<VaccineRecord> vaccines;
  final List<MedicalRecord> medicalLogs;
  final List<ReminderRecord> reminders;

  const Animal({
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.health,
    required this.icon,
    this.healthy = true,
    this.vaccines = const [],
    this.medicalLogs = const [],
    this.reminders = const [],
  });
}

class VaccineRecord {
  final String name;
  final String date;
  final bool completed;

  const VaccineRecord({
    required this.name,
    required this.date,
    this.completed = true,
  });
}

class MedicalRecord {
  final String title;
  final String date;
  final String note;

  const MedicalRecord({
    required this.title,
    required this.date,
    required this.note,
  });
}

class ReminderRecord {
  final String title;
  final String time;
  final String period; // Har kuni, Har haftada, va h.k.

  const ReminderRecord({
    required this.title,
    required this.time,
    required this.period,
  });
}

