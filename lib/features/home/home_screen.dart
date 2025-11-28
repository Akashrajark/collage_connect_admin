import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/collages/collage_screen.dart';
import 'package:flutter_application_1/features/login/loginscreen.dart';
import 'package:flutter_application_1/features/student/student_screen.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../common_widget/change_password.dart';
import '../../common_widget/custom_alert_dialog.dart';
import '../dashboard/dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 200), () {
      final GoTrueClient auth = Supabase.instance.client.auth;
      if (auth.currentUser == null || auth.currentUser!.appMetadata['role'] != 'admin') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Loginscreen(),
          ),
        );
      }
    });

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: Row(
        children: [
          Container(
              width: 250,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      'College connect',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 90),
                    DrawerItem(
                      isActive: _tabController.index == 0,
                      iconData: Icons.dashboard_rounded,
                      label: 'Dashboard',
                      onTap: () {
                        _tabController.animateTo(0);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DrawerItem(
                      isActive: _tabController.index == 1,
                      iconData: Icons.school,
                      label: 'Colleges',
                      onTap: () {
                        _tabController.animateTo(1);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DrawerItem(
                      isActive: _tabController.index == 2,
                      iconData: Icons.people,
                      label: 'Students',
                      onTap: () {
                        _tabController.animateTo(2);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DrawerItem(
                      iconData: Icons.lock_outline_rounded,
                      label: "Change Password",
                      isActive: _tabController.index == 3,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const ChangePasswordDialog(),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DrawerItem(
                        iconData: Icons.logout_rounded,
                        label: "Log Out",
                        isActive: _tabController.index == 4,
                        onTap: () {
                          bool isLoading = false;
                          showDialog(
                            context: context,
                            builder: (context) => CustomAlertDialog(
                              isLoading: isLoading,
                              title: "LOG OUT",
                              content: const Text(
                                "Are you sure you want to log out? Clicking 'Logout' will end your current session and require you to sign in again to access your account.",
                              ),
                              width: 400,
                              primaryButton: "LOG OUT",
                              onPrimaryPressed: () {
                                isLoading = true;
                                setState(() {});
                                Supabase.instance.client.auth.signOut();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Loginscreen(),
                                    ),
                                    (route) => false);
                              },
                            ),
                          );
                        }),
                  ],
                ),
              )),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: const [
                DashboardScreen(),
                CollageScreen(),
                StudentScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData iconData;
  final String label;
  final Function() onTap;
  final bool isActive;
  const DrawerItem({
    super.key,
    required this.iconData,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: isActive ? primaryColor.withAlpha(20) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isActive
              ? const BorderSide(
                  color: primaryColor,
                  width: 1.5,
                )
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Row(
            children: [
              Icon(iconData, color: isActive ? primaryColor : Colors.grey),
              SizedBox(
                width: 10,
              ),
              Text(label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isActive ? primaryColor : Colors.grey,
                        fontWeight: FontWeight.bold,
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
