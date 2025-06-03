import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:provider/provider.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:lenat_mobile/view/auth/auth_viewmodel.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          viewModel.isAmharic ? 'ፕሮፋይል' : 'Profile',
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'NotoSansEthiopic',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildProfileHeader(context),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/premium');
            },
            child: _buildPremiumCard(context),
          ),
          const SizedBox(height: 16),
          _buildSectionTitle(
              viewModel.isAmharic ? 'አጠቃላይ ቅንብር' : 'General Settings', context),
          _buildUserInfoList(context),
          const SizedBox(height: 8),
          _buildSectionTitle(
              viewModel.isAmharic ? 'እርዳታ እና ድጋፍ' : 'Help & Support', context),
          _buildHelpCenterList(context),
          const SizedBox(height: 32),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    return Row(
      children: [
        const SizedBox(width: 32),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: AssetImage('assets/images/login-image.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  viewModel.isAmharic ? 'የተጠቃሚ ስም' : 'Username',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSansEthiopic',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.verified, color: Colors.blue, size: 18),
              ],
            ),
            const Text(
              '+251 9 123 456 78',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: 'NotoSansEthiopic',
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30),
              ),
              child: Text(
                viewModel.isAmharic ? "ፕሮፋይል አስተካክል" : "Edit Profile",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPremiumCard(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8BBDF4), Color(0xFF8BBDF4), Color(0xFF2688F2)],
            begin: Alignment.bottomLeft,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.star_rounded,
              color: Color(0xFFFFB200),
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    viewModel.isAmharic ? 'ለናለናት ፕሪሚየም' : 'Lenat Premium',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    viewModel.isAmharic
                        ? 'Lorem ipsum dolor sit amet consectetur Mattis'
                        : 'Upgrade to premium for exclusive features',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSansEthiopic',
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoList(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    return Column(
      children: [
        _buildListItem(
          HugeIcons.strokeRoundedUserCircle,
          viewModel.isAmharic ? 'የተጠቃሚ መረጃ' : 'User Information',
          onTap: () {},
        ),
        _buildListItem(
          HugeIcons.strokeRoundedNotification02,
          viewModel.isAmharic ? 'ማሳወቂያዎች' : 'Notifications',
          onTap: () {},
        ),
        _buildListItem(
          HugeIcons.strokeRoundedLanguageCircle,
          viewModel.isAmharic ? 'ቋንቋ ማስተካከል' : 'Language Settings',
          onTap: () => _showLanguageDialog(context),
          trailing: Text(
            viewModel.getLanguageText(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontFamily: 'NotoSansEthiopic',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHelpCenterList(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    return Column(
      children: [
        _buildListItem(
          HugeIcons.strokeRoundedSecurity,
          viewModel.isAmharic ? 'የህብረት' : 'Community',
          onTap: () {},
        ),
        _buildListItem(
          HugeIcons.strokeRoundedHelpCircle,
          viewModel.isAmharic ? 'የእርዳታ ጥያቄዎች' : 'Help & Questions',
          onTap: () {},
        ),
        _buildListItem(
          HugeIcons.strokeRoundedInformationCircle,
          viewModel.isAmharic ? 'መረጃ' : 'Information',
          onTap: () {},
        ),
        _buildListItem(
          HugeIcons.strokeRoundedLogout02,
          viewModel.isAmharic ? 'ውጣ' : 'Logout',
          onTap: () async {
            // Show confirmation dialog
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  viewModel.isAmharic ? 'ውጣ' : 'Logout',
                  style: const TextStyle(
                    fontFamily: 'NotoSansEthiopic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  viewModel.isAmharic
                      ? 'እርግጠኛ ነዎት መውጣት እንደሚፈልጉ?'
                      : 'Are you sure you want to logout?',
                  style: const TextStyle(
                    fontFamily: 'NotoSansEthiopic',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      viewModel.isAmharic ? 'ሰርዝ' : 'Cancel',
                      style: const TextStyle(
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      viewModel.isAmharic ? 'ውጣ' : 'Logout',
                      style: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                  ),
                ],
              ),
            );

            if (shouldLogout == true && context.mounted) {
              try {
                await authViewModel.logout();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        viewModel.isAmharic ? 'ውጣት አልተሳካም' : 'Logout failed',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildListItem(IconData icon, String title,
      {VoidCallback? onTap, Widget? trailing}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          children: [
            HugeIcon(
              icon: icon,
              color: Colors.black,
              size: 24.0,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'NotoSansEthiopic',
                  color: Colors.black,
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF0423F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 36,
              vertical: 12,
            ),
          ),
          child: Text(
            viewModel.isAmharic ? "አካውንት ሰርዝ" : "Delete Account",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontFamily: 'NotoSansEthiopic',
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          viewModel.isAmharic ? 'ቋንቋ ምረጥ' : 'Select Language',
          style: const TextStyle(
            fontFamily: 'NotoSansEthiopic',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text(
                'አማርኛ',
                style: TextStyle(fontFamily: 'NotoSansEthiopic'),
              ),
              onTap: () {
                if (!viewModel.isAmharic) {
                  viewModel.toggleLanguage();
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English'),
              onTap: () {
                if (viewModel.isAmharic) {
                  viewModel.toggleLanguage();
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
