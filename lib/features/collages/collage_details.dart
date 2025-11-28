import 'package:flutter/material.dart';

import '../../common_widget/custom_alert_dialog.dart';

class CollageDetails extends StatelessWidget {
  final Map<dynamic, dynamic> collage;

  const CollageDetails({
    super.key,
    required this.collage,
  });

  @override
  Widget build(BuildContext context) {
    final name = collage['name']?.toString() ?? '-';
    final description = collage['description']?.toString() ?? '-';
    final email = collage['email']?.toString() ?? '-';
    final phone = collage['phone']?.toString() ?? '-';
    final address = collage['address']?.toString() ?? '-';
    final imageUrl = collage['image_url']?.toString() ?? '';
    final id = collage['id']?.toString() ?? '-';

    return CustomAlertDialog(
      title: 'Collage Details',
      content: Flexible(
        child: ListView(
          shrinkWrap: true,
          children: [
            // Image
            if (imageUrl.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                    ),
                  ),
                ),
              )
            else
              Center(
                child: Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo, size: 48, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 20),

            // Name
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoItem('Collage ID', id, Icons.badge),
            const SizedBox(height: 16),
            _buildInfoItem('Email', email, Icons.email),
            const SizedBox(height: 16),
            _buildInfoItem('Phone', phone, Icons.phone),
            const SizedBox(height: 16),
            _buildInfoItem('Address', address, Icons.location_on),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        border: const Border(left: BorderSide(color: Color(0xFF2563EB), width: 3)),
        color: const Color(0xFF2563EB).withOpacity(0.05),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2563EB), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
