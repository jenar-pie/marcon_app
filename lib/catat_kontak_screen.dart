import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CatatKontakScreen extends StatefulWidget {
  final Map<String, dynamic> leadData;

  const CatatKontakScreen({super.key, required this.leadData});

  @override
  State<CatatKontakScreen> createState() => _CatatKontakScreenState();
}

class _CatatKontakScreenState extends State<CatatKontakScreen> {
  String _selectedJenis =
      'Telepon'; // 'Telepon', 'WhatsApp', 'Gmail', 'Kunjungan'
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _jamController = TextEditingController();
  final TextEditingController _durasiController = TextEditingController(
    text: '6 mnt',
  );
  final TextEditingController _picController = TextEditingController();
  final TextEditingController _ringkasanController = TextEditingController();
  final TextEditingController _kendalaController = TextEditingController();

  String _selectedTersambung = 'Tersambung - Minta info lebih lanjut';
  String _selectedInterest = 'Hangat'; // 'Dingin', 'Hangat', 'Panas'
  bool _needsFollowUp = false;
  String _selectedTindakLanjutAction = 'Tetap : Dihubungi';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _tanggalController.text = '${now.day}/${now.month}/${now.year}';
    _jamController.text =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    _picController.text = widget.leadData['contactName'] ?? '';
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    _jamController.dispose();
    _durasiController.dispose();
    _picController.dispose();
    _ringkasanController.dispose();
    _kendalaController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
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
        _tanggalController.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
        _jamController.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void _showTersambungDropdown() {
    final options = [
      'Tersambung - Minta info lebih lanjut',
      'Tersambung - Belum ditarik',
      'Tidak diangkat/Tidak dibalas',
      'Nomor tidak aktif',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Pilih Status Tersambung',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D2B45),
                  ),
                ),
              ),
              const Divider(height: 1),
              ...options.map(
                (opt) => ListTile(
                  title: Text(
                    opt,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                  trailing: _selectedTersambung == opt
                      ? const Icon(
                          Icons.check_rounded,
                          color: Color(0xFFFF7A00),
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedTersambung = opt;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTindakLanjutDropdown() {
    final options = [
      'Tetap : Dihubungi',
      'Naikan : Qualified - Siap jadi prospek',
      'Turunkan : Unqualified',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Pilih Tindak Lanjut',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D2B45),
                  ),
                ),
              ),
              const Divider(height: 1),
              ...options.map(
                (opt) => ListTile(
                  title: Text(
                    opt,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                  trailing: _selectedTindakLanjutAction == opt
                      ? const Icon(
                          Icons.check_rounded,
                          color: Color(0xFFFF7A00),
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedTindakLanjutAction = opt;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveContact() {
    if (_tanggalController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Tanggal wajib diisi!')));
      return;
    }

    Navigator.of(context).pop({
      'jenis': _selectedJenis,
      'tanggal': _tanggalController.text.trim(),
      'jam': _jamController.text.trim(),
      'durasi': _durasiController.text.trim(),
      'pic': _picController.text.trim(),
      'status_tersambung': _selectedTersambung,
      'interest': _selectedInterest,
      'ringkasan': _ringkasanController.text.trim().isEmpty
          ? 'Melakukan kontak'
          : _ringkasanController.text.trim(),
      'kendala': _kendalaController.text.trim(),
      'followUp': _needsFollowUp,
      'tindak_lanjut_action': _selectedTindakLanjutAction,
    });
  }

  @override
  Widget build(BuildContext context) {
    final companyName =
        widget.leadData['company'] ??
        widget.leadData['name'] ??
        'Nama perusahaan/instansi';
    final picName = widget.leadData['contactName'] ?? '-';
    final source = widget.leadData['source'] ?? '-';

    return Scaffold(
      backgroundColor: const Color(0xFFFF7A00),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── HEADER ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
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
                    'Catat Kontak',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                ],
              ),
            ),

            // ── MAIN CONTENT CONTAINER ───────────────────────────────────────
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
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  child: Container(
                    color: const Color(0xFFF3F6F8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // SVG decoration backdrop
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

                        // Form
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            16,
                            20,
                            16,
                            24 + MediaQuery.of(context).padding.bottom,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Client Info Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF002045)
                                      .withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFF002045)
                                        .withValues(alpha: 0.08),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFECC49E),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            companyName,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF0D2B45),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'PIC. $picName  Sumber lead : $source',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF0D2B45)
                                                  .withValues(alpha: 0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // ── Jenis Kontak ───────────────────────────────
                              Text(
                                'Jenis Kontak',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF7A00),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildJenisButton('Telepon'),
                                  const SizedBox(width: 8),
                                  _buildJenisButton('WhatsApp'),
                                  const SizedBox(width: 8),
                                  _buildJenisButton('Gmail'),
                                  const SizedBox(width: 8),
                                  _buildJenisButton('Kunjungan'),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // ── Tanggal, Jam, Durasi Row ────────────────────
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tanggal',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFFF7A00),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        GestureDetector(
                                          onTap: _selectDate,
                                          child: _buildBorderedField(
                                            controller: _tanggalController,
                                            hintText: 'mm/dd/yyyy',
                                            enabled: false,
                                            suffixIcon:
                                                Icons.calendar_today_rounded,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Jam',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFFF7A00),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        GestureDetector(
                                          onTap: _selectTime,
                                          child: _buildBorderedField(
                                            controller: _jamController,
                                            hintText: '--:--',
                                            enabled: false,
                                            suffixIcon:
                                                Icons.access_time_rounded,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Durasi',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFFF7A00),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        _buildBorderedField(
                                          controller: _durasiController,
                                          hintText: 'Durasi',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // ── Dihubungi Dengan Siapa ─────────────────────
                              Text(
                                'Dihubungi Dengan Siapa',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF7A00),
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildBorderedField(
                                controller: _picController,
                                hintText:
                                    'Diisi dengan nama yang mengangkat kontak',
                              ),
                              const SizedBox(height: 20),

                              // ── HASIL KONTAK SECTION ───────────────────────
                              Text(
                                'Hasil Kontak',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0D2B45),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Status Tersambung
                              Text(
                                'Status Tersambung',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF7A00),
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _showTersambungDropdown,
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFFF7A00)
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _selectedTersambung,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF0D2B45),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Color(0xFFFF7A00),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Tingkat Ketertarikan
                              Text(
                                'Tingkat Ketertarikan',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF7A00),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildInterestButton('Dingin'),
                                  const SizedBox(width: 10),
                                  _buildInterestButton('Hangat'),
                                  const SizedBox(width: 10),
                                  _buildInterestButton('Panas'),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Ringkasan Pembicaraan
                              Text(
                                'Ringkasan Pembicaraan',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF7A00),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFFF7A00)
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: TextField(
                                  controller: _ringkasanController,
                                  maxLines: 4,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    color: const Color(0xFF0D2B45),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan ringkasan pembicaraan di sini...',
                                    hintStyle: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: Colors.grey[400],
                                    ),
                                    contentPadding: const EdgeInsets.all(12),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Kendala / Keberatan (Jika Ada)
                              Text(
                                'Kendala / Keberatan (Jika Ada)',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF7A00),
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildBorderedField(
                                controller: _kendalaController,
                                hintText: 'Masukkan kendala jika ada...',
                              ),
                              const SizedBox(height: 24),

                              // ── TINDAK LANJUT SECTION ───────────────────────
                              Text(
                                'Tindak Lanjut',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0D2B45),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Follow Up Toggle Switch Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Perlu follow-up lanjutan ?',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFFFF7A00),
                                          ),
                                        ),
                                        Text(
                                          'Otomatis buat jadwal follow-up',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF0D2B45)
                                                .withValues(alpha: 0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: _needsFollowUp,
                                    onChanged: (val) {
                                      setState(() {
                                        _needsFollowUp = val;
                                      });
                                    },
                                    activeThumbColor: const Color(0xFFFF7A00),
                                    activeTrackColor: const Color(0xFFFF7A00)
                                        .withValues(alpha: 0.5),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Dropdown Tindak Lanjut (Raise / Lower status)
                              Text(
                                'Status Tindak Lanjut',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF7A00),
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _showTindakLanjutDropdown,
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFFF7A00)
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _selectedTindakLanjutAction,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF0D2B45),
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Color(0xFFFF7A00),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),

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
                                  onPressed: _saveContact,
                                  child: Text(
                                    'Simpan Catatan Kontak',
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
          ],
        ),
      ),
    );
  }

  Widget _buildJenisButton(String val) {
    final bool isSelected = _selectedJenis == val;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedJenis = val;
          });
        },
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF7A00) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFF7A00), width: 1.2),
          ),
          child: Center(
            child: Text(
              val,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFFFF7A00),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInterestButton(String val) {
    final bool isSelected = _selectedInterest == val;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedInterest = val;
          });
        },
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF7A00) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFF7A00), width: 1.2),
          ),
          child: Center(
            child: Text(
              val,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFFFF7A00),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBorderedField({
    required TextEditingController controller,
    required String hintText,
    bool enabled = true,
    IconData? suffixIcon,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFF7A00).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: TextField(
                controller: controller,
                enabled: enabled,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0D2B45),
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.grey[400],
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          if (suffixIcon != null) ...[
            const SizedBox(width: 8),
            Icon(suffixIcon, size: 18, color: const Color(0xFFFF7A00)),
          ],
        ],
      ),
    );
  }
}
