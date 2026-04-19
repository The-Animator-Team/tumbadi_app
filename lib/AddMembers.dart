import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tumbadi_app/Config.dart';

class Addmembers extends StatefulWidget {
  const Addmembers({super.key});

  @override
  State<Addmembers> createState() => _AddmembersState();
}

class _AddmembersState extends State<Addmembers> {
  static const Color _brandColor = Color.fromARGB(255, 173, 18, 7);
  static const Color _pageBackground = Color(0xFFFDE7EA);
  static const Color _surfaceColor = Color(0xFFFFFBF8);
  static const Color _textPrimary = Color(0xFF261F1B);
  static const Color _textSecondary = Color(0xFF7B6D66);

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DateFormat _apiDateFormat = DateFormat('yyyy-M-dd');
  final DateFormat _displayDateFormat = DateFormat('dd MMM yyyy');

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _middleName = TextEditingController();
  final TextEditingController _grandFatherName = TextEditingController();
  final TextEditingController _surName = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _pincode = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _village = TextEditingController();
  final TextEditingController _emailid = TextEditingController();
  final TextEditingController _mobileno = TextEditingController();
  final TextEditingController _officeMobieno = TextEditingController();
  final TextEditingController _birthDate = TextEditingController();
  final TextEditingController _marrigeDate = TextEditingController();
  final TextEditingController _education = TextEditingController();
  final TextEditingController _occupation = TextEditingController();
  final TextEditingController _lifeInsu = TextEditingController();
  final TextEditingController _sports = TextEditingController();

  String? _gender;
  String? _bloodGroup;
  String? _maritalStatus;
  DateTime? _selectedBirthDate;
  DateTime? _selectedMarriageDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _firstName.dispose();
    _middleName.dispose();
    _grandFatherName.dispose();
    _surName.dispose();
    _address.dispose();
    _location.dispose();
    _pincode.dispose();
    _city.dispose();
    _state.dispose();
    _village.dispose();
    _emailid.dispose();
    _mobileno.dispose();
    _officeMobieno.dispose();
    _birthDate.dispose();
    _marrigeDate.dispose();
    _education.dispose();
    _occupation.dispose();
    _lifeInsu.dispose();
    _sports.dispose();
    super.dispose();
  }

  Future<void> addmember() async {
    if (_isSubmitting) {
      return;
    }

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final dynamic loginuser = GetStorage().read("user_data");
    if (loginuser == null || loginuser['user_id'] == null) {
      _showToast('Unable to load user information.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final String userId = loginuser['user_id'].toString();
      final http.Response res = await http.post(
        Uri.parse(Config.add_member),
        body: {
          'first_name': _firstName.text.trim(),
          'middle_name': _middleName.text.trim(),
          'grand_father_name': _grandFatherName.text.trim(),
          'last_name': _surName.text.trim(),
          'address': _address.text.trim(),
          'location': _location.text.trim(),
          'pincode': _pincode.text.trim(),
          'city': _city.text.trim(),
          'state': _state.text.trim(),
          'village': _village.text.trim(),
          'email_id': _emailid.text.trim(),
          'contact_no_1': _mobileno.text.trim(),
          'contact_no_2': _officeMobieno.text.trim(),
          'gender': _gender ?? '',
          'blood_group': _bloodGroup ?? '',
          'birth_date':
              _selectedBirthDate != null
                  ? _apiDateFormat.format(_selectedBirthDate!)
                  : _birthDate.text.trim(),
          'marital_status': _maritalStatus ?? '',
          'marriage_date':
              _selectedMarriageDate != null
                  ? _apiDateFormat.format(_selectedMarriageDate!)
                  : _marrigeDate.text.trim(),
          'education': _education.text.trim(),
          'occupation': _occupation.text.trim(),
          'life_insure': _lifeInsu.text.trim(),
          'sports': _sports.text.trim(),
          'user_id': userId,
        },
      );

      final dynamic resdata = json.decode(res.body);

      if (!mounted) {
        return;
      }

      if (resdata is Map<String, dynamic> && resdata['status'] == 'TRUE') {
        _showToast(
          _readMessage(resdata['msg'], fallback: 'Member added successfully.'),
        );
        Navigator.pop(context, true);
        return;
      }

      _showToast(
        _readMessage(
          resdata is Map<String, dynamic> ? resdata['msg'] : null,
          fallback: 'Something went wrong.',
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showToast('Unable to save member right now.');
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _pickBirthDate() async {
    final DateTime now = DateTime.now();
    final int safeDay = now.day > 28 ? 28 : now.day;
    final DateTime initialDate =
        _selectedBirthDate ?? DateTime(now.year - 25, now.month, safeDay);

    final DateTime? pickedDate = await _showStyledDatePicker(
      initialDate: initialDate,
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedBirthDate = pickedDate;
      _birthDate.text = _displayDateFormat.format(pickedDate);
    });
  }

  Future<void> _pickMarriageDate() async {
    final DateTime pickedBase =
        _selectedMarriageDate ?? _selectedBirthDate ?? DateTime.now();
    final DateTime? pickedDate = await _showStyledDatePicker(
      initialDate: pickedBase,
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedMarriageDate = pickedDate;
      _marrigeDate.text = _displayDateFormat.format(pickedDate);
    });
  }

  Future<DateTime?> _showStyledDatePicker({
    required DateTime initialDate,
  }) async {
    return showDatePicker(
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
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
    );
  }

  String _readMessage(dynamic value, {required String fallback}) {
    final String text = value?.toString().trim() ?? '';
    if (text.isEmpty || text.toLowerCase() == 'null') {
      return fallback;
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        title: const Text('Add Member'),
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
                subtitle:
                    'Start with the member name and the main personal details.',
                icon: Icons.badge_rounded,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _firstName,
                      label: 'First Name',
                      hintText: 'Enter first name',
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'Enter first name.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _middleName,
                      label: 'Middle Name',
                      hintText: 'Enter middle name',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _grandFatherName,
                      label: 'Grandfather Name',
                      hintText: 'Enter grandfather name',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _surName,
                      label: 'Surname',
                      hintText: 'Enter surname',
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
                    ),
                    const SizedBox(height: 14),
                    _buildDateField(
                      controller: _birthDate,
                      label: 'Date of Birth',
                      hintText: 'Select date of birth',
                      onTap: _pickBirthDate,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Address Details',
                subtitle:
                    'Add location details so the member record stays complete.',
                icon: Icons.home_rounded,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _address,
                      label: 'Address',
                      hintText: 'Enter address',
                      textInputAction: TextInputAction.next,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _location,
                      label: 'Location',
                      hintText: 'Enter location',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _pincode,
                      label: 'Pincode',
                      hintText: 'Enter pincode',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.none,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _city,
                      label: 'City',
                      hintText: 'Enter city',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _state,
                      label: 'State',
                      hintText: 'Enter state',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _village,
                      label: 'Village',
                      hintText: 'Enter village',
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Contact Details',
                subtitle:
                    'Use working contact details so other members can connect.',
                icon: Icons.contact_phone_rounded,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _emailid,
                      label: 'Email Address',
                      hintText: 'Enter email address',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        final String text = (value ?? '').trim();
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
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _mobileno,
                      label: 'Contact Number',
                      hintText: 'Enter contact number',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.none,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _officeMobieno,
                      label: 'Office Contact',
                      hintText: 'Enter office contact',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.none,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Additional Details',
                subtitle:
                    'Finish the profile with personal and professional details.',
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
                    _buildDateField(
                      controller: _marrigeDate,
                      label: 'Marriage Date',
                      hintText: 'Select marriage date',
                      onTap: _pickMarriageDate,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _education,
                      label: 'Education',
                      hintText: 'Enter education details',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _occupation,
                      label: 'Occupation',
                      hintText: 'Enter occupation',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _lifeInsu,
                      label: 'Life Insurance',
                      hintText: 'Enter insurance details',
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    _buildTextField(
                      controller: _sports,
                      label: 'Sports',
                      hintText: 'Enter sports or interests',
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _isSubmitting ? null : addmember,
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
                          'Save Member',
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
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _brandColor.withOpacity(0.96),
            const Color(0xFFC64339),
            const Color(0xFFD85A4C),
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
              'New Member Entry',
              style: TextStyle(
                fontSize: 11.8,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Add Member',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.96),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Fill in the member details below using the same clean layout as the other updated forms.',
              style: TextStyle(
                fontSize: 13.4,
                height: 1.45,
                color: _brandColor,
                fontWeight: FontWeight.w600,
              ),
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
    TextCapitalization textCapitalization = TextCapitalization.words,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
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
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      dropdownColor: Colors.white,
      style: const TextStyle(
        fontSize: 14.8,
        fontWeight: FontWeight.w600,
        color: _textPrimary,
      ),
      decoration: _inputDecoration(
        label: label,
        hintText: 'Select ${label.toLowerCase()}',
      ),
      items:
          items
              .map(
                (item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)),
              )
              .toList(),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: _textPrimary,
      ),
      decoration: _inputDecoration(
        label: label,
        hintText: hintText,
        suffixIcon: IconButton(
          onPressed: onTap,
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
