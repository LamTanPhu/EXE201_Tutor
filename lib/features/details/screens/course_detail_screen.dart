import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tutor/services/api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Added for browser fallback
import 'package:tutor/features/details/widgets/course_widgets/course_header.dart';
import 'package:tutor/features/details/widgets/course_widgets/course_description.dart';
import 'package:tutor/features/details/widgets/course_widgets/course_chapters.dart';
import 'package:tutor/routes/app_routes.dart';

// Hardcoded course data (to be replaced with API later)
const Map<String, dynamic> defaultCourseData = {
  "course": {
    "name": "Flutter Advanced Course",
    "image": "https://example.com/course.jpg",
    "price": "1500000",
    "description": "Learn advanced Flutter techniques for building modern apps.",
    "isActive": true,
    "createdAt": "2023-10-01",
    "instructor": "John Doe",
    "duration": "10 hours"
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
    print('Received courseId: ${widget.courseId}');
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
                print('WebView loading started: $url');
              },
              onProgress: (progress) {
                print('WebView loading progress: $progress%');
              },
              onPageFinished: (url) {
                print('WebView finished loading: $url');
                setState(() => _isLoading = false);
                if (url.contains('localhost:3000?orderId=')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment completed successfully!')),
                  );
                  Navigator.pop(context);
                }
              },
              onWebResourceError: (error) {
                print('WebView error: ${error.errorType} - ${error.description} (URL: ${error.url})');
                setState(() {
                  _isLoading = false;
                  _paymentUrl = null; // Reset to show content again
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Payment error: ${error.description}')),
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
          throw 'Could not launch $paymentUrl';
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _paymentUrl = null; // Reset to show content on error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initiating payment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.courseData?['course'] ?? defaultCourseData['course'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
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
                CourseDescription(description: course['description'] ?? 'No description available'),
                const SizedBox(height: 16),
                CourseChapters(courseId: widget.courseId),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Status'),
                  subtitle: Text(course['isActive'] == true ? 'Active' : 'Inactive'),
                  leading: const Icon(Icons.info),
                ),
                ListTile(
                  title: const Text('Duration'),
                  subtitle: Text(course['duration'] ?? 'N/A'),
                  leading: const Icon(Icons.timer),
                ),
                ListTile(
                  title: const Text('Created At'),
                  subtitle: Text(course['createdAt'] ?? 'N/A'),
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
                      child: const Text('Enroll Now'),
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