// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/authentication/authentication_event.dart';
import '../blocs/authentication/authentication_state.dart';
import '../widgets/home/custom_bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Hồ sơ cá nhân',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {
              // Navigate to settings screen
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return _buildProfileContent(state.userData);
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF13B8A8),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildProfileContent(Map<String, dynamic> userData) {
    final username = userData['username'] ?? 'User';
    final email = userData['email'] ?? 'email@example.com';
    final role = userData['role'] ?? 'User';

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile header with avatar
          _buildProfileHeader(username, email, role),
          SizedBox(height: 32),

          // Profile sections
          _buildProfileSection(
            title: 'Thông tin tài khoản',
            icon: Icons.person_outline,
            children: [
              _buildProfileTile(
                title: 'Tên người dùng',
                subtitle: username,
                leadingIcon: Icons.account_circle_outlined,
              ),
              _buildProfileTile(
                title: 'Email',
                subtitle: email,
                leadingIcon: Icons.email_outlined,
              ),
              _buildProfileTile(
                title: 'Vai trò',
                subtitle: role,
                leadingIcon: Icons.badge_outlined,
              ),
            ],
          ),

          SizedBox(height: 16),

          _buildProfileSection(
            title: 'Hoạt động',
            icon: Icons.local_activity_outlined,
            children: [
              _buildProfileTile(
                title: 'Lịch sử đặt vé',
                subtitle: 'Xem các vé đã đặt',
                leadingIcon: Icons.history,
                onTap: () {
                  // Navigate to booking history
                },
              ),
              _buildProfileTile(
                title: 'Thanh toán',
                subtitle: 'Quản lý phương thức thanh toán',
                leadingIcon: Icons.payment_outlined,
                onTap: () {
                  // Navigate to payment methods
                },
              ),
            ],
          ),

          SizedBox(height: 16),

          _buildProfileSection(
            title: 'Cài đặt',
            icon: Icons.settings_outlined,
            children: [
              _buildProfileTile(
                title: 'Thông báo',
                subtitle: 'Tùy chỉnh thông báo',
                leadingIcon: Icons.notifications_outlined,
                onTap: () {
                  // Navigate to notification settings
                },
              ),
              _buildProfileTile(
                title: 'Ngôn ngữ',
                subtitle: 'Tiếng Việt',
                leadingIcon: Icons.language_outlined,
                onTap: () {
                  // Navigate to language settings
                },
              ),
              _buildProfileTile(
                title: 'Trợ giúp & Hỗ trợ',
                subtitle: 'Câu hỏi thường gặp, liên hệ hỗ trợ',
                leadingIcon: Icons.help_outline,
                onTap: () {
                  // Navigate to help center
                },
              ),
            ],
          ),

          SizedBox(height: 32),

          // Logout button
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showLogoutDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Đăng xuất',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(String username, String email, String role) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF13B8A8).withOpacity(0.1),
            border: Border.all(
              color: Color(0xFF13B8A8),
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.person,
              size: 50,
              color: Color(0xFF13B8A8),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          username,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          email,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFF13B8A8).withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            role,
            style: TextStyle(
              color: Color(0xFF13B8A8),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF222222),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Color(0xFF13B8A8),
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.white.withOpacity(0.1)),
          ...children,
        ],
      ),
    );
  }

  Widget _buildProfileTile({
    required String title,
    required String subtitle,
    required IconData leadingIcon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFF333333),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                leadingIcon,
                color: Colors.white70,
                size: 20,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Color(0xFF333333),
        title: Text(
          'Đăng xuất',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Bạn có chắc chắn muốn đăng xuất?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Hủy',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthenticationBloc>().add(LoggedOut());
              // Navigate to welcome screen (you'll need to implement this)
            },
            child: Text(
              'Đăng xuất',
              style: TextStyle(color: Color(0xFF13B8A8)),
            ),
          ),
        ],
      ),
    );
  }
}