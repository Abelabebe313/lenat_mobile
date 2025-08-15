import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lenat_mobile/app/service_locator.dart';
import 'package:lenat_mobile/services/share_service.dart';

class ShareOptionsModal extends StatefulWidget {
  final String imageUrl;
  final String description;

  const ShareOptionsModal({
    super.key,
    required this.imageUrl,
    required this.description,
  });

  @override
  State<ShareOptionsModal> createState() => _ShareOptionsModalState();
}

class _ShareOptionsModalState extends State<ShareOptionsModal> {
  final _shareService = locator<ShareService>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Share to',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Share options grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Social media platforms
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildShareOption(
                      icon: Icons.facebook,
                      label: 'Facebook',
                      color: const Color(0xFF1877F2),
                      onTap: () => _shareToFacebook(),
                    ),
                    _buildShareOption(
                      icon: Icons.camera_alt,
                      label: 'Instagram',
                      color: const Color(0xFFE4405F),
                      onTap: () => _shareToInstagram(),
                    ),
                    _buildShareOption(
                      icon: Icons.flutter_dash,
                      label: 'Twitter',
                      color: const Color(0xFF1DA1F2),
                      onTap: () => _shareToTwitter(),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildShareOption(
                      icon: Icons.message,
                      label: 'WhatsApp',
                      color: const Color(0xFF25D366),
                      onTap: () => _shareToWhatsApp(),
                    ),
                    _buildShareOption(
                      icon: Icons.telegram,
                      label: 'Telegram',
                      color: const Color(0xFF0088CC),
                      onTap: () => _shareToTelegram(),
                    ),
                    _buildShareOption(
                      icon: Icons.save_alt,
                      label: 'Save',
                      color: Colors.grey[700]!,
                      onTap: () => _saveToGallery(),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // General share option
                SizedBox(
                  width: double.infinity,
                  child: _buildShareOption(
                    icon: Icons.share,
                    label: 'More Options',
                    color: Colors.blue,
                    onTap: () => _shareGeneral(),
                    isFullWidth: true,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Cancel button
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isFullWidth = false,
  }) {
    return GestureDetector(
      onTap: _isLoading ? null : onTap,
      child: Container(
        width: isFullWidth ? double.infinity : 80,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _isLoading ? Colors.grey[200] : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _isLoading ? Colors.grey : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future<void> _shareToFacebook() async {
    _setLoading(true);
    try {
      await _shareService.shareToFacebook(
        imageUrl: widget.imageUrl,
        description: widget.description,
      );
      Navigator.of(context).pop();
    } catch (e) {
      _showErrorSnackBar('Failed to share to Facebook');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _shareToInstagram() async {
    _setLoading(true);
    try {
      await _shareService.shareToInstagram(
        imageUrl: widget.imageUrl,
        caption: widget.description,
      );
      Navigator.of(context).pop();
    } catch (e) {
      _showErrorSnackBar('Failed to share to Instagram');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _shareToTwitter() async {
    _setLoading(true);
    try {
      await _shareService.shareToTwitter(
        imageUrl: widget.imageUrl,
        text: widget.description,
      );
      Navigator.of(context).pop();
    } catch (e) {
      _showErrorSnackBar('Failed to share to Twitter');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _shareToWhatsApp() async {
    _setLoading(true);
    try {
      await _shareService.shareToWhatsApp(
        imageUrl: widget.imageUrl,
        message: widget.description,
      );
      Navigator.of(context).pop();
    } catch (e) {
      _showErrorSnackBar('Failed to share to WhatsApp');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _shareToTelegram() async {
    _setLoading(true);
    try {
      await _shareService.shareToTelegram(
        imageUrl: widget.imageUrl,
        caption: widget.description,
      );
      Navigator.of(context).pop();
    } catch (e) {
      _showErrorSnackBar('Failed to share to Telegram');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _saveToGallery() async {
    _setLoading(true);
    try {
      final success = await _shareService.saveImageToGallery(
        imageUrl: widget.imageUrl,
        name: 'lenat_content_${DateTime.now().millisecondsSinceEpoch}',
      );
      
      if (success) {
        Navigator.of(context).pop();
        _showSuccessSnackBar('Image saved to gallery');
      } else {
        _showErrorSnackBar('Failed to save image to gallery');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to save image to gallery');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _shareGeneral() async {
    _setLoading(true);
    try {
      await _shareService.shareImage(
        imageUrl: widget.imageUrl,
        description: widget.description,
      );
      Navigator.of(context).pop();
    } catch (e) {
      _showErrorSnackBar('Failed to share image');
    } finally {
      _setLoading(false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
} 