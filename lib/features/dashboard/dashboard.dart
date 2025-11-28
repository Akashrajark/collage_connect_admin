import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            children: [
              FutureBuilder(
                  future: Supabase.instance.client.from('collages').count(),
                  builder: (context, asyncSnapshot) {
                    return DashboardItem(
                      isLoading: asyncSnapshot.connectionState == ConnectionState.waiting,
                      count: asyncSnapshot.hasData ? asyncSnapshot.data!.toString() : '0',
                      label: 'Collages',
                      color: const Color(0xFFA9E4FA),
                    );
                  }),
              const SizedBox(width: 12),
              FutureBuilder(
                  future: Supabase.instance.client.from('students').count(),
                  builder: (context, asyncSnapshot) {
                    return DashboardItem(
                      isLoading: asyncSnapshot.connectionState == ConnectionState.waiting,
                      count: asyncSnapshot.hasData ? asyncSnapshot.data!.toString() : '0',
                      label: 'Sudents',
                      color: const Color(0xFFFFE4BC),
                    );
                  }),
              const SizedBox(width: 12),
              FutureBuilder(
                  future: Supabase.instance.client.from('canteens').count(),
                  builder: (context, asyncSnapshot) {
                    return DashboardItem(
                      isLoading: asyncSnapshot.connectionState == ConnectionState.waiting,
                      count: asyncSnapshot.hasData ? asyncSnapshot.data!.toString() : '0',
                      label: 'Canteen',
                      color: const Color(0xFFF8BAB9),
                    );
                  }),
              const SizedBox(width: 12),
              FutureBuilder(
                  future: Supabase.instance.client.from('courses').count(),
                  builder: (context, asyncSnapshot) {
                    return DashboardItem(
                      isLoading: asyncSnapshot.connectionState == ConnectionState.waiting,
                      count: asyncSnapshot.hasData ? asyncSnapshot.data!.toString() : '0',
                      label: 'Courses',
                      color: const Color(0xFFE0E2E2),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final String count;
  final String label;
  final Color color;
  final bool isLoading;
  const DashboardItem({
    super.key,
    required this.count,
    required this.label,
    required this.color,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color,
            child: isLoading
                ? const CircularProgressIndicator()
                : Text(
                    count,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Black text inside circle
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black, // White text
            ),
          ),
        ],
      ),
    );
  }
}
