import 'package:flutter/material.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/features/home/widgets/home_search_bar_widget.dart';
import 'package:tutor/features/home/widgets/home_filter_bottom_sheet_widget.dart';
import 'package:tutor/features/home/widgets/home_grid_item_widget.dart';
import 'package:tutor/features/home/widgets/home_bottom_nav_bar_widget.dart';
import 'package:tutor/routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isTeacherMode = true;
  List<dynamic> _items = [];
  List<dynamic> _filteredItems = [];
  String _sortOption = 'name';
  String _selectedOrderBy = 'Mới nhất';
  double _maxPrice = 5000000;
  double _currentPriceFilter = 5000000;
  int _maxExperience = 5;
  int _currentExperienceFilter = 5;
  TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  bool _isInitialLoading = true; // Track initial data load

  final List<String> orderByOptions = ['Mới nhất', 'Phổ biến', 'Xếp hạng', 'Giá'];

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchController.addListener(_filterItems);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check for navigation argument to set initial mode, safe to call here
    final args = ModalRoute.of(context)?.settings.arguments as bool?;
    if (args != null) {
      setState(() {
        _isTeacherMode = args;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isInitialLoading = true;
    });
    try {
      final coursesData = await ApiService.getCourses();
      final courses = coursesData['data']['courses'];
      print('Raw courses data: $courses'); // Debug the structure

      setState(() {
        if (_isTeacherMode) {
          final uniqueTeachers = <String, dynamic>{};
          for (var course in courses) {
            final account = course['account'];
            uniqueTeachers[account['_id']] = {
              'account': account,
              'certifications': course['certifications'],
            };
          }
          _items = uniqueTeachers.values.toList();
          if (_sortOption == 'name') {
            _items.sort((a, b) => (a['account']['fullName'] ?? '')
                .compareTo(b['account']['fullName'] ?? ''));
          }
        } else {
          _items = courses.map((course) => {
            'course': course['course'],
            'account': {'fullName': course['account']['fullName']},
          }).toList();
          print('Processed items: $_items'); // Debug the items
          if (_sortOption == 'name') {
            _items.sort((a, b) =>
                (a['course']['name'] ?? '').compareTo(b['course']['name'] ?? ''));
          } else if (_sortOption == 'price') {
            _items.sort((a, b) =>
                (a['course']['price'] ?? 0).compareTo(b['course']['price'] ?? 0));
          }
        }
        _filteredItems = List.from(_items);
        _isInitialLoading = false;
      });
    } catch (e) {
      setState(() {
        _isInitialLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải dữ liệu: $e')),
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
        } else {
          final experience = item['certifications']?.first['experience'] ?? 0;
          if (experience > _currentExperienceFilter) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        setState(() {
          _isTeacherMode = true;
          _fetchData();
        });
        break;
      case 1:
        setState(() {
          _isTeacherMode = false;
          _fetchData();
        });
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.forum);
        break;
      case 3: // Overview
        Navigator.pushReplacementNamed(context, AppRoutes.overview);
        break;
      case 4: // Profile
        Navigator.pushNamed(context, AppRoutes.guest);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _isTeacherMode ? 'Gia sư' : 'Khóa học',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.blueAccent),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => HomeFilterBottomSheetWidget(
                  isTeacherMode: _isTeacherMode,
                  selectedOrderBy: _selectedOrderBy,
                  currentPriceFilter: _currentPriceFilter,
                  maxPrice: _maxPrice,
                  maxExperience: _maxExperience,
                  currentExperienceFilter: _currentExperienceFilter,
                  orderByOptions: orderByOptions,
                  onOrderByChanged: (value) {
                    setState(() {
                      _selectedOrderBy = value;
                      _sortOption = value.toLowerCase() == 'price' ? 'price' : 'name';
                      _fetchData();
                    });
                  },
                  onPriceFilterChanged: (value) {
                    setState(() {
                      _currentPriceFilter = value;
                    });
                  },
                  onExperienceFilterChanged: (value) {
                    setState(() {
                      _currentExperienceFilter = value;
                    });
                  },
                  onApplyFilters: () {
                    _filterItems();
                  },
                  onClearFilters: () {
                    setState(() {
                      _selectedOrderBy = 'Mới nhất';
                      _currentPriceFilter = _maxPrice;
                      _currentExperienceFilter = _maxExperience;
                      _searchController.clear();
                      _filterItems();
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A90E2), Color(0xFFF5F7FA)],
          ),
        ),
        child: Column(
          children: [
            HomeSearchBarWidget(controller: _searchController),
            Expanded(
              child: _isInitialLoading
                  ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF4A90E2)),
              )
                  : _filteredItems.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Không tìm thấy kết quả',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
                  : GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return HomeGridItemWidget(
                    item: item,
                    isTeacherMode: _isTeacherMode,
                    onTap: () {
                      if (_isTeacherMode) {
                        Navigator.pushNamed(context, '/tutor-profile',
                            arguments: item['account']['_id']);
                      } else {
                        Navigator.pushNamed(
                          context,
                          '/course-details',
                          arguments: {
                            'courseId': item['course']['_id'],
                            'courseData': {
                              'course': item['course'],
                            },
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}