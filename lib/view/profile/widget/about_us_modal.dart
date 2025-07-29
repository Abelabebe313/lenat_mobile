import 'package:flutter/material.dart';
import 'package:lenat_mobile/core/colors.dart';

class AboutUsModal extends StatelessWidget {
  final bool isAmharic;

  const AboutUsModal({
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
        padding: const EdgeInsets.all(16),
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
                    color: Primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAmharic ? 'ስለ ለእናት' : 'About Lenat',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NotoSansEthiopic',
                        ),
                      ),
                      Text(
                        isAmharic ? 'የእናቶች ማህበረሰብ መተግበሪያ' : 'Mothers Community App',
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
            
            // App Logo/Icon
            Container(
              width: 85,
              height: 85,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset(
                'assets/icons/logo.png',
                width: 70,
                height: 70,
              ),
            ),
            const SizedBox(height: 16),
            
            // App Name
            Text(
              'Lenat',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Primary,
                fontFamily: 'NotoSansEthiopic',
              ),
            ),
            const SizedBox(height: 8),
            
            // Version
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'NotoSansEthiopic',
              ),
            ),
            const SizedBox(height: 24),
            
            // Description
            Text(
              isAmharic 
                ? 'ለእናት የእናቶች ማህበረሰብ መተግበሪያ ነው። ይህ መተግበሪያ እናቶች እርስ በርስ እንዲገናኙ፣ ስልተ ቀመሮችን እንዲያጋሩ፣ እና የሚያስፈልጋቸውን መረጃ እንዲያገኙ ያገለግላል።'
                : 'Lenat is a mothers community application designed to connect mothers, share experiences, and provide essential information for maternal health and childcare.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                fontFamily: 'NotoSansEthiopic',
              ),
            ),
            const SizedBox(height: 24),
            
            // Features
            _buildFeatureItem(
              icon: Icons.group,
              title: isAmharic ? 'የእናቶች ማህበረሰብ' : 'Mothers Community',
              description: isAmharic ? 'እናቶችን እርስ በርስ ያግኙ' : 'Connect with other mothers',
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(
              icon: Icons.health_and_safety,
              title: isAmharic ? 'የጤና መረጃ' : 'Health Information',
              description: isAmharic ? 'የእናት እና ሕፃን ጤና መረጃ' : 'Maternal and child health info',
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(
              icon: Icons.quiz,
              title: isAmharic ? 'የእውቀት ፈተና' : 'Knowledge Quiz',
              description: isAmharic ? 'የእናት እውቀት ይሞክሩ' : 'Test your maternal knowledge',
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

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Primary,
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
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontFamily: 'NotoSansEthiopic',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 