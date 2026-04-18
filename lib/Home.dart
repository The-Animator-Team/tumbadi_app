import 'package:flutter/material.dart';
import 'package:tumbadi_app/Webviewpage.dart';
import 'package:tumbadi_app/widget/Banner.dart';
import 'package:tumbadi_app/widget/BottomNavigation.dart';
import 'package:tumbadi_app/widget/DrawerNavigation.dart';
import 'package:tumbadi_app/widget/ScrollingItems.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static const Color _backgroundColor = Color.fromRGBO(253, 231, 234, 1);
  static const Color _brandColor = Color.fromARGB(255, 173, 18, 7);

  static const List<_HomeFeature> _features = [
    _HomeFeature(
      title: 'Image Gallery',
      subtitle: 'Photos, moments, and community highlights',
      imagePath: 'assets/images/gallery.jpg',
      webUrl: 'photos',
      pageTitle: 'Image Gallery',
      icon: Icons.photo_library_rounded,
    ),
    _HomeFeature(
      title: 'B2B',
      subtitle: 'Explore business listings and opportunities',
      imagePath: 'assets/images/business.png',
      webUrl: 'b2b',
      pageTitle: 'B2B',
      icon: Icons.storefront_rounded,
    ),
    _HomeFeature(
      title: 'Events',
      subtitle: 'Stay updated with the latest community news',
      imagePath: 'assets/images/newsevent.jpg',
      webUrl: 'events',
      pageTitle: 'Events',
      icon: Icons.event_available_rounded,
    ),
    _HomeFeature(
      title: 'Mataji',
      subtitle: 'Spiritual updates and related information',
      imagePath: 'assets/images/mataji.png',
      webUrl: 'mataji',
      pageTitle: 'Mataji',
      icon: Icons.self_improvement_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Home'),
        foregroundColor: Colors.black,
        backgroundColor: _backgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      drawer: const DrawerNavigation(),
      bottomNavigationBar: const BottomNavigation(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
        children: [
          _buildBannerCard(),
          const SizedBox(height: 16),
          const ScrollingItems(),
          const SizedBox(height: 18),
          _buildSectionHeader(),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _features.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.84,
            ),
            itemBuilder: (context, index) {
              return _buildFeatureCard(context, _features[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: const MyBanner(),
    );
  }

  Widget _buildSectionHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF211E1B),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Quick access to the most-used sections of the app.',
            style: TextStyle(
              fontSize: 13,
              height: 1.35,
              color: Color(0xFF786F67),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, _HomeFeature feature) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Webviewpage(
                  webUrl: feature.webUrl,
                  title: feature.pageTitle,
                );
              },
            ),
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(feature.imagePath, fit: BoxFit.cover),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.12),
                        Colors.black.withOpacity(0.18),
                        Colors.black.withOpacity(0.72),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.18)),
                  ),
                  child: Icon(feature.icon, color: Colors.white, size: 18),
                ),
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.18)),
                  ),
                  child: const Icon(
                    Icons.arrow_outward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _brandColor.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Open section',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      feature.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      feature.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFF3EDEA),
                        fontSize: 12.5,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeFeature {
  final String title;
  final String subtitle;
  final String imagePath;
  final String webUrl;
  final String pageTitle;
  final IconData icon;

  const _HomeFeature({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.webUrl,
    required this.pageTitle,
    required this.icon,
  });
}
