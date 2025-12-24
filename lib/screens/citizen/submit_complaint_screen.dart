import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/complaint.dart';
import '../../providers/auth_provider.dart';
import '../../services/interfaces/interfaces.dart';
import '../../services/location_service.dart';
import '../../services/ai_service.dart';
import '../../services/reward_service.dart';
import '../../config/service_locator.dart';

class SubmitComplaintScreen extends StatefulWidget {
  const SubmitComplaintScreen({super.key});

  @override
  State<SubmitComplaintScreen> createState() => _SubmitComplaintScreenState();
}

class _SubmitComplaintScreenState extends State<SubmitComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Services accessed through service locator
  IComplaintService get _complaintService => ServiceLocator.instance.complaintService;
  IStorageService get _storageService => ServiceLocator.instance.storageService;
  final LocationService _locationService = LocationService();
  final RewardService _rewardService = RewardService();

  ComplaintCategory _selectedCategory = ComplaintCategory.pothole;
  XFile? _selectedImage;
  double? _latitude;
  double? _longitude;
  String? _address;
  bool _isLoading = false;
  bool _isGettingLocation = false;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _aiSuggestions;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      final position = await _locationService.getCurrentPosition();
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });

      final address = await _locationService.getAddressFromCoordinates(
        _latitude!,
        _longitude!,
      );
      setState(() {
        _address = address;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGettingLocation = false;
        });
      }
    }
  }

  Future<void> _analyzeWithAI() async {
    if (_titleController.text.trim().isEmpty || 
        _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter title and description first')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final suggestions = await AIService.analyzeComplaint(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _aiSuggestions = suggestions;
        });

        // Apply AI suggestions
        if (suggestions != null) {
          final categoryName = suggestions['suggestedCategory'] as String?;
          if (categoryName != null) {
            final category = ComplaintCategory.values.firstWhere(
              (e) => e.name == categoryName,
              orElse: () => _selectedCategory,
            );
            setState(() {
              _selectedCategory = category;
            });
          }

          // Show suggestions dialog
          _showAISuggestionsDialog(suggestions);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('AI analysis error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  void _showAISuggestionsDialog(Map<String, dynamic> suggestions) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.blue),
            SizedBox(width: 8),
            Text('AI Suggestions'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (suggestions['suggestedCategory'] != null)
              _buildSuggestionItem(
                'Category',
                _getCategoryDisplayName(suggestions['suggestedCategory']),
              ),
            if (suggestions['suggestedPriority'] != null)
              _buildSuggestionItem(
                'Priority',
                _getPriorityName(suggestions['suggestedPriority']),
              ),
            if (suggestions['improvementSuggestion'] != null)
              _buildSuggestionItem(
                'Suggestion',
                suggestions['improvementSuggestion'],
              ),
            if (suggestions['safetyConcerns'] != null)
              _buildSuggestionItem(
                'Safety',
                suggestions['safetyConcerns'],
                isWarning: true,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String label, String value, {bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isWarning ? Colors.red : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: isWarning ? Colors.red[700] : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _getPriorityName(int priority) {
    switch (priority) {
      case 1:
        return 'High';
      case 2:
        return 'Medium';
      case 3:
        return 'Low';
      default:
        return 'Medium';
    }
  }

  Future<void> _pickImage() async {
    final image = await _storageService.pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final image = await _storageService.pickImageFromGallery();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      if (_latitude == null || _longitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please wait for location to be detected')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final user = authProvider.user;
        if (user == null) {
          throw Exception('User not authenticated');
        }

        String? imageUrl;
        if (_selectedImage != null) {
          final tempId = DateTime.now().millisecondsSinceEpoch.toString();
          imageUrl = await _storageService.uploadComplaintImage(_selectedImage!, tempId);
        }

        final complaint = Complaint(
          id: '',
          userId: user.uid,
          userName: user.displayName ?? user.email,
          userEmail: user.email,
          title: _titleController.text.trim(),
          category: _selectedCategory,
          description: _descriptionController.text.trim(),
          imageUrl: imageUrl,
          latitude: _latitude!,
          longitude: _longitude!,
          address: _address,
          createdAt: DateTime.now(),
          priority: _aiSuggestions?['suggestedPriority'] ?? 2,
        );

        await _complaintService.createComplaint(complaint);

        if (mounted) {
          // Check if this was first complaint for bonus points
          final userRewards = _rewardService.getUserRewards(user.uid);
          final pointsEarned = userRewards.totalPoints == RewardService.pointsPerFirstComplaint
              ? RewardService.pointsPerFirstComplaint
              : RewardService.pointsPerComplaint;
          
          _showPointsEarnedDialog(pointsEarned, userRewards.totalPoints);
          
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error submitting complaint: $e')),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Complaint'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    hintText: 'Enter a brief title for your complaint',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    if (value.length < 5) {
                      return 'Title must be at least 5 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Category Dropdown
                DropdownButtonFormField<ComplaintCategory>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  items: ComplaintCategory.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(_getCategoryDisplayName(category.name)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Description *',
                    hintText: 'Describe the issue in detail...',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    if (value.length < 10) {
                      return 'Description must be at least 10 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // AI Analysis Button
                OutlinedButton.icon(
                  onPressed: _isAnalyzing ? null : _analyzeWithAI,
                  icon: _isAnalyzing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: Text(_isAnalyzing ? 'Analyzing...' : 'Get AI Suggestions'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Location Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(
                              'Location',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_isGettingLocation)
                          const Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 8),
                              Text('Getting location...'),
                            ],
                          )
                        else if (_address != null)
                          Text(_address!)
                        else if (_latitude != null && _longitude != null)
                          Text('Lat: $_latitude, Lng: $_longitude')
                        else
                          const Text('Location not available'),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: _getCurrentLocation,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh Location'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Image Section
                if (_selectedImage != null)
                  Card(
                    child: Column(
                      children: [
                        FutureBuilder<ImageProvider>(
                          future: _getImageProvider(_selectedImage!),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Image(
                                image: snapshot.data!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            }
                            return const SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                          child: const Text('Remove Image'),
                        ),
                      ],
                    ),
                  )
                else
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(Icons.camera_alt, size: 48),
                          const SizedBox(height: 8),
                          const Text('Add Photo (Optional)'),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.camera),
                                label: const Text('Camera'),
                              ),
                              TextButton.icon(
                                onPressed: _pickImageFromGallery,
                                icon: const Icon(Icons.photo_library),
                                label: const Text('Gallery'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                
                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitComplaint,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit Complaint'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<ImageProvider> _getImageProvider(XFile file) async {
    final bytes = await file.readAsBytes();
    return MemoryImage(bytes);
  }

  void _showPointsEarnedDialog(int pointsEarned, int totalPoints) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.stars,
                color: Colors.white,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Points Earned!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '+$pointsEarned points',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (pointsEarned == RewardService.pointsPerFirstComplaint) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '🎉 First Complaint Bonus!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                'Total Points: $totalPoints',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Awesome!'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryDisplayName(String categoryName) {
    switch (categoryName) {
      case 'pothole':
        return 'Pothole';
      case 'brokenStreetlight':
        return 'Broken Streetlight';
      case 'garbage':
        return 'Garbage Accumulation';
      case 'waterLeakage':
        return 'Water Leakage';
      case 'roadHazard':
        return 'Road Hazard';
      case 'other':
        return 'Other';
      default:
        return 'Other';
    }
  }
}
