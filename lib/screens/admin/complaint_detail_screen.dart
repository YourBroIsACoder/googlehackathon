import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart'; // COMMENTED OUT - Maps API not configured
// import 'package:cached_network_image/cached_network_image.dart'; // COMMENTED OUT - No Firebase Storage
import '../../models/complaint.dart';
import '../../services/interfaces/interfaces.dart';
import '../../config/service_locator.dart';
import '../../widgets/status_snackbar.dart';

class ComplaintDetailScreen extends StatefulWidget {
  final Complaint complaint;

  const ComplaintDetailScreen({super.key, required this.complaint});

  @override
  State<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends State<ComplaintDetailScreen> {
  IComplaintService get _complaintService => ServiceLocator.instance.complaintService;
  late Complaint _complaint;
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _complaint = widget.complaint;
    _notesController.text = _complaint.adminNotes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus(ComplaintStatus newStatus) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _complaintService.updateComplaintStatus(
        _complaint.id,
        newStatus,
        adminNotes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      final updatedComplaint = await _complaintService.getComplaintById(_complaint.id);
      if (updatedComplaint != null) {
        setState(() {
          _complaint = updatedComplaint;
        });
      }

      if (mounted) {
        showSuccessSnackBar(context, 'Status updated successfully!');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating status: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updatePriority(int priority) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _complaintService.updateComplaintPriority(_complaint.id, priority);
      final updatedComplaint = await _complaintService.getComplaintById(_complaint.id);
      if (updatedComplaint != null) {
        setState(() {
          _complaint = updatedComplaint;
        });
      }

      if (mounted) {
        showSuccessSnackBar(context, 'Priority updated successfully!');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating priority: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint #${_complaint.id.substring(0, 8)}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      _complaint.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _complaint.categoryDisplayName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ),
                        Chip(
                          label: Text(_complaint.statusDisplayName),
                          backgroundColor: _getStatusColor(_complaint.status),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Priority: ${_complaint.priorityDisplayName}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Divider(),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(_complaint.description),
                    const SizedBox(height: 16),
                    if (_complaint.imageUrl != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, size: 48, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Image preview\n(Firebase Storage not configured)'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.person),
                      title: const Text('Name'),
                      subtitle: Text(_complaint.userName),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: Text(_complaint.userEmail),
                    ),
                    if (_complaint.address != null)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.location_on),
                        title: const Text('Address'),
                        subtitle: Text(_complaint.address!),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.map, size: 48, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text(
                              'Location: ${_complaint.latitude.toStringAsFixed(4)}, ${_complaint.longitude.toStringAsFixed(4)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Google Maps API not configured',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Notes',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Add notes about this complaint...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Priority',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('High'),
                            selected: _complaint.priority == 1,
                            onSelected: (selected) {
                              if (selected) _updatePriority(1);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Medium'),
                            selected: _complaint.priority == 2,
                            onSelected: (selected) {
                              if (selected) _updatePriority(2);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Low'),
                            selected: _complaint.priority == 3,
                            onSelected: (selected) {
                              if (selected) _updatePriority(3);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Update Status',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (_complaint.status != ComplaintStatus.inProgress)
                  ElevatedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () => _updateStatus(ComplaintStatus.inProgress),
                    icon: const Icon(Icons.work),
                    label: const Text('Mark In Progress'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                if (_complaint.status != ComplaintStatus.resolved)
                  ElevatedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () => _updateStatus(ComplaintStatus.resolved),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Mark Resolved'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                if (_complaint.status != ComplaintStatus.open)
                  ElevatedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () => _updateStatus(ComplaintStatus.open),
                    icon: const Icon(Icons.pending),
                    label: const Text('Reopen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Timeline',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    _buildTimelineItem(
                      'Created',
                      _complaint.createdAt,
                      Icons.add_circle,
                    ),
                    if (_complaint.updatedAt != null)
                      _buildTimelineItem(
                        'Updated',
                        _complaint.updatedAt!,
                        Icons.update,
                      ),
                    if (_complaint.resolvedAt != null)
                      _buildTimelineItem(
                        'Resolved',
                        _complaint.resolvedAt!,
                        Icons.check_circle,
                        Colors.green,
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

  Widget _buildTimelineItem(String label, DateTime date, IconData icon,
      [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: color ?? Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.open:
        return Colors.blue;
      case ComplaintStatus.inProgress:
        return Colors.orange;
      case ComplaintStatus.resolved:
        return Colors.green;
    }
  }
}

