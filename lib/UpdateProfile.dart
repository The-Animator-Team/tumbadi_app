import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'Config.dart';

class UpdateProfile extends StatefulWidget {
  final Map<String, dynamic> userdata;

  const UpdateProfile({required this.userdata, super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  static const Color _brandColor = Color.fromARGB(255, 173, 18, 7);
  static const Color _pageBackground = Color(0xFFFDE7EA);
  static const Color _surfaceColor = Color(0xFFFFFBF8);
  static const Color _textPrimary = Color(0xFF261F1B);
  static const Color _textSecondary = Color(0xFF7B6D66);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DateFormat _apiDateFormat = DateFormat('yyyy-M-dd');
  final DateFormat _displayDateFormat = DateFormat('dd MMM yyyy');

  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _middlename = TextEditingController();
  final TextEditingController _surname = TextEditingController();
  final TextEditingController _grandfather = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _education = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _email = TextEditingController();

  String? _gender;
  String? _bloodGroup;
  String? _maritalStatus;
  DateTime? _selectedBirthDate;
  bool _isSubmitting = false;

  static const List<String> _genders = ['Male', 'Female'];
  static const List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];
  static const List<String> _maritalStatuses = [
    'Single',
    'Engaged',
    'Married',
    'Widow',
    'Divorced',
    'Diksha',
  ];

  @override
  void initState() {
    super.initState();
    _fillInitialValues();
  }

  @override
  void dispose() {
    _firstname.dispose();
    _middlename.dispose();
    _surname.dispose();
    _grandfather.dispose();
    _dob.dispose();
    _education.dispose();
    _contact.dispose();
    _email.dispose();
    super.dispose();
  }

  void _fillInitialValues() {
    _firstname.text = _readValue(widget.userdata['first_name']);
    _middlename.text = _readValue(widget.userdata['middle_name']);
    _surname.text = _readValue(widget.userdata['sur_name']);
    _grandfather.text = _readValue(widget.userdata['grand_father_name']);
    _education.text = _readValue(widget.userdata['education']);
    _contact.text = _readValue(widget.userdata['contact_no_1']);
    _email.text = _readValue(widget.userdata['email_id']);

    _gender = _normalizeOption(_readValue(widget.userdata['gender']), _genders);
    _bloodGroup = _normalizeOption(
      _readValue(widget.userdata['blood_group']),
      _bloodGroups,
    );
    _maritalStatus = _normalizeOption(
      _readValue(widget.userdata['marital_status']),
      _maritalStatuses,
    );

    final String rawBirthDate = _readValue(widget.userdata['birth_date']);
    if (rawBirthDate.isNotEmpty) {
      try {
        _selectedBirthDate = DateTime.parse(rawBirthDate);
        _dob.text = _displayDateFormat.format(_selectedBirthDate!);
      } catch (_) {
        _dob.text = rawBirthDate;
      }
    }
  }

  String _readValue(dynamic value) {
    if (value == null) {
      return '';
    }

    final String text = value.toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') {
      return '';
    }

    return text;
  }

  String? _normalizeOption(String value, List<String> options) {
    if (value.isEmpty) {
      return null;
    }

    for (final String option in options) {
      if (option.toLowerCase() == value.toLowerCase()) {
        return option;
      }
    }
    return null;
  }

  Future<void> _pickBirthDate() async {
    final DateTime now = DateTime.now();
    final int safeDay = now.day > 28 ? 28 : now.day;
    final DateTime initialDate =
        _selectedBirthDate ?? DateTime(now.year - 25, now.month, safeDay);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1930),
      lastDate: DateTime(2099),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _brandColor,
              onPrimary: Colors.white,
              onSurface: _textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedBirthDate = pickedDate;
      _dob.text = _displayDateFormat.format(pickedDate);
    });
  }

  Future<void> _updateProfile() async {
    if (_isSubmitting) {
      return;
    }

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final http.Response res = await http.post(
        Uri.parse(Config.update_profile),
        body: {
          'first_name': _firstname.text.trim(),
          'middle_name': _middlename.text.trim(),
          'last_name': _surname.text.trim(),
          'grand_father_name': _grandfather.text.trim(),
          'gender': _gender ?? '',
          'birth_date':
              _selectedBirthDate != null
                  ? _apiDateFormat.format(_selectedBirthDate!)
                  : '',
          'blood_group': _bloodGroup ?? '',
          'marital_status': _maritalStatus ?? '',
          'education': _education.text.trim(),
          'contact_no_1': _contact.text.trim(),
          'email_id': _email.text.trim(),
          'user_id': widget.userdata['user_id'].toString(),
          'member_id': widget.userdata['id'].toString(),
        },
      );

      final dynamic resdata = json.decode(res.body);

      if (!mounted) {
        return;
      }

      if (resdata is Map<String, dynamic> && resdata['status'] == 'TRUE') {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                _readValue(resdata['msg']).isEmpty
                    ? 'Profile updated successfully.'
                    : _readValue(resdata['msg']),
              ),
            ),
          );
        Navigator.pop(context, true);
        return;
      }

      _showMessage('Something went wrong while updating the profile.');
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showMessage('Unable to update profile right now.');
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        title: const Text('Update Profile'),
        backgroundColor: _pageBackground,
        foregroundColor: _textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
            children: [
              _buildIntroCard(),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Basic Details',
                subtitle: 'Keep the core profile information up to date.',
                icon: Icons.badge_rounded,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _firstname,
                      label: 'First Name',
                      hintText: 'Enter first name',
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (_readValue(value).isEmpty) {
                          return 'Enter first name.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _middlename,
                      label: 'Middle Name',
                      hintText: 'Enter middle name',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _surname,
                      label: 'Surname',
                      hintText: 'Enter surname',
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (_readValue(value).isEmpty) {
                          return 'Enter surname.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _grandfather,
                      label: 'Grandfather Name',
                      hintText: 'Enter grandfather name',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    _buildDropdownField(
                      label: 'Gender',
                      value: _gender,
                      items: _genders,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                      validator: (value) {
                        if (_readValue(value).isEmpty) {
                          return 'Select gender.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildDateField(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Additional Details',
                subtitle:
                    'Personal information that helps complete the profile.',
                icon: Icons.auto_awesome_rounded,
                child: Column(
                  children: [
                    _buildDropdownField(
                      label: 'Blood Group',
                      value: _bloodGroup,
                      items: _bloodGroups,
                      onChanged: (value) {
                        setState(() {
                          _bloodGroup = value;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildDropdownField(
                      label: 'Marital Status',
                      value: _maritalStatus,
                      items: _maritalStatuses,
                      onChanged: (value) {
                        setState(() {
                          _maritalStatus = value;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _education,
                      label: 'Education',
                      hintText: 'Enter education details',
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Contact Details',
                subtitle:
                    'Use active contact details so members can reach you.',
                icon: Icons.contact_phone_rounded,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _contact,
                      label: 'Contact Number',
                      hintText: 'Enter contact number',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        final String text = _readValue(value);
                        if (text.isEmpty) {
                          return 'Enter contact number.';
                        }
                        if (text.length < 10) {
                          return 'Enter a valid contact number.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _email,
                      label: 'Email Address',
                      hintText: 'Enter email address',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        final String text = _readValue(value);
                        if (text.isEmpty) {
                          return null;
                        }
                        final bool isValidEmail = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        ).hasMatch(text);
                        if (!isValidEmail) {
                          return 'Enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _brandColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child:
                    _isSubmitting
                        ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    final String fullName = [
      _readValue(widget.userdata['first_name']),
      _readValue(widget.userdata['middle_name']),
      _readValue(widget.userdata['sur_name']),
    ].where((part) => part.isNotEmpty).join(' ');

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Edit Member Profile',
              style: TextStyle(
                fontSize: 11.8,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            fullName.isEmpty ? 'Update Profile' : fullName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Refresh the member details below and save when everything looks right.',
            style: TextStyle(
              fontSize: 13.4,
              height: 1.45,
              color: Colors.white.withOpacity(0.88),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
  }) {
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
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12.7,
                        height: 1.4,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: _textPrimary,
      ),
      decoration: _inputDecoration(label: label, hintText: hintText),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      validator: validator,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      decoration: _inputDecoration(
        label: label,
        hintText: 'Select ${label.toLowerCase()}',
      ),
      items:
          items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14.8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dob,
      readOnly: true,
      onTap: _pickBirthDate,
      validator: (value) {
        if (_readValue(value).isEmpty) {
          return 'Select birth date.';
        }
        return null;
      },
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: _textPrimary,
      ),
      decoration: _inputDecoration(
        label: 'Date of Birth',
        hintText: 'Select birth date',
        suffixIcon: IconButton(
          onPressed: _pickBirthDate,
          icon: const Icon(Icons.calendar_month_rounded),
          color: _brandColor,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        color: _textSecondary,
      ),
      hintStyle: TextStyle(color: _textSecondary.withOpacity(0.72)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: _brandColor.withOpacity(0.12)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: _brandColor.withOpacity(0.10)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        borderSide: BorderSide(color: _brandColor, width: 1.3),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        borderSide: BorderSide(color: Colors.redAccent, width: 1.2),
      ),
    );
  }
}
