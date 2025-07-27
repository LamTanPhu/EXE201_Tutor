import 'package:flutter/material.dart';
import 'package:tutor/common/models/account.dart';
import 'package:tutor/common/models/account_detail.dart';
import 'package:tutor/common/models/certification.dart';
import 'package:tutor/common/utils/shared_prefs.dart';
import 'package:tutor/common/utils/snackbar_helper.dart';
import 'package:tutor/common/widgets/custom_app_bar.dart';
import 'package:tutor/common/widgets/custom_loading.dart';
import 'package:tutor/features/account/edit_profile.dart';
import 'package:tutor/features/account/widgets/profile_header.dart';
import 'package:tutor/features/account/widgets/profile_tab.dart';
import 'package:tutor/services/api_service.dart';

class TutorProfileScreen extends StatefulWidget {
  const TutorProfileScreen({super.key});

  @override
  State<TutorProfileScreen> createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Future<TutorFullDetail>? _profileFuture;
  String? _accountId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
  }

  Future<void> _initData() async {
    final id = await SharedPrefs.getAccountId();

    if (id == null || id.isEmpty) {
      if (mounted) {
        // Thông báo người dùng cần đăng nhập
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng đăng nhập để tiếp tục')),
        );
      }
      return;
    }
    if (!mounted) return;

    setState(() {
      _accountId = id;
      _profileFuture = _fetchTutorFullDetail();
      _tabController = TabController(length: 2, vsync: this); // Số lượng tab
    });
  }

  Future<TutorFullDetail> _fetchTutorFullDetail() async {
    final accountFuture = ApiService.getProfile();
    final certFuture = ApiService.getTutorCertifications();
    final results = await Future.wait([accountFuture, certFuture]);

    final Account accountDetail = results[0] as Account;
    final List<Certification> certifications =
        results[1] as List<Certification>;
    return TutorFullDetail(
      accountDetail: accountDetail,
      certifications: certifications,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Future<void> _logout(BuildContext context) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  //   if (!mounted) return;
  //   Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  // }

  void _navigateToEditProfile(Account profileData) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => EditProfileScreen(
              fullName: profileData.fullName ?? '',
              email: profileData.email ?? '',
              phone: profileData.phone ?? '',
              avatar: profileData.avatar ?? '',
              onSave: (fullName, email, phone, avatar) async {
                await ApiService.updateAccountProfile(
                  fullName,
                  email,
                  phone,
                  avatar,
                );
                setState(() {
                  _profileFuture = _fetchTutorFullDetail();
                });
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Profile updated successfully')),
                // );
                SnackbarHelper.showSuccess(context, 'Profile updated successfully');
              },
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tài khoản của bạn',
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              if (_profileFuture != null) {
                _profileFuture!.then((accountDetail) {
                  _navigateToEditProfile(accountDetail.accountDetail);
                });
              }
            },
          ),
        ],
      ),
      body:
          _accountId == null
              ? const Center(child: CustomLoading())
              : FutureBuilder<TutorFullDetail>(
                future: _profileFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CustomLoading();
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('Không tìm thấy dữ liệu.'));
                  }

                  final profileData = snapshot.data!;
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            SizedBox(height: 50),
                            ProfileHeader(
                              profileData: profileData.accountDetail,
                            ),
                            SizedBox(height: 24),
                            ProfileTabSection(
                              profileData: profileData.accountDetail,
                              certifications: profileData.certifications,
                              tabController: _tabController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
    );
  }
}

class TutorFullDetail {
  final Account accountDetail;
  final List<Certification> certifications;

  TutorFullDetail({required this.accountDetail, required this.certifications});
}
