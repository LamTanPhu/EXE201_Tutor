import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tutor/common/models/certification.dart';
import 'package:tutor/common/models/tutor.dart';
import 'package:tutor/common/theme/app_colors.dart';
import 'package:tutor/services/api_service.dart';

enum CertificationFilter { all, pending, approved, canTeach }

class ReviewCertificationScreen extends StatefulWidget {
  const ReviewCertificationScreen({super.key});

  @override
  State<ReviewCertificationScreen> createState() =>
      _ReviewCertificationScreenState();
}

class _ReviewCertificationScreenState extends State<ReviewCertificationScreen> {
  late Future<List<Tutor>> _tutorsFuture;
  CertificationFilter _filter = CertificationFilter.all;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tutorsFuture = ApiService.getTutors();
  }

  List<Certification> getAllCertifications(List<Tutor> tutors) {
    final certifications = <Certification>[];
    for (var tutor in tutors) {
      certifications.addAll(tutor.certifications);
    }
    return certifications;
  }

  List<Certification> filterCertifications(List<Certification> certifications) {
    final filtered = switch (_filter) {
      CertificationFilter.pending =>
        certifications
            .where(
              (cert) => cert.isChecked == false && cert.isCanTeach == false,
            )
            .toList(),
      CertificationFilter.approved =>
        certifications.where((cert) => cert.isChecked == true).toList(),
      CertificationFilter.canTeach =>
        certifications.where((cert) => cert.isCanTeach == true).toList(),
      CertificationFilter.all || _ => certifications,
    };

    if (_searchQuery.trim().isEmpty) return filtered;

    return filtered.where((cert) {
      return cert.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
          false;
    }).toList();
  }

  //refresh
  void _refreshCert() {
    setState(() {
      _tutorsFuture = ApiService.getTutors();
    });
  }

  Future<void> _approveCertification(String? certificationId) async {
    if (certificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lỗi: Thiếu ID chứng chỉ'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    try {
      await ApiService.checkCertification(certificationId);
      await ApiService.checkCertificationToTeach(certificationId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Phê duyệt chứng chỉ thành công!'),
          backgroundColor: Colors.green[700],
        ),
      );
      setState(() {
        _tutorsFuture = ApiService.getTutors();
      });
    } catch (e) {
      String errorMessage;
      if (e.toString().contains('endpoint not found')) {
        errorMessage = 'Lỗi: Dịch vụ phê duyệt chứng chỉ không khả dụng';
      } else if (e.toString().contains('Unauthorized')) {
        errorMessage = 'Lỗi: Phiên hết hạn. Vui lòng đăng nhập lại';
      } else if (e.toString().contains('Invalid response format')) {
        errorMessage = 'Lỗi: Phản hồi không hợp lệ từ server';
      } else {
        errorMessage = 'Lỗi: $e';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: AppColors.error),
      );
    }
  }

  void _showCertificationDetails(BuildContext context, Certification cert) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: AppColors.card,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.backgroundGradientStart,
                    AppColors.backgroundGradientEnd,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cert.name?.isNotEmpty == true
                          ? cert.name!
                          : 'Chứng chỉ không tên',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    if (cert.image.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: cert.image.first,
                          width: 200,
                          height: 150,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                color: AppColors.background,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                color: AppColors.background,
                                child: const Icon(
                                  Icons.error,
                                  color: AppColors.error,
                                  size: 32,
                                ),
                              ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    _buildDetailRowDialog(
                      'Mô tả',
                      cert.description?.isNotEmpty == true
                          ? cert.description!
                          : 'Không có mô tả',
                    ),
                    _buildDetailRowDialog(
                      'Tạo bởi',
                      cert.createBy?.isNotEmpty == true
                          ? cert.createBy!
                          : 'Không rõ',
                    ),
                    _buildDetailRowDialog(
                      'Kinh nghiệm',
                      '${cert.experience ?? 0} năm',
                    ),
                    _buildDetailRowDialog(
                      'Đã kiểm tra',
                      cert.isChecked == true ? 'Có' : 'Không',
                    ),
                    _buildDetailRowDialog(
                      'Có thể giảng dạy',
                      cert.isCanTeach == true ? 'Có' : 'Không',
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                          ),
                          child: const Text('Đóng'),
                        ),
                        if (!(cert.isChecked ?? false) &&
                            !(cert.isCanTeach ?? false))
                          ElevatedButton.icon(
                            onPressed: () async {
                              await _approveCertification(cert.id);
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.check_circle, size: 20),
                            label: const Text('Phê duyệt'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildDetailRowDialog(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.subText,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.text,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(CertificationFilter type, String label) {
    final isSelected = _filter == type;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(color: isSelected ? AppColors.white : AppColors.text),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.lightPrimary.withOpacity(0.1),
      showCheckmark: false,
      onSelected: (_) => setState(() => _filter = type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        shadowColor: AppColors.primary.withOpacity(0.2),
        foregroundColor: AppColors.text,
        title: const Text(
          'Chứng chỉ',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.lightPrimary],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.white),
            onPressed: _refreshCert,
            tooltip: 'Làm mới',
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.lightPrimary],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(color: AppColors.text),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm chứng chỉ...',
                hintStyle: const TextStyle(color: AppColors.subText),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.white,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide(color: AppColors.accent, width: 2),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(CertificationFilter.all, 'Tất cả'),
                      const SizedBox(width: 12),
                      _buildFilterChip(
                        CertificationFilter.pending,
                        'Chờ duyệt',
                      ),
                      const SizedBox(width: 12),
                      _buildFilterChip(
                        CertificationFilter.approved,
                        'Đã duyệt',
                      ),
                      const SizedBox(width: 12),
                      _buildFilterChip(
                        CertificationFilter.canTeach,
                        'Có thể dạy',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Tutor>>(
              future: _tutorsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Lỗi: ${snapshot.error}',
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 16,
                      ),
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final allCerts = getAllCertifications(snapshot.data!);
                  final certifications = filterCertifications(allCerts);
                  if (certifications.isEmpty) {
                    return const Center(
                      child: Text(
                        'Không tìm thấy chứng chỉ',
                        style: TextStyle(color: AppColors.text, fontSize: 16),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: certifications.length,
                    itemBuilder: (context, index) {
                      final cert = certifications[index];
                      return Card(
                        color: AppColors.card,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 16),
                        shadowColor: AppColors.primary.withOpacity(0.2),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _showCertificationDetails(context, cert),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child:
                                      cert.image.isNotEmpty
                                          ? CachedNetworkImage(
                                            imageUrl: cert.image.first,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            placeholder:
                                                (context, url) => Container(
                                                  color: AppColors.background,
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                          color:
                                                              AppColors.primary,
                                                          strokeWidth: 2,
                                                        ),
                                                  ),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      color:
                                                          AppColors.background,
                                                      child: const Icon(
                                                        Icons.error,
                                                        color: AppColors.error,
                                                        size: 32,
                                                      ),
                                                    ),
                                          )
                                          : Container(
                                            width: 60,
                                            height: 60,
                                            color: AppColors.background,
                                            child: const Icon(
                                              Icons.image,
                                              color: AppColors.subText,
                                              size: 32,
                                            ),
                                          ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cert.name?.isNotEmpty == true
                                            ? cert.name!
                                            : 'Chứng chỉ không tên',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.text,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        cert.description?.isNotEmpty == true
                                            ? cert.description!
                                            : 'Không có mô tả',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.subText,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: Text(
                    'Không tìm thấy gia sư',
                    style: TextStyle(color: AppColors.text, fontSize: 16),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
