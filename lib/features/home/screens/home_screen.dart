import 'package:flutter/material.dart';
import 'package:tutor/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isTeacherMode = true; // Default to Teacher mode
  List<dynamic> _items = []; // Will hold teachers or courses
  String _sortOption = 'name'; // Default sort by name

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final coursesData = await ApiService.getCourses();
      final courses = coursesData['data']['courses'];

      setState(() {
        if (_isTeacherMode) {
          // Extract unique teachers from courses
          final uniqueTeachers = <String, dynamic>{};
          for (var course in courses) {
            final account = course['account'];
            uniqueTeachers[account['_id']] = {
              'account': account,
              'certifications': course['certifications'],
            };
          }
          _items = uniqueTeachers.values.toList();
          // Sort teachers
          if (_sortOption == 'name') {
            _items.sort((a, b) => (a['account']['fullName'] ?? '')
                .compareTo(b['account']['fullName'] ?? ''));
          }
        } else {
          // Use courses directly
          _items = courses.map((course) => {
            'course': course['course'],
            'account': {'fullName': course['account']['fullName']},
          }).toList();
          // Sort courses
          if (_sortOption == 'name') {
            _items.sort((a, b) =>
                (a['course']['name'] ?? '').compareTo(b['course']['name'] ?? ''));
          } else if (_sortOption == 'price') {
            _items.sort((a, b) =>
                (a['course']['price'] ?? 0).compareTo(b['course']['price'] ?? 0));
          }
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Display Mode',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text('Teachers'),
                leading: Radio<bool>(
                  value: true,
                  groupValue: _isTeacherMode,
                  onChanged: (value) {
                    setState(() {
                      _isTeacherMode = true;
                      _fetchData();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Courses'),
                leading: Radio<bool>(
                  value: false,
                  groupValue: _isTeacherMode,
                  onChanged: (value) {
                    setState(() {
                      _isTeacherMode = false;
                      _fetchData();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              const Divider(),
              const Text(
                'Sort By',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text('Name'),
                leading: Radio<String>(
                  value: 'name',
                  groupValue: _sortOption,
                  onChanged: (value) {
                    setState(() {
                      _sortOption = value!;
                      _fetchData();
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              if (!_isTeacherMode)
                ListTile(
                  title: const Text('Price'),
                  leading: Radio<String>(
                    value: 'price',
                    groupValue: _sortOption,
                    onChanged: (value) {
                      setState(() {
                        _sortOption = value!;
                        _fetchData();
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isTeacherMode ? 'Teachers' : 'Courses'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterMenu,
            tooltip: 'Filter & Sort',
          ),
        ],
      ),
      body: _items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(12.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85, // Adjusted to make cards more compact
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
        ),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                if (_isTeacherMode) {
                  Navigator.pushNamed(context, '/tutor-profile',
                      arguments: item['account']['_id']);
                } else {
                  Navigator.pushNamed(context, '/course-details',
                      arguments: item['course']);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section with Overlay
                  ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Stack(
                      children: [
                        Image.network(
                          _isTeacherMode
                              ? (item['certifications']?.isNotEmpty ?? false)
                              ? item['certifications'][0]['image'][0]
                              : 'https://via.placeholder.com/150'
                              : item['course']['image'] ??
                              'https://via.placeholder.com/150',
                          height: 150, // Increased image height
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.network('https://via.placeholder.com/150'),
                        ),
                        if (_isTeacherMode)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.star, color: Colors.white, size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    '4.8', // Placeholder rating
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Content Section
                  Padding(
                    padding: const EdgeInsets.all(8.0), // Reduced padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isTeacherMode
                              ? item['account']['fullName'] ?? 'Unknown Tutor'
                              : item['course']['name'] ?? 'Unknown Course',
                          style: const TextStyle(
                            fontSize: 18, // Increased font size
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isTeacherMode
                              ? 'Role: ${item['account']['role']}'
                              : 'Tutor: ${item['account']['fullName']}',
                          style: TextStyle(
                            fontSize: 12, // Slightly smaller for secondary text
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        if (!_isTeacherMode) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${item['course']['price']} VND',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: item['course']['isActive'] == true
                                      ? Colors.blue.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item['course']['isActive'] == true
                                      ? 'Active'
                                      : 'Inactive',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: item['course']['isActive'] == true
                                        ? Colors.blue
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                        ],
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_isTeacherMode) {
                                Navigator.pushNamed(context, '/tutor-profile',
                                    arguments: item['account']['_id']);
                              } else {
                                Navigator.pushNamed(context, '/course-details',
                                    arguments: item['course']);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size(0, 30), // Smaller button
                            ),
                            child: const Text(
                              'View Details',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}