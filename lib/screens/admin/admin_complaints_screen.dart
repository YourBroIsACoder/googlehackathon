import 'package:flutter/material.dart';
import '../../models/complaint.dart';
import '../../services/interfaces/interfaces.dart';
import '../../config/service_locator.dart';
import '../../widgets/complaint_card.dart';
import 'complaint_detail_screen.dart';

class AdminComplaintsScreen extends StatefulWidget {
  const AdminComplaintsScreen({super.key});

  @override
  State<AdminComplaintsScreen> createState() => _AdminComplaintsScreenState();
}

class _AdminComplaintsScreenState extends State<AdminComplaintsScreen>
    with SingleTickerProviderStateMixin {
  IComplaintService get _complaintService => ServiceLocator.instance.complaintService;
  late TabController _tabController;
  ComplaintStatus _selectedStatus = ComplaintStatus.open;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _selectedStatus = ComplaintStatus.open;
            break;
          case 1:
            _selectedStatus = ComplaintStatus.inProgress;
            break;
          case 2:
            _selectedStatus = ComplaintStatus.resolved;
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Complaints'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Open', icon: Icon(Icons.pending)),
            Tab(text: 'In Progress', icon: Icon(Icons.work)),
            Tab(text: 'Resolved', icon: Icon(Icons.check_circle)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildComplaintsList(ComplaintStatus.open),
          _buildComplaintsList(ComplaintStatus.inProgress),
          _buildComplaintsList(ComplaintStatus.resolved),
        ],
      ),
    );
  }

  Widget _buildComplaintsList(ComplaintStatus status) {
    return StreamBuilder<List<Complaint>>(
      stream: _complaintService.getComplaintsByStatus(status),
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
                  'No ${status.name} complaints',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          );
        }

        // Sort by priority (1 = High, 2 = Medium, 3 = Low)
        complaints.sort((a, b) => a.priority.compareTo(b.priority));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: complaints.length,
          itemBuilder: (context, index) {
            return ComplaintCard(
              complaint: complaints[index],
              showUserInfo: true,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ComplaintDetailScreen(
                      complaint: complaints[index],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

