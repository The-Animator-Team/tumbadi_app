import 'dart:convert';

import 'package:banner_carousel/banner_carousel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tumbadi_app/Config.dart';
import 'package:tumbadi_app/widget/FancyLoader.dart';

class MyBanner extends StatefulWidget {
  const MyBanner({super.key});

  @override
  State<MyBanner> createState() => _MyBannerState();
}

class _MyBannerState extends State<MyBanner> {
  List<BannerModel> banners = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadBanners();
  }

  Future<void> loadBanners() async {
    try {
      final fetchedBanners = await BannerImages.getBanner();

      if (!mounted) return;

      setState(() {
        banners = fetchedBanners;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
        banners = [];
      });

      print('loadBanners error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: FancyLoader(
            label: 'Loading banners',
            icon: Icons.image_rounded,
            size: 82,
            showCard: false,
          ),
        ),
      );
    }

    if (banners.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No banners available')),
      );
    }

    return SizedBox(
      height: 200,
      child: BannerCarousel.fullScreen(
        banners: banners,
        height: 200,
        animation: true,
        borderRadius: 10,
        indicatorBottom: false,
      ),
    );
  }
}

class BannerImages {
  static Future<List<BannerModel>> getBanner() async {
    try {
      final String url = Config.banner;
      final res = await http.get(Uri.parse(url));

      print('Banner API status: ${res.statusCode}');
      print('Banner API body: ${res.body}');

      if (res.statusCode != 200) {
        throw Exception('Failed to load banners. Status: ${res.statusCode}');
      }

      final body = res.body.trim();

      if (body.isEmpty) {
        throw Exception('Banner API returned empty response');
      }

      if (!(body.startsWith('{') || body.startsWith('['))) {
        throw Exception('Banner API did not return valid JSON: $body');
      }

      final dynamic data = jsonDecode(body);

      if (data is! Map<String, dynamic>) {
        throw Exception('Unexpected banner response format');
      }

      final dynamic rawBanners = data['banners'];

      if (rawBanners == null) {
        return [];
      }

      if (rawBanners is! List) {
        throw Exception('Expected "banners" to be a list');
      }

      return rawBanners
          .map<BannerModel>((item) {
            final map = item as Map<String, dynamic>;

            return BannerModel(
              imagePath: (map['file'] ?? '').toString(),
              id: (map['id'] ?? '').toString(),
            );
          })
          .where((banner) => banner.imagePath.isNotEmpty)
          .toList();
    } catch (e) {
      print('getBanner error: $e');
      rethrow;
    }
  }
}
