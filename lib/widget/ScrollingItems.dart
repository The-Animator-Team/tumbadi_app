import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tumbadi_app/Directory.dart';
import 'package:tumbadi_app/Login.dart';
import 'package:tumbadi_app/Webviewpage.dart';

class ScrollingItems extends StatelessWidget {
  const ScrollingItems({super.key});

  static const Color _brandColor = Color.fromARGB(255, 173, 18, 7);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
          child: Row(
            children: const [
              Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF211E1B),
                ),
              ),
              Spacer(),
              Text(
                'Tap to open',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7B746D),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildQuickAccessCard(
                context: context,
                title: 'Directory',
                subtitle: 'Browse community profiles and member details.',
                icon: Icons.people_alt_rounded,
                onTap: () {
                  if (GetStorage().read('islog') == 'true') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Directory();
                        },
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Login();
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickAccessCard(
                context: context,
                title: 'Donation',
                subtitle: 'Support the trust with a simpler giving flow.',
                icon: Icons.volunteer_activism_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Webviewpage(
                          webUrl: 'donation',
                          title: 'Donation',
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAccessCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          height: 152,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
            border: Border.all(color: Color(0x14000000)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: _brandColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: _brandColor, size: 24),
                  ),
                  const Spacer(),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: Color(0xFF22201D),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF211E1B),
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  subtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.35,
                    color: Color(0xFF7B746D),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
