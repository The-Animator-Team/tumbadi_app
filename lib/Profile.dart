import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tumbadi_app/ChangeProfileImage.dart';
import 'package:tumbadi_app/Config.dart';
import 'package:tumbadi_app/UpdateProfile.dart';
import 'package:tumbadi_app/widget/FancyLoader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import 'Directory.dart';

class Profile extends StatefulWidget {
  final String user_id;

  const Profile({super.key, required this.user_id});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static const Color _brandColor = Color.fromARGB(255, 173, 18, 7);
  static const Color _pageBackground = Color(0xFFFDE7EA);
  static const Color _surfaceColor = Color(0xFFFFFBF8);
  static const Color _textPrimary = Color(0xFF261F1B);
  static const Color _textSecondary = Color(0xFF7B6D66);

  final DateFormat _formatter = DateFormat('dd-MM-yyyy');

  Map<String, dynamic> _userData = {};
  List<dynamic> _myRelation = [];
  bool _isLoading = true;
  String _loadError = '';

  dynamic get _loginUser => GetStorage().read("user_data");

  bool get _isOwnProfile {
    final dynamic currentUser = _loginUser;
    if (currentUser is! Map) {
      return false;
    }

    return _value(currentUser['user_id']).isNotEmpty &&
        _value(currentUser['user_id']) == _value(_userData['user_id']);
  }

  List<dynamic> get _familyMembers {
    return _myRelation
        .where(
          (member) => _value(member['id']) != widget.user_id.toString().trim(),
        )
        .toList();
  }

  String get _fullName {
    final List<String> parts =
        [
          _value(_userData['first_name']),
          _value(_userData['middle_name']),
          _value(_userData['sur_name']),
        ].where((part) => part.isNotEmpty).toList();

    return parts.isEmpty ? 'Member Profile' : parts.join(' ');
  }

  String get _profileImageUrl {
    final dynamic user = _userData['user'];
    if (user is Map) {
      final String profilePhoto = _value(user['profile_photo_url']);
      if (profilePhoto.isNotEmpty) {
        return profilePhoto;
      }
    }

    final String imageUrl = _value(_userData['img_url']);
    if (imageUrl.isNotEmpty) {
      return imageUrl;
    }

    return Config.noimage;
  }

  String get _statusLabel =>
      _value(_userData['status']) == '1' ? 'Active' : 'Inactive';

  Color get _statusColor =>
      _value(_userData['status']) == '1'
          ? const Color(0xFF2E8B57)
          : const Color(0xFFB1682F);

  @override
  void initState() {
    super.initState();
    userProfile();
  }

  Future<void> userProfile({bool showLoader = true}) async {
    if (showLoader && mounted) {
      setState(() {
        _isLoading = true;
        _loadError = '';
      });
    }

    try {
      final http.Response res = await http.get(
        Uri.parse('${Config.profile}/${widget.user_id}'),
      );
      final dynamic memberData = json.decode(res.body);
      final Map<String, dynamic> data =
          memberData is Map<String, dynamic>
              ? (memberData['data'] as Map<String, dynamic>? ??
                  <String, dynamic>{})
              : <String, dynamic>{};

      if (!mounted) {
        return;
      }

      setState(() {
        _userData =
            data['member'] is Map<String, dynamic>
                ? Map<String, dynamic>.from(data['member'])
                : <String, dynamic>{};
        _myRelation = List<dynamic>.from(data['my_relation'] ?? const []);
        _isLoading = false;
        _loadError = '';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _loadError = 'Unable to load profile right now.';
      });

      if (_userData.isNotEmpty) {
        _showMessage(_loadError);
      }
    }
  }

  Future<void> _launchExternalUri(
    Uri uri, {
    required String errorMessage,
  }) async {
    final bool didLaunch = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!didLaunch && mounted) {
      _showMessage(errorMessage);
    }
  }

  Future<void> _openWhatsApp() async {
    final String mobile = _value(_userData['contact_no_1']);
    if (mobile.isEmpty) {
      _showMessage('Phone number is not available for this member.');
      return;
    }

    final link = WhatsAppUnilink(
      phoneNumber: '91$mobile',
      text: 'Birthday Wishes ',
    );

    await _launchExternalUri(
      Uri.parse('$link'),
      errorMessage: 'Unable to open WhatsApp right now.',
    );
  }

  Future<void> _openEmail() async {
    final String email = _value(_userData['email_id']);
    if (email.isEmpty) {
      _showMessage('Email address is not available for this member.');
      return;
    }

    await _launchExternalUri(
      Uri(scheme: 'mailto', path: email),
      errorMessage: 'Unable to open the email app right now.',
    );
  }

  Future<void> _callMember() async {
    final String mobile = _value(_userData['contact_no_1']);
    if (mobile.isEmpty) {
      _showMessage('Phone number is not available for this member.');
      return;
    }

    await _launchExternalUri(
      Uri(scheme: 'tel', path: mobile),
      errorMessage: 'Unable to start the call right now.',
    );
  }

  Future<void> _openUpdateProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProfile(userdata: _userData),
      ),
    );
    await userProfile(showLoader: false);
  }

  Future<void> _openChangeProfileImage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ChangeProfileImage(
              user_id: _value(_userData['user_id']),
              imagePath: _value(_userData['img_url']),
            ),
      ),
    );
    await userProfile(showLoader: false);
  }

  Future<void> _openDirectory() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Directory()),
    );
    await userProfile(showLoader: false);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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

  String _formattedBirthDate() {
    final String rawValue = _value(_userData['birth_date']);
    if (rawValue.isEmpty) {
      return '--';
    }

    try {
      return _formatter.format(DateTime.parse(rawValue));
    } catch (_) {
      return rawValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: _pageBackground,
        foregroundColor: _textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (_loginUser is Map)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (value) {
                switch (value) {
                  case 'add_family':
                    _openDirectory();
                    break;
                  case 'change_photo':
                    _openChangeProfileImage();
                    break;
                  case 'edit_profile':
                    _openUpdateProfile();
                    break;
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'add_family',
                    child: Text('Add Family'),
                  ),
                  if (_isOwnProfile)
                    const PopupMenuItem<String>(
                      value: 'change_photo',
                      child: Text('Change Photo'),
                    ),
                  if (_isOwnProfile)
                    const PopupMenuItem<String>(
                      value: 'edit_profile',
                      child: Text('Update Profile'),
                    ),
                ];
              },
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _userData.isEmpty) {
      return const Center(
        child: FancyLoader(
          label: 'Loading profile',
          subtitle: 'Bringing member details into view.',
          icon: Icons.person_rounded,
        ),
      );
    }

    if (_loadError.isNotEmpty && _userData.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x15000000),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: _brandColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.wifi_off_rounded,
                    color: _brandColor,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Unable to load profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _loadError,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: _textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    userProfile();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brandColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: _brandColor,
      onRefresh: () => userProfile(showLoader: false),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 16),
          _buildInfoSection(
            title: 'Personal Details',
            subtitle: 'A clearer view of the member profile information.',
            icon: Icons.badge_rounded,
            items: [
              _ProfileField(label: 'Full Name', value: _fullName),
              _ProfileField(
                label: 'Gender',
                value: _value(_userData['gender']),
              ),
              _ProfileField(
                label: 'Date of Birth',
                value: _formattedBirthDate(),
              ),
              _ProfileField(
                label: 'Marital Status',
                value: _value(_userData['marital_status']),
              ),
              _ProfileField(
                label: 'Blood Group',
                value: _value(_userData['blood_group']),
              ),
              _ProfileField(
                label: 'Education',
                value: _value(_userData['education']),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoSection(
            title: 'Contact Details',
            subtitle:
                'Quick contact information for calls, messages, and email.',
            icon: Icons.contact_phone_rounded,
            items: [
              _ProfileField(
                label: 'Mobile Number',
                value: _value(_userData['contact_no_1']),
              ),
              _ProfileField(
                label: 'Email Address',
                value: _value(_userData['email_id']),
              ),
              _ProfileField(label: 'Status', value: _statusLabel),
            ],
          ),
          const SizedBox(height: 16),
          _buildFamilySection(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    final String phone = _value(_userData['contact_no_1']);
    final String email = _value(_userData['email_id']);
    final String gender = _value(_userData['gender']);
    final String maritalStatus = _value(_userData['marital_status']);

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
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
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 26,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: 122,
                height: 122,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.22),
                ),
                child: ClipOval(
                  child: Image.network(
                    _profileImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: Text(
                          _fullName.isEmpty ? 'P' : _fullName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: _brandColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (_isOwnProfile)
                Positioned(
                  right: -6,
                  bottom: 2,
                  child: Material(
                    color: Colors.white,
                    elevation: 6,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        _openChangeProfileImage();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 18,
                          color: _brandColor,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          if (phone.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              phone,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.88),
              ),
            ),
          ],
          if (email.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              email,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.8,
                height: 1.4,
                color: Colors.white.withOpacity(0.86),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildMetaChip(
                label: _statusLabel,
                icon: Icons.verified_rounded,
                backgroundColor: _statusColor.withOpacity(0.20),
              ),
              if (gender.isNotEmpty)
                _buildMetaChip(
                  label: gender,
                  icon: Icons.person_outline_rounded,
                  backgroundColor: Colors.white.withOpacity(0.14),
                ),
              if (maritalStatus.isNotEmpty)
                _buildMetaChip(
                  label: maritalStatus,
                  icon: Icons.favorite_border_rounded,
                  backgroundColor: Colors.white.withOpacity(0.14),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              if (phone.isNotEmpty)
                _buildHeaderAction(
                  label: 'WhatsApp',
                  icon: Icons.chat_bubble_rounded,
                  onTap: () {
                    _openWhatsApp();
                  },
                ),
              if (phone.isNotEmpty)
                _buildHeaderAction(
                  label: 'Call',
                  icon: Icons.call_rounded,
                  onTap: () {
                    _callMember();
                  },
                ),
              if (email.isNotEmpty)
                _buildHeaderAction(
                  label: 'Email',
                  icon: Icons.mail_outline_rounded,
                  onTap: () {
                    _openEmail();
                  },
                ),
              if (_isOwnProfile)
                _buildHeaderAction(
                  label: 'Edit Profile',
                  icon: Icons.edit_rounded,
                  onTap: () {
                    _openUpdateProfile();
                  },
                  filled: true,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaChip({
    required String label,
    required IconData icon,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderAction({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: filled ? Colors.white : Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 17, color: filled ? _brandColor : Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: filled ? _brandColor : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<_ProfileField> items,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _brandColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: _brandColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12.6,
                        height: 1.4,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (int index = 0; index < items.length; index++) ...[
            _buildInfoRow(items[index]),
            if (index < items.length - 1)
              const Divider(
                height: 18,
                thickness: 0.8,
                color: Color(0xFFE9DFD8),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(_ProfileField item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            item.label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: _textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 6,
          child: Text(
            item.value.isEmpty ? '--' : item.value,
            style: const TextStyle(
              fontSize: 14.6,
              height: 1.45,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFamilySection() {
    final List<dynamic> familyMembers = _familyMembers;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _brandColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.family_restroom_rounded,
                  color: _brandColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Family Members',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      familyMembers.isEmpty
                          ? 'No linked family members are visible yet.'
                          : '${familyMembers.length} linked member${familyMembers.length == 1 ? '' : 's'}',
                      style: const TextStyle(
                        fontSize: 12.6,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isOwnProfile)
                TextButton.icon(
                  onPressed: () {
                    _openDirectory();
                  },
                  icon: const Icon(Icons.group_add_rounded, size: 18),
                  label: const Text('Add'),
                  style: TextButton.styleFrom(
                    foregroundColor: _brandColor,
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (familyMembers.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _brandColor.withOpacity(0.08)),
              ),
              child: const Text(
                'No family members have been linked to this profile yet.',
                style: TextStyle(
                  fontSize: 13.2,
                  height: 1.45,
                  color: _textSecondary,
                ),
              ),
            )
          else
            Column(
              children: [
                for (int index = 0; index < familyMembers.length; index++) ...[
                  _buildFamilyMemberCard(familyMembers[index]),
                  if (index < familyMembers.length - 1)
                    const SizedBox(height: 10),
                ],
              ],
            ),
          if (_isOwnProfile) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _openUpdateProfile();
                },
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Update Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _brandColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFamilyMemberCard(dynamic member) {
    final String firstName = _value(member['first_name']);
    final String surName = _value(member['sur_name']);
    final String fullName = [
      firstName,
      surName,
    ].where((value) => value.isNotEmpty).join(' ');
    final String initial = fullName.isEmpty ? 'M' : fullName[0].toUpperCase();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Profile(user_id: _value(member['id'])),
            ),
          );
        },
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: _brandColor.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _brandColor.withOpacity(0.92),
                      const Color(0xFFE38A71),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName.isEmpty ? 'Family Member' : fullName,
                      style: const TextStyle(
                        fontSize: 15.2,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'View linked profile details',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: _textSecondary.withOpacity(0.95),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: _textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileField {
  final String label;
  final String value;

  const _ProfileField({required this.label, required this.value});
}
