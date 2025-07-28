import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tutor/services/api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tutor/features/details/widgets/course_widgets/course_header.dart';
import 'package:tutor/features/details/widgets/course_widgets/course_description.dart';
import 'package:tutor/features/details/widgets/course_widgets/course_chapters.dart';
import 'package:tutor/routes/app_routes.dart';

// Hardcoded course data (to be replaced with API later)
const Map<String, dynamic> defaultCourseData = {
  "course": {
    "name": "Khóa học nâng cao Flutter",
    "image": "https://example.com/course.jpg",
    "price": "1500000",
    "description": "Tìm hiểu các kỹ thuật nâng cao của Flutter để xây dựng ứng dụng hiện đại.",
    "isActive": true,
    "createdAt": "2023-10-01",
    "instructor": "John Doe",
    "duration": "10 giờ"
  }
};

class CourseDetailsScreen extends StatefulWidget {
  final String courseId;
  final Map<String, dynamic>? courseData;

  const CourseDetailsScreen({super.key, required this.courseId, this.courseData});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  bool _isLoading = false;
  WebViewController? _webViewController;
  String? _paymentUrl;

  @override
  void initState() {
    super.initState();
    print('Nhận courseId: ${widget.courseId}');
  }

  Future<void> _initiatePayment() async {
    if (_isLoading) return; // Prevent multiple taps
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.createOrderWithPaymentUrl(widget.courseId);
      final paymentUrl = response['data']['url'] as String;
      setState(() {
        _paymentUrl = paymentUrl;
        _isLoading = false;
      });

      if (Platform.isAndroid || Platform.isIOS) {
        _webViewController = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) {
                print('WebView bắt đầu tải: $url');
              },
              onProgress: (progress) {
                print('Tiến trình tải WebView: $progress%');
              },
              onPageFinished: (url) {
                print('WebView hoàn tất tải: $url');
                setState(() => _isLoading = false);
                if (url.contains('localhost:3000?orderId=')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thanh toán thành công!')),
                  );
                  Navigator.pop(context);
                }
              },
              onWebResourceError: (error) {
                print('Lỗi WebView: ${error.errorType} - ${error.description} (URL: ${error.url})');
                setState(() {
                  _isLoading = false;
                  _paymentUrl = null; // Reset to show content again
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi thanh toán: ${error.description}')),
                );
              },
            ),
          )
          ..loadRequest(Uri.parse(paymentUrl));
      } else {
        // Fallback to browser for Windows and other platforms
        if (await canLaunchUrl(Uri.parse(paymentUrl))) {
          await launchUrl(Uri.parse(paymentUrl));
          setState(() => _paymentUrl = null); // Reset after launching
        } else {
          throw 'Không thể mở $paymentUrl';
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _paymentUrl = null; // Reset to show content on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khởi tạo thanh toán: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.courseData?['course'] ?? defaultCourseData['course'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết khóa học'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CourseHeader(course: course),
                const SizedBox(height: 16),
                CourseDescription(description: course['description'] ?? 'Không có mô tả'),
                const SizedBox(height: 16),
                CourseChapters(courseId: widget.courseId),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Trạng thái'),
                  subtitle: Text(course['isActive'] == true ? 'Hoạt động' : 'Không hoạt động'),
                  leading: const Icon(Icons.info),
                ),
                ListTile(
                  title: const Text('Thời lượng'),
                  subtitle: Text(course['duration'] ?? 'Không có thông tin'),
                  leading: const Icon(Icons.timer),
                ),
                ListTile(
                  title: const Text('Ngày tạo'),
                  subtitle: Text(course['createdAt'] ?? 'Không có thông tin'),
                  leading: const Icon(Icons.calendar_today),
                ),
                const SizedBox(height: 16),
                if (!_isLoading && _paymentUrl == null)
                  Center(
                    child: ElevatedButton(
                      onPressed: _initiatePayment,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text('Đăng ký ngay'),
                    ),
                  ),
              ],
            ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (_paymentUrl != null && _webViewController != null && (Platform.isAndroid || Platform.isIOS))
            SizedBox(
              height: MediaQuery.of(context).size.height - kToolbarHeight,
              child: WebViewWidget(controller: _webViewController!),
            ),
        ],
      ),
    );
  }
}