import 'package:flutter/material.dart';
import 'package:tutor/services/api_service.dart';
import 'package:tutor/features/home/widgets/home_search_bar_widget.dart';
import 'package:tutor/features/home/widgets/home_filter_bottom_sheet_widget.dart';
import 'package:tutor/features/home/widgets/home_grid_item_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isTeacherMode = false;
  List<dynamic> _items = [];
  List<dynamic> _filteredItems = [];
  String _sortOption = 'name';
  String _selectedOrderBy = 'Newest';
  double _maxPrice = 1000000;
  double _currentPriceFilter = 1000000;
  TextEditingController _searchController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(_isTeacherMode ? 'Teachers' : 'Courses'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => HomeFilterBottomSheetWidget(
                  isTeacherMode: _isTeacherMode,
                  selectedOrderBy: _selectedOrderBy,
                  currentPriceFilter: _currentPriceFilter,
                  maxPrice: _maxPrice,
                  orderByOptions: orderByOptions,
                  onModeChanged: (value) {
                    setState(() {
                      _isTeacherMode = value;
                      _fetchData();
                    });
                  },
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
                  onPriceFilterApplied: () {
                    _filterItems();
                  },
                  onClearFilters: () {
                    setState(() {
                      _selectedOrderBy = 'Newest';
                      _currentPriceFilter = _maxPrice;
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[50]!,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            HomeSearchBarWidget(
              controller: _searchController,
            ),
            Expanded(
              child: _filteredItems.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No results found',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              )
                  : GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
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
                        Navigator.pushNamed(context, '/course-details',
                            arguments: item['course']);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}