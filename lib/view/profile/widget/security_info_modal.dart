import 'package:flutter/material.dart';
import 'package:lenat_mobile/core/colors.dart';

class SecurityInfoModal extends StatelessWidget {
  final bool isAmharic;

  const SecurityInfoModal({
    Key? key,
    required this.isAmharic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.security,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAmharic ? 'ደህንነት' : 'Security',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NotoSansEthiopic',
                        ),
                      ),
                      Text(
                        isAmharic ? 'የመረጃ ደህንነት መመሪያዎች' : 'Information Security Guidelines',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'NotoSansEthiopic',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Security Tips
            _buildSecurityTip(
              icon: Icons.lock,
              title: isAmharic ? 'የይለፍ ቃል ጥንካሬ' : 'Strong Password',
              description: isAmharic 
                ? 'የይለፍ ቃልዎ ከ8 ቁጥሮች በላይ እና ፊደላት፣ ቁጥሮች እና ምልክቶች እንዲያካትት ያድርጉ'
                : 'Use passwords with 8+ characters including letters, numbers, and symbols',
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            
            _buildSecurityTip(
              icon: Icons.verified_user,
              title: isAmharic ? 'ሁለት-ደረጃ ማረጋገጫ' : 'Two-Factor Authentication',
              description: isAmharic 
                ? 'የስልክ ቁጥርዎን ለማረጋገጫ ያገለግሉ'
                : 'Use your phone number for verification',
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            
            _buildSecurityTip(
              icon: Icons.privacy_tip,
              title: isAmharic ? 'ግላዊ መረጃ' : 'Privacy Protection',
              description: isAmharic 
                ? 'የግል መረጃዎን ከሶስተኛ ወገን አያሳውቁ'
                : 'Never share personal information with third parties',
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            
            _buildSecurityTip(
              icon: Icons.logout,
              title: isAmharic ? 'ደህንነቱ የተጠበቀ ውጣት' : 'Secure Logout',
              description: isAmharic 
                ? 'አካውንትዎን ከሌሎች መሣሪያዎች ላይ ያስወግዱ'
                : 'Log out from all devices when not in use',
              color: Colors.red,
            ),
            const SizedBox(height: 24),
            
            // Warning Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red[700],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isAmharic 
                        ? 'የግል መረጃዎን አያጋሩ። ለእናቶች የተዘጋጀ ይህ መተግበሪያ ደህንነቱ የተጠበቀ ነው።'
                        : 'Keep your information private. This app is designed for mothers and is secure.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[700],
                        fontFamily: 'NotoSansEthiopic',
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  isAmharic ? 'ዝጋ' : 'Close',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'NotoSansEthiopic',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityTip({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontFamily: 'NotoSansEthiopic',
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 