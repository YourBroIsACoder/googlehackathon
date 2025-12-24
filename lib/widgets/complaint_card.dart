import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart'; // COMMENTED OUT - No Firebase Storage
import 'package:intl/intl.dart';
import '../models/complaint.dart';

class ComplaintCard extends StatelessWidget {
  final Complaint complaint;
  final bool showUserInfo;
  final VoidCallback? onTap;

  const ComplaintCard({
    super.key,
    required this.complaint,
    this.showUserInfo = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                complaint.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      complaint.categoryDisplayName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      complaint.statusDisplayName,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: _getStatusColor(complaint.status),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                complaint.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (showUserInfo) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      complaint.userName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              if (complaint.imageUrl != null)
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, color: Colors.grey),
                        SizedBox(height: 4),
                        Text(
                          'Image',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      complaint.address ?? 'Location: ${complaint.latitude.toStringAsFixed(4)}, ${complaint.longitude.toStringAsFixed(4)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      complaint.priorityDisplayName,
                      style: const TextStyle(fontSize: 10),
                    ),
                    backgroundColor: _getPriorityColor(complaint.priority),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Submitted: ${DateFormat('MMM dd, yyyy HH:mm').format(complaint.createdAt)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.open:
        return Colors.blue.shade100;
      case ComplaintStatus.inProgress:
        return Colors.orange.shade100;
      case ComplaintStatus.resolved:
        return Colors.green.shade100;
    }
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red.shade100;
      case 2:
        return Colors.yellow.shade100;
      case 3:
        return Colors.green.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}

