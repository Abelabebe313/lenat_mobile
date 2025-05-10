import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/core/colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'ፕሮፋይል',
          style: TextStyle(
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
          const SizedBox(height: 16),
          _buildProfileHeader(),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/premium',
              );
            },
            child: _buildPremiumCard(),
          ),
          const SizedBox(height: 32),
          _buildSectionTitle('አጠቃላይ ቅንብር'),
          _buildUserInfoList(),
          const SizedBox(height: 32),
          _buildSectionTitle('እርዳታ እና ድጋፍ'),
          _buildHelpCenterList(),
          const SizedBox(height: 32),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
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
                const Text(
                  'የተጠቃሚ ስም',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSansEthiopic',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.verified, color: Colors.blue, size: 18),
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
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ),
              ),
              child: Text(
                "ፕሮፋይል አስተካክል",
                style: TextStyle(
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

  Widget _buildPremiumCard() {
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
                children: const [
                  Text(
                    'ለናለናት ፕሪሚየም',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'NotoSansEthiopic',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Lorem ipsum dolor sit amet consectetur Mattis',
                    style: TextStyle(
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

  Widget _buildSectionTitle(String title) {
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

  Widget _buildUserInfoList() {
    return Column(
      children: [
        _buildListItem(HugeIcons.strokeRoundedUserCircle, 'የተጠቃሚ መረጃ'),
        _buildListItem(HugeIcons.strokeRoundedNotification02, 'ማሳወቂያዎች'),
      ],
    );
  }

  Widget _buildHelpCenterList() {
    return Column(
      children: [
        _buildListItem(HugeIcons.strokeRoundedSecurity, 'የህብረት'),
        _buildListItem(HugeIcons.strokeRoundedHelpCircle, 'የእርዳታ ጥያቄዎች'),
        _buildListItem(HugeIcons.strokeRoundedInformationCircle, 'መረጃ'),
      ],
    );
  }

  Widget _buildListItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          HugeIcon(
            icon: icon,
            color: Colors.black,
            size: 24.0,
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'NotoSansEthiopic',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF0423F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 36,
              vertical: 12,
            ),
          ),
          child: Text(
            "ውጣ",
            style: TextStyle(
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
}
