import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';
import 'package:provider/provider.dart';
import 'package:lenat_mobile/view/profile/profile_viewmodel.dart';
import 'package:lenat_mobile/view/auth/auth_viewmodel.dart';
import 'package:lenat_mobile/view/profile_setup/profile_setup_viewmodel.dart';
import 'package:lenat_mobile/view/profile_edit/profile_edit_viewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        print('Selected image path: ${image.path}');

        // Upload the image
        final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
        await viewModel.uploadProfileImage(_selectedImage!);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                viewModel.isAmharic
                    ? 'ምስሉ በተሳክቷል ተስተካክሏል'
                    : 'Image uploaded successfully',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              viewModel.isAmharic
                  ? 'ምስሉን ማስተካከል አልተሳካም'
                  : 'Failed to upload image',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImagePickerBottomSheet() {
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                viewModel.isAmharic ? 'ምስል ምረጥ' : 'Select Image',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
              const SizedBox(height: 20),
              // ListTile(
              //   leading: const Icon(Icons.camera_alt),
              //   title: Text(
              //     viewModel.isAmharic ? 'ካሜራ' : 'Camera',
              //     style: const TextStyle(fontFamily: 'NotoSansEthiopic'),
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //     _pickImage(ImageSource.camera);
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(
                  viewModel.isAmharic ? 'ጋለሪ ክፈት' : 'Open Gallery',
                  style: const TextStyle(fontFamily: 'NotoSansEthiopic'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Load user data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("load user data");
      Provider.of<ProfileViewModel>(context, listen: false).loadUserData();
    });
  }

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
          _buildDeleteAccountButton(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    return Row(
      children: [
        const SizedBox(width: 32),
        Stack(
          children: [
            GestureDetector(
              onTap: _showImagePickerBottomSheet,
              child: viewModel.currentUser?.media?['url'] != null
                  ? Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                          image: _selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(_selectedImage!),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image:
                                      NetworkImage(viewModel.currentUser?.media?['url'] ?? ''),
                                  fit: BoxFit.cover,
                                )),
                      child: viewModel.isUploading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : null,
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          viewModel.currentUser?.fullName?.substring(0, 1) ??
                              "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NotoSansEthiopic',
                          ),
                        ),
                      ),
                    ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _showImagePickerBottomSheet,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  viewModel.currentUser?.fullName ?? 'Username',
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
            Text(
              viewModel.currentUser?.phoneNumber ?? 'No phone number',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: 'NotoSansEthiopic',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile-edit');
              },
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
                backgroundColor: Colors.white,
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
                      viewModel.isAmharic ? 'አዎ' : 'Logout',
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
                // Reset all ViewModels
                final profileViewModel =
                    Provider.of<ProfileViewModel>(context, listen: false);
                final profileSetupViewModel =
                    Provider.of<ProfileSetupViewModel>(context, listen: false);
                final profileEditViewModel =
                    Provider.of<ProfileEditViewModel>(context, listen: false);

                profileViewModel.resetProfileData();
                profileSetupViewModel.resetProfileSetupData();
                profileEditViewModel.resetProfileEditData();

                // Perform logout
                await authViewModel.logout();

                if (context.mounted) {
                  // Navigate to login and clear all routes
                  Navigator.pushReplacementNamed(context, '/login');
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

  Widget _buildDeleteAccountButton(BuildContext context) {
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
        backgroundColor: Colors.white,
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
