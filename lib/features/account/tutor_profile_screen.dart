import 'package:flutter/material.dart';
import 'package:tutor/common/models/tutor_profile.dart';
import 'package:tutor/services/api_service.dart';


class TutorProfileScreen extends StatefulWidget {
  const TutorProfileScreen({super.key});

  @override
  _TutorProfileScreenState createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  late Future<TutorProfile> profile;

  @override
  void initState(){
    super.initState();
    profile = ApiService.getProfile();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutor Profile')),
      body: FutureBuilder<TutorProfile>(
        future: profile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No profile data found.'));
          }

          final profile = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(profile.avatar),
                ),
                const SizedBox(height: 16),
                Text('Full Name: ${profile.fullName}'),
                Text('Email: ${profile.email}'),
                Text('Phone: ${profile.phone}'),
                Text('Balance: ${profile.balance.toStringAsFixed(0)} VND'),
               
              ],
            ),
          );
        },
      ),
    );
  }
}