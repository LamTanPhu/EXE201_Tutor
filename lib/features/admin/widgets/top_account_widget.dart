import 'package:flutter/material.dart';
import 'package:tutor/common/models/statistic_data.dart';
import 'package:tutor/services/api_service.dart';

class TopAccountWidget extends StatefulWidget {
  const TopAccountWidget({super.key});

  @override
  State<TopAccountWidget> createState() => _TopAccountWidgetState();
}

class _TopAccountWidgetState extends State<TopAccountWidget> {
  late final Future<TopAccount> _topAccountFuture;

  @override
  void initState() {
    super.initState();
    _topAccountFuture = ApiService.getTopAccountReport();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Tutor by Completed Courses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder<TopAccount>(
              future: _topAccountFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('No top account available');
                }

                final account = snapshot.data!;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('No.')),
                      DataColumn(label: Text('Full Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Completed Courses')),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text('1')),
                        DataCell(Text(account.fullName ?? 'N/A')),
                        DataCell(Text(account.email ?? 'N/A')),
                        DataCell(Text('${account.completedCourses ?? 0}')),
                      ])
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
