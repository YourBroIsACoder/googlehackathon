import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/complaint.dart';
import '../../providers/auth_provider.dart';
// import '../../services/complaint_service.dart'; // COMMENTED OUT - Using mock
import '../../services/complaint_service_mock.dart' as mock; // Using mock service
import '../../widgets/complaint_card.dart';

class MyComplaintsScreen extends StatelessWidget {
  const MyComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login')),
      );
    }

    final complaintService = mock.ComplaintService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Complaints'),
      ),
      body: StreamBuilder<List<Complaint>>(
        stream: complaintService.getComplaintsForUser(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final complaints = snapshot.data ?? [];

          if (complaints.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No complaints yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Submit your first complaint to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              return ComplaintCard(
                complaint: complaints[index],
                showUserInfo: false,
              );
            },
          );
        },
      ),
    );
  }
}

