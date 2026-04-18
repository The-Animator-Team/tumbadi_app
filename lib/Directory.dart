import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tumbadi_app/AddMembers.dart';
import 'package:tumbadi_app/widget/FancyLoader.dart';

import 'Config.dart';
import 'Profile.dart';

class Directory extends StatefulWidget {
  const Directory({super.key});

  @override
  State<Directory> createState() => _DirectoryState();
}

class _DirectoryState extends State<Directory> {
  static const Color _brandColor = Color.fromARGB(255, 173, 18, 7);
  static const Color _pageBackground = Color(0xFFFDE7EA);
  static const Color _surfaceColor = Color(0xFFFFFBF8);
  static const Color _textPrimary = Color(0xFF261F1B);
  static const Color _textSecondary = Color(0xFF7B6D66);

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _middleName = TextEditingController();
  final TextEditingController _surName = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  bool _advancedSearch = false;
  String _searchValue = '';

  @override
  void dispose() {
    _firstName.dispose();
    _middleName.dispose();
    _surName.dispose();
    _mobileNumber.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> _members() async {
    List<dynamic> familyData = [];

    if (_advancedSearch) {
      final http.Response res = await http.post(
        Uri.parse(Config.find_members),
        body: {
          "first_name": _firstName.text.trim(),
          "middle_name": _middleName.text.trim(),
          "sur_name": _surName.text.trim(),
          "mobile_no": _mobileNumber.text.trim(),
        },
      );
      final dynamic data = json.decode(res.body);
      familyData = List<dynamic>.from(data['data'] ?? const []);
      _advancedSearch = false;
    } else {
      final http.Response res = await http.get(Uri.parse(Config.all_members));
      final dynamic data = json.decode(res.body);
      familyData = List<dynamic>.from(data['data'] ?? const []);
    }

    GetStorage().write("isdir", "true");

    if (_searchValue.isNotEmpty) {
      familyData =
          familyData
              .where(
                (element) => element.toString().toLowerCase().contains(
                  _searchValue.toLowerCase(),
                ),
              )
              .toList();
    }

    return familyData;
  }

  void _applyAdvancedSearch() {
    setState(() {
      _advancedSearch = true;
    });
  }

  void _filterSearchResults(String query) {
    setState(() {
      _searchValue = query.trim();
    });
  }

  String _value(dynamic value) {
    if (value == null) {
      return '';
    }

    final String text = value.toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') {
      return '';
    }

    return text;
  }

  String _fullName(Map<String, dynamic> member) {
    return [
      _value(member['first_name']),
      _value(member['middle_name']),
      _value(member['sur_name']),
    ].where((part) => part.isNotEmpty).join(' ');
  }

  String _profileImageUrl(Map<String, dynamic> member) {
    final dynamic user = member['user'];
    if (user is Map) {
      final String photoPath = _value(user['profile_photo_path']);
      if (photoPath.isNotEmpty) {
        return photoPath;
      }

      final String photoUrl = _value(user['profile_photo_url']);
      if (photoUrl.isNotEmpty) {
        return photoUrl;
      }
    }

    return Config.noimage;
  }

  Future<void> _openAdvancedSearch() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            "Search Member",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _textPrimary,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSearchField(
                  controller: _firstName,
                  label: 'First Name',
                  hintText: 'Enter first name',
                ),
                const SizedBox(height: 12),
                _buildSearchField(
                  controller: _middleName,
                  label: 'Middle Name',
                  hintText: 'Enter middle name',
                ),
                const SizedBox(height: 12),
                _buildSearchField(
                  controller: _surName,
                  label: 'Surname',
                  hintText: 'Enter surname',
                ),
                const SizedBox(height: 12),
                _buildSearchField(
                  controller: _mobileNumber,
                  label: 'Mobile Number',
                  hintText: 'Enter mobile number',
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: _textSecondary),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                _applyAdvancedSearch();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _brandColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        title: const Text("Directory"),
        backgroundColor: _pageBackground,
        foregroundColor: _textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: _openAdvancedSearch,
              icon: const Icon(Icons.tune_rounded),
              tooltip: 'Advanced Search',
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _brandColor,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Addmembers()),
          );
        },
        child: const Icon(FontAwesomeIcons.plus, size: 18),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
              child: Column(
                children: [
                  _buildHeroCard(),
                  const SizedBox(height: 12),
                  _buildSearchBar(),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _members(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: FancyLoader(
                        label: 'Loading directory',
                        subtitle: 'Fetching members and family details.',
                        icon: Icons.groups_rounded,
                      ),
                    );
                  }

                  final List<dynamic> members = snapshot.data ?? const [];

                  if (members.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(14, 6, 14, 24),
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 22,
                          ),
                          decoration: BoxDecoration(
                            color: _surfaceColor,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                color: _brandColor,
                                size: 34,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'No members found',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: _textPrimary,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Try a different search or clear the filters to see more members.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.45,
                                  color: _textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 2, 14, 24),
                    itemCount: members.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> member =
                          Map<String, dynamic>.from(members[index] as Map);
                      return _buildMemberCard(member);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _brandColor.withOpacity(0.96),
            const Color(0xFFC64339),
            const Color(0xFFE9997F),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 26,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Community Directory',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Browse members, family listings, and contact details in a cleaner, easier-to-scan layout.',
            style: TextStyle(fontSize: 13.4, height: 1.45, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterSearchResults,
        decoration: InputDecoration(
          hintText: 'Search members by name, number, or details',
          hintStyle: TextStyle(color: _textSecondary.withOpacity(0.72)),
          prefixIcon: const Icon(Icons.search_rounded, color: _brandColor),
          suffixIcon:
              _searchValue.isEmpty
                  ? null
                  : IconButton(
                    onPressed: () {
                      _searchController.clear();
                      _filterSearchResults('');
                    },
                    icon: const Icon(Icons.close_rounded),
                    color: _textSecondary,
                  ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String label,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _brandColor.withOpacity(0.10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _brandColor.withOpacity(0.10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: _brandColor, width: 1.2),
        ),
      ),
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> member) {
    final String name = _fullName(member);
    final String phone = _value(member['contact_no_1']);
    final String email = _value(member['email_id']);
    final String gender = _value(member['gender']);
    final String education = _value(member['education']);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Profile(user_id: member['id'].toString()),
            ),
          );
        },
        child: Ink(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          decoration: BoxDecoration(
            color: _surfaceColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 68,
                height: 68,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _brandColor.withOpacity(0.92),
                      const Color(0xFFE38A71),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(19),
                  child: Image.network(
                    _profileImageUrl(member),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: Text(
                          name.isEmpty ? 'M' : name[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: _brandColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            name.isEmpty ? 'Member' : name,
                            style: const TextStyle(
                              fontSize: 16.2,
                              fontWeight: FontWeight.w800,
                              color: _textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _brandColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'View',
                            style: TextStyle(
                              fontSize: 11.8,
                              fontWeight: FontWeight.w700,
                              color: _brandColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (phone.isNotEmpty)
                      _buildDetailLine(Icons.call_rounded, phone),
                    if (email.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: _buildDetailLine(
                          Icons.mail_outline_rounded,
                          email,
                        ),
                      ),
                    if (gender.isNotEmpty || education.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (gender.isNotEmpty) _buildInfoChip(gender),
                          if (education.isNotEmpty)
                            _buildInfoChip(
                              education,
                              icon: Icons.school_rounded,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailLine(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _brandColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13.2,
              height: 1.35,
              color: _textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(String label, {IconData icon = Icons.person_rounded}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _brandColor.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _brandColor),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.3,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
