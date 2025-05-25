import 'package:flutter/material.dart';
import 'package:tutor/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isTeacherMode = false; // Default to Courses mode
  List<dynamic> _items = [];
  List<dynamic> _filteredItems = [];
  String _sortOption = 'name';
  String _selectedSubject = 'All';
  String _selectedCategory = 'All';
  String _selectedOrderBy = 'Newest';
  double _maxPrice = 1000000;
  double _currentPriceFilter = 1000000;
  TextEditingController _searchController = TextEditingController();

  // Filter options
  final List<String> subjects = ['All', 'English', 'Coding', 'Math'];
  final List<String> categories = ['All', 'Beginner', 'Intermediate', 'Advanced', 'Expert'];
  final List<String> orderByOptions = ['Newest', 'Popularity', 'Ratings', 'Price'];

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        _filteredItems = List.from(_items);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  void _filterItems() {
    setState(() {
      _filteredItems = _items.where((item) {
        final searchQuery = _searchController.text.toLowerCase();
        final name = _isTeacherMode
            ? (item['account']['fullName'] ?? '').toLowerCase()
            : (item['course']['name'] ?? '').toLowerCase();

        if (searchQuery.isNotEmpty && !name.contains(searchQuery)) {
          return false;
        }

        if (!_isTeacherMode) {
          final price = item['course']['price'] ?? 0;
          if (price > _currentPriceFilter) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // Display Mode
                    _buildFilterSection('Display Mode', Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
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
                        ListTile(
                          contentPadding: EdgeInsets.zero,
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
                      ],
                    )),

                    // Order By
                    _buildFilterSection('Sort By', Wrap(
                      spacing: 8,
                      children: orderByOptions.map((option) =>
                          _buildChip(option, _selectedOrderBy == option, () {
                            setState(() {
                              _selectedOrderBy = option;
                              _fetchData();
                            });
                          })
                      ).toList(),
                    )),

                    if (!_isTeacherMode) ...[
                      _buildFilterSection('Price Range', Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Up to ${_currentPriceFilter.toInt()} VND'),
                          Slider(
                            value: _currentPriceFilter,
                            min: 0,
                            max: _maxPrice,
                            divisions: 10,
                            onChanged: (value) {
                              setState(() {
                                _currentPriceFilter = value;
                              });
                            },
                            onChangeEnd: (value) {
                              _filterItems();
                            },
                          ),
                        ],
                      )),
                    ],

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _selectedOrderBy = 'Newest';
                                _currentPriceFilter = _maxPrice;
                                _searchController.clear();
                                _filterItems();
                              });
                            },
                            child: const Text('Clear All'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(_isTeacherMode ? 'Teachers' : 'Courses'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Find courses by subject, difficulty, duration, etc.',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Content
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No results found', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6, // Changed from 0.75 to 0.6 to make cards taller
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return Card(
                  elevation: 2,
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
                        // Image Section
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _isTeacherMode
                                          ? [Colors.blue[300]!, Colors.blue[500]!]
                                          : [Colors.purple[300]!, Colors.purple[500]!],
                                    ),
                                  ),
                                  child: _isTeacherMode
                                      ? (item['account']['avatar'] != null && item['account']['avatar'].isNotEmpty)
                                      ? Image.network(
                                    item['account']['avatar'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Center(child: Icon(Icons.person,
                                        size: 40, color: Colors.white)),
                                  )
                                      : const Center(child: Icon(Icons.person,
                                      size: 40, color: Colors.white))
                                      : item['course']['image'] != null
                                      ? Image.network(
                                    item['course']['image'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Center(child: Icon(Icons.school,
                                        size: 40, color: Colors.white)),
                                  )
                                      : const Center(child: Icon(Icons.school,
                                      size: 40, color: Colors.white)),
                                ),

                                // Rating badge
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.star, color: Colors.white, size: 12),
                                        SizedBox(width: 2),
                                        Text('4.8', style: TextStyle(
                                            color: Colors.white, fontSize: 10)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Info Section - Made this section bigger to accommodate longer titles
                        Expanded(
                          flex: 3, // Changed from 2 to 3 to give more space for text
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  _isTeacherMode
                                      ? item['account']['fullName'] ?? 'Unknown Tutor'
                                      : item['course']['name'] ?? 'Unknown Course',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 3, // Increased from 2 to 3 lines
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6), // Slightly more spacing

                                // Subtitle with status for teachers
                                Text(
                                  _isTeacherMode
                                      ? '${item['account']['role'] ?? 'Teacher'} • ${_getStatusText(item['account']['status'])}'
                                      : 'By ${item['account']['fullName'] ?? 'Unknown'}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _isTeacherMode
                                        ? _getStatusColor(item['account']['status'])
                                        : Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const Spacer(),

                                // Price or additional info
                                if (!_isTeacherMode) ...[
                                  Text(
                                    '${item['course']['price'] ?? 0} VND',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ] else ...[
                                  // Show experience for teachers
                                  if (item['certifications']?.isNotEmpty ?? false) ...[
                                    Text(
                                      '${item['certifications'][0]['experience'] ?? 0} years exp.',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return 'Available';
      case 'inactive':
        return 'Unavailable';
      case 'busy':
        return 'Busy';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'busy':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}