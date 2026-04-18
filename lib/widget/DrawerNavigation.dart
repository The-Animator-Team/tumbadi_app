import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tumbadi_app/Webviewpage.dart';

import '../Config.dart';
import '../Directory.dart';
import '../Login.dart';

class DrawerNavigation extends StatelessWidget {
  const DrawerNavigation({super.key});

  static const Color _brandColor = Color.fromARGB(255, 173, 18, 7);
  static const Color _brandBackground = Color(0xFFFDE7EA);
  static const Color _drawerBackground = Color(0xFFFFFBF7);
  static const Color _textPrimary = Color(0xFF2A221D);
  static const Color _textSecondary = Color(0xFF6E625A);

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = GetStorage().read('islog') == 'true';
    final dynamic userData = GetStorage().read('user_data');

    return Drawer(
      backgroundColor: _drawerBackground,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(isLoggedIn: isLoggedIn, userData: userData),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 2, 12, 16),
                children: [
                  _buildDrawerTile(
                    context,
                    icon: Icons.home_rounded,
                    title: 'Home',
                    subtitle: 'Back to the main dashboard',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildExpansionSection(
                    context,
                    icon: Icons.info_outline_rounded,
                    title: 'About Us',
                    subtitle: 'History, mataji, committee, and community pages',
                    children: [
                      _buildNestedTile(
                        context,
                        title: 'History',
                        onTap: () {
                          _openWebview(
                            context,
                            webUrl: 'history',
                            title: 'History',
                          );
                        },
                      ),
                      _buildNestedTile(
                        context,
                        title: 'President Message',
                        onTap: () {
                          _openWebview(
                            context,
                            webUrl: 'president-message',
                            title: 'President Message',
                          );
                        },
                      ),
                      _buildNestedTile(
                        context,
                        title: 'Mataji',
                        onTap: () {
                          _openWebview(
                            context,
                            webUrl: 'mataji',
                            title: 'Mataji',
                          );
                        },
                      ),
                      _buildNestedTile(
                        context,
                        title: 'Place To Visit',
                        subtitle: 'Spiritual places and community visits',
                        onTap: () {
                          _openWebview(
                            context,
                            webUrl: 'placestovisit',
                            title: 'Place To Visit',
                          );
                        },
                      ),
                      _buildNestedTile(
                        context,
                        title: 'Committee',
                        onTap: () {
                          _openWebview(
                            context,
                            webUrl: 'committee-members-v2',
                            title: 'Committee Members',
                          );
                        },
                      ),
                    ],
                  ),
                  _buildDrawerTile(
                    context,
                    icon: Icons.event_available_rounded,
                    title: 'Events',
                    subtitle: 'Latest activities and announcements',
                    onTap: () {
                      _openWebview(
                        context,
                        webUrl: 'events',
                        title: 'Latest News',
                      );
                    },
                  ),
                  _buildExpansionSection(
                    context,
                    icon: Icons.photo_library_outlined,
                    title: 'Gallery',
                    subtitle: 'Photos and media from community moments',
                    children: [
                      _buildNestedTile(
                        context,
                        title: 'Image Gallery',
                        onTap: () {
                          _openWebview(
                            context,
                            webUrl: 'photos',
                            title: 'Image Gallery',
                          );
                        },
                      ),
                    ],
                  ),
                  _buildDrawerTile(
                    context,
                    icon: Icons.groups_rounded,
                    title: 'Directory',
                    subtitle: 'Members, families, and contact details',
                    onTap: () {
                      Navigator.pop(context);
                      if (GetStorage().read('islog') == 'true') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Directory(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      }
                    },
                  ),
                  _buildDrawerTile(
                    context,
                    icon: Icons.volunteer_activism_rounded,
                    title: 'Donation',
                    subtitle: 'Support the community initiatives',
                    onTap: () {
                      _openWebview(
                        context,
                        webUrl: 'donation',
                        title: 'Donation',
                      );
                    },
                  ),
                  _buildExpansionSection(
                    context,
                    icon: Icons.apps_rounded,
                    title: 'More',
                    subtitle: 'Business, jobs, matrimonial, and more',
                    children: [
                      _buildNestedTile(
                        context,
                        title: 'B2B',
                        onTap: () {
                          _openWebview(context, webUrl: 'b2b', title: 'B2B');
                        },
                      ),
                      _buildNestedTile(
                        context,
                        title: 'Jobs',
                        onTap: () {
                          _openWebview(context, webUrl: 'jobs', title: 'Jobs');
                        },
                      ),
                      _buildNestedTile(
                        context,
                        title: 'Matrimonial',
                        onTap: () {
                          _openWebview(
                            context,
                            webUrl: 'matrimonial',
                            title: 'Matrimonial',
                          );
                        },
                      ),
                      _buildNestedTile(
                        context,
                        title: 'Job Requirement',
                        onTap: () {
                          _openWebview(
                            context,
                            webUrl: 'job-requirement',
                            title: 'Job Requirement',
                          );
                        },
                      ),
                    ],
                  ),
                  _buildDrawerTile(
                    context,
                    icon: Icons.support_agent_rounded,
                    title: 'Contact Us',
                    subtitle: 'Reach out for help or enquiries',
                    onTap: () {
                      _openWebview(
                        context,
                        webUrl: 'contact',
                        title: 'Contact Us',
                      );
                    },
                  ),
                  if (isLoggedIn)
                    _buildDrawerTile(
                      context,
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      subtitle: 'Sign out from the current account',
                      onTap: () {
                        GetStorage().write('islog', 'false');
                        GetStorage().erase();
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                          msg: 'Logout successfully!!!',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                        );
                      },
                    ),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({required bool isLoggedIn, required dynamic userData}) {
    final String fullName = _buildFullName(userData);

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _brandBackground,
            _brandBackground.withOpacity(0.92),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child:
          isLoggedIn
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.78),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Logged In',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: _brandColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          fullName.isEmpty ? 'Community Member' : fullName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            height: 1.25,
                            fontWeight: FontWeight.w800,
                            color: _textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'SHREE KUTCH TUMBADI JAIN MAHAJAN',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.6,
                            height: 1.35,
                            fontWeight: FontWeight.w600,
                            color: _textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildLogoSurface(
                    child: Image(
                      image: NetworkImage(Config.logo),
                      width: 66,
                      height: 66,
                    ),
                  ),
                ],
              )
              : Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: _textPrimary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sign in to access directory, profile, and member-only features.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                            color: _textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildLogoSurface(
                    child: const Image(
                      image: AssetImage('assets/logo.png'),
                      width: 72,
                      height: 72,
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildDrawerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: _cardDecoration(),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        minLeadingWidth: 0,
        leading: _buildLeadingIcon(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15.4,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12.4,
              height: 1.3,
              color: _textSecondary,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: _textSecondary,
        ),
      ),
    );
  }

  Widget _buildExpansionSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: _cardDecoration(),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          iconColor: _brandColor,
          collapsedIconColor: _textSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          leading: _buildLeadingIcon(icon),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15.4,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12.4,
                height: 1.3,
                color: _textSecondary,
              ),
            ),
          ),
          children: children,
        ),
      ),
    );
  }

  Widget _buildNestedTile(
    BuildContext context, {
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Material(
        color: const Color(0xFFF9F1EC),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_outward_rounded,
                    size: 17,
                    color: _brandColor,
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
                          fontSize: 14.3,
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12.1,
                            height: 1.3,
                            color: _textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: _textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
      child: Column(
        children: [
          Divider(thickness: 1.2, color: _brandColor.withOpacity(0.16)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _SocialIcon(icon: FontAwesomeIcons.facebook),
              SizedBox(width: 24),
              _SocialIcon(icon: FontAwesomeIcons.instagram),
              SizedBox(width: 24),
              _SocialIcon(icon: FontAwesomeIcons.youtube),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: const [
        BoxShadow(
          color: Color(0x11000000),
          blurRadius: 18,
          offset: Offset(0, 10),
        ),
      ],
    );
  }

  Widget _buildLeadingIcon(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: _brandColor.withOpacity(0.09),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(icon, color: _brandColor),
    );
  }

  Widget _buildLogoSurface({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  String _buildFullName(dynamic userData) {
    if (userData is! Map) {
      return '';
    }

    final List<String> parts =
        [
              userData['first_name']?.toString().trim() ?? '',
              userData['middle_name']?.toString().trim() ?? '',
              userData['sur_name']?.toString().trim() ?? '',
            ]
            .where((part) => part.isNotEmpty && part.toLowerCase() != 'null')
            .toList();

    return parts.join(' ');
  }

  void _openWebview(
    BuildContext context, {
    required String webUrl,
    required String title,
  }) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Webviewpage(webUrl: webUrl, title: title),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;

  const _SocialIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: DrawerNavigation._brandColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: DrawerNavigation._brandColor, size: 18),
    );
  }
}
