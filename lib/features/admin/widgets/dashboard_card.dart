import 'package:flutter/material.dart';

class DashboardStat {
  final String title;
  final int value;
  final IconData icon;

  DashboardStat({required this.title, required this.value, required this.icon});
}

class DashboardCard extends StatelessWidget {
  final DashboardStat stat;

  const DashboardCard({super.key, required this.stat});

@override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 160,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(stat.icon, size: 30, color: Colors.blue),
              const SizedBox(height: 12),
              Text(stat.value.toString(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(stat.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
