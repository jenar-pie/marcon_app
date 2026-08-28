import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TambahDataScreen extends StatefulWidget {
  final String initialCategory; // 'Prospek' or 'Leads'
  final Function(Map<String, dynamic>)? onDataSaved;

  const TambahDataScreen({
    super.key,
    this.initialCategory = 'Prospek',
    this.onDataSaved,
  });

  @override
  State<TambahDataScreen> createState() => _TambahDataScreenState();
}

class _TambahDataScreenState extends State<TambahDataScreen> {
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _potentialValueController =
      TextEditingController();
  final TextEditingController _entryDateController = TextEditingController();

  late String _selectedCategory; // 'Prospek' or 'Leads'
  bool _isCategoryDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    final now = DateTime.now();
    _entryDateController.text =
        '${now.day} ${_getMonthName(now.month)} ${now.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return months[month - 1];
  }

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    _contactNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _potentialValueController.dispose();
    _entryDateController.dispose();
    super.dispose();
  }

  Future<void> _selectEntryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF7A00),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0D2B45),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _entryDateController.text =
            '${picked.day} ${_getMonthName(picked.month)} ${picked.year}';
      });
    }
  }

  void _saveData() {
    final companyText = _companyController.text.trim();
    final roleText = _roleController.text.trim();
    final contactNameText = _contactNameController.text.trim();
    final phoneText = _phoneController.text.trim();
    final potentialText = _potentialValueController.text.trim();
    final dateText = _entryDateController.text.trim().isEmpty
        ? '23 Agu 2026'
        : _entryDateController.text.trim();

    if (companyText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi Nama Perusahaan / Toko / Leads'),
          backgroundColor: Color(0xFF0D2B45),
        ),
      );
      return;
    }

    // Validation: For "Prospek", Potential Value is MANDATORY
    if (_selectedCategory == 'Prospek' && potentialText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Estimasi Nilai Potensial wajib diisi untuk Prospek!'),
          backgroundColor: Color(0xFF0D2B45),
        ),
      );
      return;
    }

    final newData = {
      'company': companyText,
      'pic': roleText.isEmpty ? '-' : roleText,
      'contactName': contactNameText.isEmpty ? '-' : contactNameText,
      'phone': phoneText.isEmpty ? '-' : phoneText,
      'email': _emailController.text.trim().isEmpty
          ? '-'
          : _emailController.text.trim(),
      'address': _addressController.text.trim().isEmpty
          ? '-'
          : _addressController.text.trim(),
      'potential': potentialText.isEmpty ? '-' : potentialText,
      'category': _selectedCategory, // 'Prospek' or 'Leads'
      'status': _selectedCategory == 'Prospek' ? 'Pipeline' : 'Lead Baru',
      'date': dateText, // Waktu masuk yang diinputkan
    };

    if (widget.onDataSaved != null) {
      widget.onDataSaved!(newData);
    }

    Navigator.of(context).pop(newData);
  }

  @override
  Widget build(BuildContext context) {
    final isProspek = _selectedCategory == 'Prospek';

    return Scaffold(
      backgroundColor: const Color(0xFFFF7A00), // Vibrant Orange Header
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── 1. HEADER SECTION (Orange Background) ────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 22,
                          color: Color(0xFF0D2B45),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Lead & Prospek',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                ],
              ),
            ),

            // ── 2. MAIN CONTENT CONTAINER ────────────────────────────────────
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCE2E7), // Light Slate Background
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // SVG decorative background (bottom)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 320,
                            child: IgnorePointer(
                              child: SvgPicture.asset(
                                'lib/asset/listcrm.svg',
                                fit: BoxFit.cover,
                                alignment: Alignment.bottomCenter,
                              ),
                            ),
                          ),

                          // Scrollable Form Content
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(
                              16,
                              20,
                              16,
                              24 + MediaQuery.of(context).padding.bottom,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Title "Tambah Data"
                                Text(
                                  'Tambah Data',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0D2B45),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Field 1: Nama Perusahaan /Toko/leads
                                _buildCustomPillField(
                                  controller: _companyController,
                                  hintText: 'Nama  Perusahaan /Toko/leads',
                                ),
                                const SizedBox(height: 12),

                                // Field 2: Jabatan / PIC
                                _buildCustomPillField(
                                  controller: _roleController,
                                  hintText: 'Jabatan / PIC',
                                ),
                                const SizedBox(height: 12),

                                // Field 3: Nama Kontak
                                _buildCustomPillField(
                                  controller: _contactNameController,
                                  hintText: 'Nama  Kontak',
                                ),
                                const SizedBox(height: 12),

                                // Field 4: Nomor Telepon
                                _buildCustomPillField(
                                  controller: _phoneController,
                                  hintText: 'Nomor Telepon',
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 12),

                                // Field 5: Email
                                _buildCustomPillField(
                                  controller: _emailController,
                                  hintText: 'Email',
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 12),

                                // Field 6: Alamat Lengkap/ambil gmaps/lokasi
                                _buildCustomPillField(
                                  controller: _addressController,
                                  hintText: 'Alamat Lengkap/ambil gmaps/lokasi',
                                ),
                                const SizedBox(height: 12),

                                // Field 7: Waktu Masuk
                                _buildEntryDateField(),
                                const SizedBox(height: 12),

                                // Field 8: Estimasi Nilai potensial
                                _buildPotentialValueField(isProspek: isProspek),
                                const SizedBox(height: 12),

                                // Field 9: Kategori (Dropdown with Prospek & Leads options)
                                _buildCategoryDropdownField(),
                                const SizedBox(height: 24),

                                // Submit Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF7A00),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      elevation: 3,
                                    ),
                                    onPressed: _saveData,
                                    child: Text(
                                      'Simpan Data',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── WAKTU MASUK PILL FIELD ─────────────────────────────────────────────────
  Widget _buildEntryDateField() {
    return GestureDetector(
      onTap: _selectEntryDate,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFECC49E), // Peach / Beige Pill
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE28B38), width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: Color(0xFF0D2B45),
                ),
                const SizedBox(width: 10),
                Text(
                  _entryDateController.text.isEmpty
                      ? 'Waktu Masuk'
                      : 'Waktu Masuk: ${_entryDateController.text}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D2B45),
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.edit_calendar_rounded,
              size: 18,
              color: Color(0xFF0D2B45),
            ),
          ],
        ),
      ),
    );
  }

  // ── CUSTOM PILL TEXT FIELD ─────────────────────────────────────────────────
  Widget _buildCustomPillField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFECC49E), // Peach / Beige Pill
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE28B38), width: 1.2),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0D2B45),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D2B45).withValues(alpha: 0.6),
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  // ── FIELD ESTIMASI NILAI POTENSIAL ─────────────────────────────────────────
  Widget _buildPotentialValueField({required bool isProspek}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFECC49E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE28B38), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _potentialValueController,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D2B45),
            ),
            decoration: InputDecoration(
              hintText: isProspek
                  ? 'Estimasi Nilai potensial * (Wajib)'
                  : 'Estimasi Nilai potensial',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D2B45).withValues(alpha: 0.6),
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            isProspek
                ? 'wajib diisi untuk Prospek (angka atau teks)'
                : 'bisa diisi untuk Leads (opsional)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isProspek
                  ? const Color(0xFF0D2B45).withValues(alpha: 0.65)
                  : const Color(0xFF0D2B45).withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }

  // ── KATEGORI DROPDOWN FIELD ────────────────────────────────────────────────
  Widget _buildCategoryDropdownField() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isCategoryDropdownOpen = !_isCategoryDropdownOpen;
            });
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFECC49E),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE28B38), width: 1.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kategori: $_selectedCategory',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D2B45),
                  ),
                ),
                Icon(
                  _isCategoryDropdownOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF0D2B45),
                  size: 26,
                ),
              ],
            ),
          ),
        ),

        // Dropdown Items (Prospek & Leads)
        if (_isCategoryDropdownOpen) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFE28B38).withValues(alpha: 0.5),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildDropdownOption('Prospek'),
                const SizedBox(height: 6),
                _buildDropdownOption('Leads'),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDropdownOption(String label) {
    final bool isSelected = _selectedCategory == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
          _isCategoryDropdownOpen = false;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 44,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF7A00)
              : const Color(0xFFECC49E),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE28B38), width: 1.2),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xFF0D2B45),
            ),
          ),
        ),
      ),
    );
  }
}
