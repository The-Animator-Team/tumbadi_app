import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tumbadi_app/widget/FancyLoader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import 'Config.dart';
import 'Profile.dart';

class Announcement extends StatefulWidget {
  const Announcement({super.key});

  @override
  State<Announcement> createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  final List<_NoticeTabConfig> _tabConfigs = const [
    _NoticeTabConfig(
      title: 'Birthday Wishes',
      subtitle: 'Celebrate today with a quick message or a warm call.',
      icon: Icons.cake_rounded,
      accentColor: Color(0xFFE18A2E),
      emptyMessage: 'No birthdays to show right now.',
      showContactActions: true,
    ),
    _NoticeTabConfig(
      title: 'Anniversary Wishes',
      subtitle: 'A simple and thoughtful list for sending wishes fast.',
      icon: Icons.favorite_rounded,
      accentColor: Color(0xFFC95D63),
      emptyMessage: 'No anniversaries available right now.',
      showContactActions: true,
    ),
    _NoticeTabConfig(
      title: 'Punytithi Notices',
      subtitle: 'Important remembrances presented in a calmer layout.',
      icon: Icons.local_florist_rounded,
      accentColor: Color(0xFF5B7C5F),
      emptyMessage: 'No punytithi notices right now.',
      showContactActions: true,
    ),
    _NoticeTabConfig(
      title: 'MaranNond Notices',
      subtitle: 'A cleaner view focused on names and notice details.',
      icon: Icons.auto_awesome_rounded,
      accentColor: Color(0xFF6A6DCD),
      emptyMessage: 'No MaranNond notices right now.',
      showContactActions: false,
    ),
  ];

  List<dynamic> birthday = [];
  List<dynamic> aniverary = [];
  List<dynamic> punytithi = [];
  List<dynamic> marannondh = [];

  bool _isLoading = true;
  bool _hasLoadError = false;
  String _errorMessage = '';
  DateTime? _lastUpdatedAt;

  bool get _hasAnyAnnouncements =>
      birthday.isNotEmpty ||
      aniverary.isNotEmpty ||
      punytithi.isNotEmpty ||
      marannondh.isNotEmpty;

  Future<void> _loadAnnouncements() async {
    final Uri requestUri = Uri.parse(Config.noticetab);

    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasLoadError = false;
        _errorMessage = '';
      });
    }

    try {
      final res = await http.get(requestUri);
      final body = res.body.trim();

      if (_looksLikeNoNoticeResponse(res, body, requestUri)) {
        _applyNoticeData(
          birthdayItems: const [],
          anniversaryItems: const [],
          punytithiItems: const [],
          marannondhItems: const [],
        );
        return;
      }

      if (res.statusCode != 200) {
        _handleLoadFailure('Unable to load notices right now.');
        return;
      }

      if (body.isEmpty) {
        _applyNoticeData(
          birthdayItems: const [],
          anniversaryItems: const [],
          punytithiItems: const [],
          marannondhItems: const [],
        );
        return;
      }

      if (!(body.startsWith('{') || body.startsWith('['))) {
        _handleLoadFailure('Notice response format was invalid.');
        return;
      }

      final data = jsonDecode(body);
      final responseData =
          data is Map<String, dynamic>
              ? (data['data'] as Map<String, dynamic>? ?? <String, dynamic>{})
              : <String, dynamic>{};

      _applyNoticeData(
        birthdayItems: List<dynamic>.from(responseData['birthday'] ?? const []),
        anniversaryItems: List<dynamic>.from(
          responseData['aniversary'] ?? const [],
        ),
        punytithiItems: List<dynamic>.from(
          responseData['punytithi'] ?? const [],
        ),
        marannondhItems: List<dynamic>.from(
          responseData['marannondh'] ?? const [],
        ),
      );
    } catch (e, st) {
      debugPrint('Announcement load failed: $e');
      debugPrintStack(stackTrace: st);
      _handleLoadFailure('Something went wrong while loading notices.');
    }
  }

  bool _looksLikeNoNoticeResponse(
    http.Response res,
    String body,
    Uri requestUri,
  ) {
    final Uri? finalUri = res.request?.url;
    final String contentType =
        (res.headers['content-type'] ?? '').toLowerCase();
    final String locationHeader = (res.headers['location'] ?? '').toLowerCase();
    final String lowerBody = body.toLowerCase();

    final bool redirectToHomePage =
        (res.statusCode == 301 ||
            res.statusCode == 302 ||
            res.statusCode == 303 ||
            res.statusCode == 307 ||
            res.statusCode == 308) &&
        (locationHeader == 'https://nanitumbadi.com' ||
            locationHeader == 'https://nanitumbadi.com/' ||
            locationHeader == '/');
    final bool redirectedAway =
        finalUri != null && finalUri.toString() != requestUri.toString();
    final bool htmlResponse =
        contentType.contains('text/html') ||
        lowerBody.startsWith('<!doctype') ||
        lowerBody.startsWith('<html');
    final bool looksLikeHomePage =
        lowerBody.contains('<title>shri kutch tumbdi jain mahajan</title>') ||
        lowerBody.contains(
          'redirecting to <a href="https://nanitumbadi.com">',
        ) ||
        lowerBody.contains('<div id="topbar"') ||
        lowerBody.contains('<header id="header"') ||
        lowerBody.contains('class="home-welcome');

    return redirectToHomePage ||
        ((redirectedAway || htmlResponse) && looksLikeHomePage);
  }

  void _applyNoticeData({
    required List<dynamic> birthdayItems,
    required List<dynamic> anniversaryItems,
    required List<dynamic> punytithiItems,
    required List<dynamic> marannondhItems,
  }) {
    if (!mounted) {
      return;
    }

    setState(() {
      birthday = birthdayItems;
      aniverary = anniversaryItems;
      punytithi = punytithiItems;
      marannondh = marannondhItems;
      _isLoading = false;
      _hasLoadError = false;
      _errorMessage = '';
      _lastUpdatedAt = DateTime.now();
    });
  }

  void _handleLoadFailure(String message) {
    if (!mounted) {
      return;
    }

    final bool hadData = _hasAnyAnnouncements;

    setState(() {
      _isLoading = false;
      _hasLoadError = true;
      _errorMessage = message;
    });

    if (hadData) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  List<dynamic> _itemsForIndex(int index) {
    switch (index) {
      case 0:
        return birthday;
      case 1:
        return aniverary;
      case 2:
        return punytithi;
      case 3:
        return marannondh;
      default:
        return const [];
    }
  }

  String _lastUpdatedLabel() {
    if (_lastUpdatedAt == null) {
      return 'Waiting';
    }

    final DateTime time = _lastUpdatedAt!;
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _launchWhatsApp(String mobileNo) async {
    final link = WhatsAppUnilink(
      phoneNumber: '91$mobileNo',
      text: 'Birthday Wishes ',
    );

    await _launchExternalUri(
      Uri.parse('$link'),
      errorMessage: 'Unable to open WhatsApp right now.',
    );
  }

  Future<void> _callMember(String mobileNo) async {
    await _launchExternalUri(
      Uri(scheme: 'tel', path: '91$mobileNo'),
      errorMessage: 'Unable to start the phone call.',
    );
  }

  Future<void> _launchExternalUri(
    Uri uri, {
    required String errorMessage,
  }) async {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  void _openProfile(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Profile(user_id: userId);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF7F2EA);
    const cardColor = Colors.white;

    return DefaultTabController(
      length: _tabConfigs.length,
      child: Builder(
        builder: (context) {
          final TabController tabController = DefaultTabController.of(context);

          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              backgroundColor: backgroundColor,
              title: const Text(
                'Notice',
                style: TextStyle(
                  color: Color(0xFF2B2A28),
                  fontWeight: FontWeight.w700,
                ),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: _loadAnnouncements,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Color(0xFF2B2A28),
                  ),
                  tooltip: 'Refresh notices',
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(84),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 18,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: TabBar(
                      isScrollable: true,
                      dividerColor: Colors.transparent,
                      splashBorderRadius: BorderRadius.circular(20),
                      indicatorPadding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                      labelColor: const Color(0xFF8D4B16),
                      unselectedLabelColor: const Color(0xFF7F827E),
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      indicator: BoxDecoration(
                        color: const Color(0xFFF4E3C6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      tabs: const [
                        Tab(text: 'Birthday'),
                        Tab(text: 'Anniversary'),
                        Tab(text: 'Punytithi'),
                        Tab(text: 'MaranNond'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: AnimatedBuilder(
                    animation: tabController.animation ?? tabController,
                    builder: (context, child) {
                      final int rawIndex = tabController.index;
                      final int currentIndex =
                          rawIndex < 0
                              ? 0
                              : rawIndex > _tabConfigs.length - 1
                              ? _tabConfigs.length - 1
                              : rawIndex;
                      final _NoticeTabConfig config = _tabConfigs[currentIndex];
                      final List<dynamic> items = _itemsForIndex(currentIndex);

                      return _buildOverviewPanel(
                        config: config,
                        itemCount: items.length,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      for (int index = 0; index < _tabConfigs.length; index++)
                        _buildNoticePage(
                          items: _itemsForIndex(index),
                          config: _tabConfigs[index],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewPanel({
    required _NoticeTabConfig config,
    required int itemCount,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [config.accentColor.withOpacity(0.18), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: config.accentColor.withOpacity(0.16)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: config.accentColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(config.icon, color: config.accentColor, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF272522),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      config.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: Color(0xFF706C67),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$itemCount',
                  style: TextStyle(
                    color: config.accentColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMiniInfoTile(
                  label: 'Entries',
                  value: '$itemCount',
                  accentColor: config.accentColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMiniInfoTile(
                  label: 'Updated',
                  value: _lastUpdatedLabel(),
                  accentColor: config.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  color: config.accentColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    config.showContactActions
                        ? 'Open profiles, send WhatsApp wishes, or place a quick call from the cards below.'
                        : 'Use the cards below to view the latest notice details in a cleaner layout.',
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.35,
                      color: Color(0xFF706C67),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniInfoTile({
    required String label,
    required String value,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2A2724),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticePage({
    required List<dynamic> items,
    required _NoticeTabConfig config,
  }) {
    if (_isLoading) {
      return _buildLoadingState(config);
    }

    if (_hasLoadError && items.isEmpty) {
      return RefreshIndicator(
        color: config.accentColor,
        onRefresh: _loadAnnouncements,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: [_buildErrorState(config)],
        ),
      );
    }

    if (items.isEmpty) {
      return RefreshIndicator(
        color: config.accentColor,
        onRefresh: _loadAnnouncements,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: [_buildEmptyState(config)],
        ),
      );
    }

    return RefreshIndicator(
      color: config.accentColor,
      onRefresh: _loadAnnouncements,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          return _buildNoticeCard(item: items[index], config: config);
        },
      ),
    );
  }

  Widget _buildLoadingState(_NoticeTabConfig config) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      children: [
        FancyLoader(
          label: 'Loading ${config.title.toLowerCase()}',
          subtitle: 'Checking the latest updates from the notice board.',
          icon: config.icon,
          accentColor: config.accentColor,
          backgroundTint: config.accentColor.withOpacity(0.10),
        ),
        const SizedBox(height: 18),
        for (int index = 0; index < 3; index++) ...[
          _buildLoadingCard(config.accentColor),
          if (index < 2) const SizedBox(height: 14),
        ],
      ],
    );
  }

  Widget _buildLoadingCard(Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 180,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (int index = 0; index < 3; index++)
                Container(
                  width: 92,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(_NoticeTabConfig config) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: config.accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.wifi_off_rounded,
              color: config.accentColor,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Unable to load notices',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C2925),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color: Color(0xFF77716C),
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: _loadAnnouncements,
            style: ElevatedButton.styleFrom(
              backgroundColor: config.accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(_NoticeTabConfig config) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: config.accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(config.icon, color: config.accentColor, size: 30),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nothing here yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C2925),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            config.emptyMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color: Color(0xFF77716C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeCard({
    required dynamic item,
    required _NoticeTabConfig config,
  }) {
    final Map<String, dynamic> data =
        item is Map
            ? Map<String, dynamic>.from(item as Map)
            : <String, dynamic>{};

    final String title = (data['title'] ?? '').toString().trim();
    final String mobileNo = (data['mobile_no'] ?? '').toString().trim();
    final String type = (data['type'] ?? '').toString().trim();
    final String userId = (data['user_id'] ?? '').toString().trim();
    final String cardTitle = title.isEmpty ? 'Notice member' : title;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 6,
            decoration: BoxDecoration(
              color: config.accentColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(26),
                bottomLeft: Radius.circular(26),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: config.accentColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          config.icon,
                          color: config.accentColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (type.isNotEmpty) ...[
                              _buildTypeBadge(
                                type: type,
                                accentColor: config.accentColor,
                              ),
                              const SizedBox(height: 10),
                            ],
                            Text(
                              cardTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2A2724),
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              config.showContactActions
                                  ? 'Use the quick actions below or open the member profile for more details.'
                                  : 'Open the profile to read the complete notice details.',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF7A746E),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (userId.isNotEmpty)
                        _buildActionChip(
                          icon: Icons.person_outline_rounded,
                          label: 'Profile',
                          color: config.accentColor,
                          onTap: () {
                            _openProfile(userId);
                          },
                        ),
                      if (config.showContactActions && mobileNo.isNotEmpty)
                        _buildActionChip(
                          icon: FontAwesomeIcons.whatsapp,
                          label: 'WhatsApp',
                          color: const Color(0xFF25D366),
                          onTap: () {
                            _launchWhatsApp(mobileNo);
                          },
                        ),
                      if (config.showContactActions && mobileNo.isNotEmpty)
                        _buildActionChip(
                          icon: FontAwesomeIcons.phone,
                          label: 'Call',
                          color: const Color(0xFF246BFD),
                          onTap: () {
                            _callMember(mobileNo);
                          },
                        ),
                      if (userId.isEmpty)
                        _buildInfoChip(
                          icon: Icons.info_outline_rounded,
                          label: 'Profile unavailable',
                          accentColor: config.accentColor,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accentColor, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge({required String type, required Color accentColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: accentColor,
        ),
      ),
    );
  }
}

class _NoticeTabConfig {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final String emptyMessage;
  final bool showContactActions;

  const _NoticeTabConfig({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.emptyMessage,
    required this.showContactActions,
  });
}
