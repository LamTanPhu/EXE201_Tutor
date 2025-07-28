import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tutor/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  //link to website or email
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Không thể mở $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Về chúng tôi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Về nền tảng của chúng tôi',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Chào mừng bạn đến với Tutorify, nền tảng đáng tin cậy để kết nối người học và giáo viên trên toàn thế giới.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              //our mission
              Text(
                'Sứ mệnh của chúng tôi',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Trao quyền cho cá nhân thông qua giáo dục chất lượng cao, dễ tiếp cận bằng cách kết nối các gia sư nhiệt huyết với những người học ham hiểu biết.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 16),
              //vision
              Text(
                'Tầm nhìn của chúng tôi',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tạo ra một cộng đồng học tập toàn cầu nơi kiến thức được chia sẻ tự do, thúc đẩy sự phát triển và cơ hội cho tất cả.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 24),

              //contact
              Text(
                'Liên hệ với chúng tôi',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bạn có câu hỏi hoặc muốn tìm hiểu thêm? Hãy liên hệ với chúng tôi!',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () => _launchUrl('https://your-website.com'),
                    child: const Text(
                      'Truy cập trang web của chúng tôi',
                      style: TextStyle(color: Color(0xFF007BFF)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () => _launchUrl('mailto:support@tutorapp.com'),
                    child: const Text(
                      'Gửi email cho chúng tôi',
                      style: TextStyle(color: Color(0xFF007BFF)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // back to  Login
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                  child: const Text('Quay lại đăng nhập'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}