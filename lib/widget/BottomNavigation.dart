import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tumbadi_app/Login.dart';

import '../Announcement.dart';
import '../Profile.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  static const Color _brandColor = Color.fromARGB(255, 173, 18, 7);
  int _selectedIndex = 0;

  Future<void> _onItemTapped(int index) async {
    if (index == 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const Announcement();
          },
        ),
      );
    }

    if (index == 2) {
      if (GetStorage().read('islog') == 'true') {
        GetStorage().write('isdir', 'false');
        final userdata = GetStorage().read('user_data');

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Profile(user_id: userdata['id'].toString());
            },
          ),
        );
      } else {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Login();
            },
          ),
        );
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Container(
          decoration: BoxDecoration(
            color: _brandColor,
            borderRadius: BorderRadius.circular(26),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 22,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: BottomNavigationBar(
              backgroundColor: _brandColor,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_rounded),
                  activeIcon: _buildActiveIcon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.notifications_active_outlined),
                  activeIcon: _buildActiveIcon(
                    Icons.notifications_active_rounded,
                  ),
                  label: 'Notices',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.account_circle_outlined),
                  activeIcon: _buildActiveIcon(Icons.account_circle_rounded),
                  label: 'Profile',
                ),
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon),
    );
  }
}
