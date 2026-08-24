import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class JadwalkanFollowUpScreen extends StatefulWidget {
  final Map<String, dynamic>? prospekData;
  final Function(Map<String, dynamic>)? onScheduled;

  const JadwalkanFollowUpScreen({
    super.key,
    this.prospekData,
    this.onScheduled,
  });

  @override
  State<JadwalkanFollowUpScreen> createState() =>
      _JadwalkanFollowUpScreenState();
}

class _JadwalkanFollowUpScreenState extends State<JadwalkanFollowUpScreen> {
  String _selectedJenis = 'Kunjungan';
  late DateTime _selectedDate;
  late DateTime _currentMonth;
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedPriority = 'Tinggi';
  bool _isPriorityDropdownOpen = false;

  bool _remind1Day = false;
  bool _remind3Hours = true;
  bool _remindDueTime = false;

  final List<String> _jenisList = [
    'Kunjungan',
    'Telepon',
    'whatsApp',
    'Negosiasi',
    'Presentasi',
    'Demo',
    'meeting online',
    'Pengiriman Proposal',
  ];

  final List<String> _priorityList = ['Tinggi', 'Normal', 'Rendah'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = now.add(const Duration(days: 4)); // Default follow-up date
    _currentMonth = DateTime(now.year, now.month, 1);
    _timeController.text = '10:00';
  }

  @override
  void dispose() {
    _timeController.dispose();
    _purposeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
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
        _timeController.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  void _saveFollowUp() {
    final purpose = _purposeController.text.trim();
    final notes = _notesController.text.trim();
    final formattedDate =
        '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}';
    final timeStr = _timeController.text.trim().isEmpty
        ? '10:00'
        : _timeController.text.trim();

    final result = {
      'title': 'Jadwal Follow-Up: $_selectedJenis',
      'desc': purpose.isNotEmpty
          ? '$purpose (Prioritas: $_selectedPriority)'
          : (notes.isNotEmpty
                ? '$notes (Prioritas: $_selectedPriority)'
                : 'Agenda follow-up $_selectedJenis mendatang (Prioritas: $_selectedPriority)'),
      'date': formattedDate,
      'time': timeStr,
      'jenis': _selectedJenis,
      'priority': _selectedPriority,
      'purpose': purpose,
      'notes': notes,
      'isCompleted':
          false, // FALSE: Belum dikerjakan -> Timeline warna putih/outline
    };

    if (widget.onScheduled != null) {
      widget.onScheduled!(result);
    }

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final company =
        widget.prospekData?['company'] ??
        widget.prospekData?['name'] ??
        'Nama perusahaan/instansi dan PIC';
    final status = widget.prospekData?['status'] ?? 'Pipeline';

    return Scaffold(
      backgroundColor: const Color(0xFFFF7A00),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── 1. HEADER ───────────────────────────────────────────────────
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
                    'Jadwalkan Follow-Up',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                ],
              ),
            ),

            // ── 2. MAIN CONTENT ─────────────────────────────────────────────
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
                      color: Color(0xFFDCE2E7), // Light Slate Container
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
                          // SVG background
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
                              18,
                              16,
                              24 + MediaQuery.of(context).padding.bottom,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ── PROSPEK HEADER CARD ──────────────────────
                                Row(
                                  children: [
                                    Container(
                                      width: 46,
                                      height: 46,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFFFD59E),
                                      ),
                                      child: const Icon(
                                        Icons.business_rounded,
                                        color: Color(0xFF0D2B45),
                                        size: 26,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            company,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF0D2B45),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Text(
                                                'PIC',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                        0xFF0D2B45,
                                                      ),
                                                    ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF0D2B45,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  status,
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // ── JENIS FOLLOW-UP CONTAINER ────────────────
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF002045)
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Jenis Follow-up',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFFF7A00),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: _jenisList.map((jenis) {
                                          final isSelected =
                                              _selectedJenis == jenis;
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedJenis = jenis;
                                              });
                                            },
                                            behavior: HitTestBehavior.opaque,
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 150,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? const Color(0xFFFF7A00)
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFFF7A00,
                                                  ),
                                                  width: 1.2,
                                                ),
                                              ),
                                              child: Text(
                                                jenis,
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isSelected
                                                          ? Colors.white
                                                          : const Color(
                                                              0xFFFF7A00,
                                                            ),
                                                    ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // ── PILIH TANGGAL (CALENDAR VIEW) ────────────
                                Text(
                                  'Pilih Tanggal',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF7A00),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                _buildInteractiveCalendar(),
                                const SizedBox(height: 14),

                                // ── JAM & PRIORITAS ROW ──────────────────────
                                Row(
                                  children: [
                                    // Jam
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Jam',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFFFF7A00),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          GestureDetector(
                                            onTap: _selectTime,
                                            child: Container(
                                              height: 42,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFFF7A00,
                                                  ),
                                                  width: 1.2,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          10,
                                                        ),
                                                    child: const Icon(
                                                      Icons.access_time_rounded,
                                                      color: Color(0xFFFF7A00),
                                                      size: 18,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 1.2,
                                                    height: 42,
                                                    color: const Color(
                                                      0xFFFF7A00,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: Text(
                                                        _timeController
                                                                .text
                                                                .isEmpty
                                                            ? '_ _ : _ _'
                                                            : _timeController
                                                                  .text,
                                                        style:
                                                            GoogleFonts.plusJakartaSans(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  const Color(
                                                                    0xFF0D2B45,
                                                                  ),
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Prioritas Dropdown
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Prioritas',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFFFF7A00),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          _buildPriorityDropdown(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // ── TUJUAN FOLLOW-UP ─────────────────────────
                                Text(
                                  'Tujuan Follow-up',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF7A00),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFFF7A00),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _purposeController,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: const Color(0xFF0D2B45),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Tuliskan tujuan follow-up...',
                                      hintStyle: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: const Color(0xFF8FA1B0),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // ── CATATAN TAMBAHAN ─────────────────────────
                                Text(
                                  'Catatan Tambahan',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF7A00),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color(0xFFFF7A00),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _notesController,
                                    minLines: 3,
                                    maxLines: 4,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: const Color(0xFF0D2B45),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Contoh : sertakan list harga terbaru',
                                      hintStyle: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: const Color(0xFF8FA1B0),
                                      ),
                                      contentPadding: const EdgeInsets.all(14),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // ── PENGINGAT (CHECKBOXES) ───────────────────
                                Text(
                                  'Pengingat',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF7A00),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                _buildReminderOption(
                                  title: '1 hari sebelumnya',
                                  value: _remind1Day,
                                  onChanged: (val) {
                                    setState(() {
                                      _remind1Day = val ?? false;
                                    });
                                  },
                                ),
                                _buildReminderOption(
                                  title: '3 jam sebelumnya',
                                  value: _remind3Hours,
                                  onChanged: (val) {
                                    setState(() {
                                      _remind3Hours = val ?? false;
                                    });
                                  },
                                ),
                                _buildReminderOption(
                                  title: 'Saat jatuh tempo',
                                  value: _remindDueTime,
                                  onChanged: (val) {
                                    setState(() {
                                      _remindDueTime = val ?? false;
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),

                                // ── JADWALKAN FOLLOW UP BUTTON ───────────────
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF7A00),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 3,
                                    ),
                                    onPressed: _saveFollowUp,
                                    child: Text(
                                      'Jadwalkan Follow UP',
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

  // ── INTERACTIVE CALENDAR VIEW WIDGET ───────────────────────────────────────
  Widget _buildInteractiveCalendar() {
    final year = _currentMonth.year;
    final month = _currentMonth.month;
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    // Weekday: 1 = Monday, ..., 7 = Sunday
    final startingWeekday = firstDayOfMonth.weekday; // 1 to 7

    final today = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month Header with Prev/Next buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Color(0xFF0D2B45)),
                onPressed: () {
                  setState(() {
                    _currentMonth = DateTime(year, month - 1, 1);
                  });
                },
              ),
              Text(
                '${_getMonthName(month)} $year',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D2B45),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Color(0xFF0D2B45)),
                onPressed: () {
                  setState(() {
                    _currentMonth = DateTime(year, month + 1, 1);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Day Names Row (S S R K J S M)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'S', 'R', 'K', 'J', 'S', 'M'].map((day) {
              return SizedBox(
                width: 32,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8FA1B0),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Calendar Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (startingWeekday - 1) + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemBuilder: (context, index) {
              if (index < startingWeekday - 1) {
                return const SizedBox.shrink(); // Empty offset day
              }

              final dayNumber = index - (startingWeekday - 1) + 1;
              final cellDate = DateTime(year, month, dayNumber);

              final isSelected =
                  cellDate.year == _selectedDate.year &&
                  cellDate.month == _selectedDate.month &&
                  cellDate.day == _selectedDate.day;

              final isToday =
                  cellDate.year == today.year &&
                  cellDate.month == today.month &&
                  cellDate.day == today.day;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = cellDate;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isToday
                        ? const Color(0xFF0D2B45)
                        : (isSelected
                              ? const Color(0xFFE8F2FF)
                              : Colors.transparent),
                    border: isSelected
                        ? Border.all(color: const Color(0xFF3880FF), width: 1.5)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$dayNumber',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: (isSelected || isToday)
                            ? FontWeight.bold
                            : FontWeight.w600,
                        color: isToday
                            ? Colors.white
                            : (isSelected
                                  ? const Color(0xFF3880FF)
                                  : const Color(0xFF0D2B45)),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── PRIORITAS DROPDOWN WIDGET ──────────────────────────────────────────────
  Widget _buildPriorityDropdown() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isPriorityDropdownOpen = !_isPriorityDropdownOpen;
            });
          },
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFF7A00), width: 1.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedPriority,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D2B45),
                  ),
                ),
                Icon(
                  _isPriorityDropdownOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFFFF7A00),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (_isPriorityDropdownOpen)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFF7A00).withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: _priorityList.map((pri) {
                final isSel = pri == _selectedPriority;
                return ListTile(
                  dense: true,
                  title: Text(
                    pri,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      color: isSel
                          ? const Color(0xFFFF7A00)
                          : const Color(0xFF0D2B45),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedPriority = pri;
                      _isPriorityDropdownOpen = false;
                    });
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // ── REMINDER CHECKBOX HELPER ───────────────────────────────────────────────
  Widget _buildReminderOption({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: value,
                activeColor: const Color(0xFF0D2B45),
                checkColor: Colors.white,
                side: const BorderSide(color: Color(0xFFFF7A00), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF7A00),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
