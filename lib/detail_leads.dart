import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'catat_kontak_screen.dart';

class DetailLeadsScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailLeadsScreen({super.key, required this.data});

  @override
  State<DetailLeadsScreen> createState() => _DetailLeadsScreenState();
}

class _DetailLeadsScreenState extends State<DetailLeadsScreen> {
  late String _currentStatus; // 'Baru', 'Dihubungi', 'Unqualified'
  late String _selectedKualifikasi; // 'Baru', 'Dihubungi', 'Qualified'
  late TextEditingController _catatanController;
  late List<_ActivityItem> _activities;

  @override
  void initState() {
    super.initState();

    // Map existing lead status dynamically
    final rawStatus = widget.data['status'] ?? 'Baru';
    if (rawStatus == 'Lead Baru' || rawStatus == 'Baru') {
      _currentStatus = 'Baru';
      _selectedKualifikasi = 'Baru';
    } else if (rawStatus == 'Follow Up' ||
        rawStatus == 'Dihubungi' ||
        rawStatus == 'Sedang dihubungi') {
      _currentStatus = 'Dihubungi';
      _selectedKualifikasi = 'Dihubungi';
    } else if (rawStatus == 'Unqualified') {
      _currentStatus = 'Unqualified';
      _selectedKualifikasi = 'Baru';
    } else if (rawStatus == 'Qualified') {
      _currentStatus = 'Dihubungi';
      _selectedKualifikasi = 'Qualified';
    } else {
      _currentStatus = 'Baru';
      _selectedKualifikasi = 'Baru';
    }

    _catatanController = TextEditingController(
      text: widget.data['catatan'] ?? '',
    );

    final entryDate = widget.data['date'] ?? '16 Jan 2026';
    _activities = [
      _ActivityItem(
        title: 'Lead masuk otomatis',
        date: entryDate,
        time: '09:00',
        desc: 'Isi form landing page Google Ads',
        isCompleted: true,
      ),
      _ActivityItem(
        title: 'Hubungi PIC',
        date: entryDate,
        time: '11:00',
        desc: 'Melakukan panggilan pertama untuk kualifikasi',
        isCompleted: true,
      ),
    ];
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  void _handleBack() {
    Navigator.of(context).pop({
      'action': 'update',
      'data': {
        ...widget.data,
        'status': _currentStatus,
        'catatan': _catatanController.text,
      },
    });
  }

  Future<void> _catatKontak() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => CatatKontakScreen(leadData: widget.data),
      ),
    );

    if (result != null) {
      final String action = result['tindak_lanjut_action'] ?? 'Tetap : Dihubungi';

      setState(() {
        // 1. Add recorded contact to timeline
        _activities.insert(
          1,
          _ActivityItem(
            title: '${result['jenis']} - ${result['status_tersambung']}',
            date: result['tanggal'] ?? '23 Agu 2026',
            time: result['jam'] ?? '10:00',
            desc: 'Ringkasan: ${result['ringkasan']}\nKendala: ${result['kendala']}',
            isCompleted: true,
          ),
        );

        // 2. If followUp is requested, auto-schedule a future follow-up item (outline)
        if (result['followUp'] == true) {
          _activities.add(
            _ActivityItem(
              title: 'Follow-Up Lanjutan',
              date: result['tanggal'] ?? '24 Agu 2026',
              time: result['jam'] ?? '10:00',
              desc: 'Jadwal follow-up otomatis dari catatan kontak',
              isCompleted: false,
            ),
          );
        }

        // 3. Update local status state
        if (action == 'Naikan : Qualified - Siap jadi prospek') {
          _selectedKualifikasi = 'Qualified';
          _currentStatus = 'Dihubungi';
        } else if (action == 'Turunkan : Unqualified') {
          _currentStatus = 'Unqualified';
          _selectedKualifikasi = 'Baru';
        } else {
          _currentStatus = 'Dihubungi';
          _selectedKualifikasi = 'Dihubungi';
        }
      });

      // 4. After setState, handle navigation side-effects
      if (!mounted) return;

      if (action == 'Naikan : Qualified - Siap jadi prospek') {
        // Auto-convert to prospect — navigate back with convert action
        _convertToProspect();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              action == 'Turunkan : Unqualified'
                  ? 'Kontak dicatat & Lead diturunkan ke Unqualified!'
                  : 'Kontak dicatat & status diperbarui ke Dihubungi!',
            ),
            backgroundColor: const Color(0xFF0D2B45),
          ),
        );
      }
    }
  }

  void _tandaiUnqualified() {
    setState(() {
      _currentStatus = 'Unqualified';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lead ditandai sebagai Unqualified!'),
        backgroundColor: Color(0xFFB01212),
      ),
    );
  }

  void _convertToProspect() {
    Navigator.of(context).pop({
      'action': 'convert',
      'data': {
        ...widget.data,
        'status': 'Pipeline',
        'catatan': _catatanController.text,
      },
    });
  }

  void _showKualifikasiDropdown() {
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
                  'Pilih Status Kualifikasi',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D2B45),
                  ),
                ),
              ),
              const Divider(height: 1),
              _buildDropdownOption('Baru'),
              _buildDropdownOption('Dihubungi'),
              _buildDropdownOption('Qualified'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdownOption(String val) {
    return ListTile(
      title: Text(
        val,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: _selectedKualifikasi == val
              ? FontWeight.bold
              : FontWeight.normal,
          color: const Color(0xFF0D2B45),
        ),
      ),
      trailing: _selectedKualifikasi == val
          ? const Icon(Icons.check_rounded, color: Color(0xFFFF7A00))
          : null,
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          _selectedKualifikasi = val;
          // Synchronize top-right status badge
          if (val == 'Qualified') {
            _currentStatus = 'Dihubungi'; // Remains in Contact but Qualified
          } else {
            _currentStatus = val;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final companyName =
        widget.data['company'] ?? widget.data['name'] ?? 'Nama perusahaan';
    final source = widget.data['source'] ?? 'Manual Input';
    final product = widget.data['product'] ?? 'Marcon Solution';
    final contactName = widget.data['contactName'] ?? '-';
    final phone = widget.data['phone'] ?? '-';
    final address = widget.data['address'] ?? '-';
    final potential = widget.data['potensi'] ?? widget.data['potential'] ?? '-';
    final entryDate = widget.data['date'] ?? '16 Jan 2026';

    Color badgeColor = const Color(0xFFFF7A00); // Orange
    if (_currentStatus == 'Unqualified') {
      badgeColor = const Color(0xFFB01212); // Dark Red
    } else if (_currentStatus == 'Baru') {
      badgeColor = const Color(0xFF0D2B45); // Dark Navy
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFF7A00), // Orange Header
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── HEADER SECTION ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: _handleBack,
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
                    'Detail Leads',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                ],
              ),
            ),

            // ── MAIN WHITE CONTAINER ─────────────────────────────────────────
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
                    color: const Color(0xFFF3F6F8), // Grey-ish Background
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // SVG backdrop
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

                        // Content
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
                              // ── Company Card ─────────────────────────────────
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            companyName,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF0D2B45),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: badgeColor,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            _currentStatus,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Sumber lead : $source',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        color: const Color(0xFF0D2B45),
                                      ),
                                    ),
                                    Text(
                                      'Tanggal masuk : $entryDate',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        color: const Color(0xFF0D2B45),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // ── Info Rows ────────────────────────────────────
                              _infoRow(
                                'PIC',
                                '$contactName (${widget.data['role'] ?? widget.data['pic'] ?? 'PIC'})',
                              ),
                              _infoRow('No. Telepon', phone),
                              _infoRow('Alamat', address),
                              _infoRow('Produk diminati', product),
                              _infoRow('Sumber lead', source),
                              if (potential != '-')
                                _infoRow('Potensi nilai', potential),
                              const SizedBox(height: 14),

                              // ── Hubungi Section ──────────────────────────────
                              Text(
                                'Hubungi',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF7A00),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _contactButton(
                                    'Telepon',
                                    Icons.phone_in_talk_rounded,
                                  ),
                                  const SizedBox(width: 8),
                                  _contactButton(
                                    'WhatsApp',
                                    Icons.chat_bubble_rounded,
                                  ),
                                  const SizedBox(width: 8),
                                  _contactButton('Gmail', Icons.mail_rounded),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // ── Status Kualifikasi Dropdown ─────────────────
                              Text(
                                'Status Kualifikasi',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF7A00),
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _showKualifikasiDropdown,
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
                                        _selectedKualifikasi,
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
                              const SizedBox(height: 20),

                              // ── Catatan Kualifikasi ──────────────────────────
                              Text(
                                'Catatan Kualifikasi',
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
                                  controller: _catatanController,
                                  maxLines: 4,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    color: const Color(0xFF0D2B45),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan catatan kualifikasi di sini...',
                                    hintStyle: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: Colors.grey[400],
                                    ),
                                    contentPadding: const EdgeInsets.all(12),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // ── Riwayat Kontak ───────────────────────────────
                              Text(
                                'Riwayat Kontak',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0D2B45),
                                ),
                              ),
                              const SizedBox(height: 14),

                              _activityTimeline(),
                              const SizedBox(height: 24),

                              // ── Action Buttons ──────────────────────────────
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: _catatKontak,
                                      behavior: HitTestBehavior.opaque,
                                      child: _outlineActionButton(
                                        '+ Catat Kontak',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: _tandaiUnqualified,
                                      behavior: HitTestBehavior.opaque,
                                      child: _redActionButton(
                                        'Tandai Unqualified',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: GestureDetector(
                                  onTap: _convertToProspect,
                                  behavior: HitTestBehavior.opaque,
                                  child: _filledActionButton(
                                    'Convert ke Prospect',
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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: const Color(0xFF0D2B45),
              ),
            ),
          ),
          Text(
            ':',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: const Color(0xFF0D2B45),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0D2B45),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactButton(String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFF7A00),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityTimeline() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(_activities.length, (i) {
          final item = _activities[i];
          final isLast = i == _activities.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.isCompleted
                          ? const Color(0xFFFF7A00) // Completed: Orange
                          : Colors.white, // Pending: White
                      border: Border.all(
                        color: const Color(0xFFFF7A00),
                        width: 2,
                      ),
                      boxShadow: item.isCompleted
                          ? [
                              BoxShadow(
                                color: const Color(0xFFFF7A00)
                                    .withValues(alpha: 0.35),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Icon(
                        item.isCompleted ? Icons.check : Icons.schedule_rounded,
                        size: 15,
                        color: item.isCompleted
                            ? Colors.white
                            : const Color(0xFFFF7A00),
                      ),
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 3,
                      height: 52,
                      decoration: BoxDecoration(
                        color: item.isCompleted
                            ? const Color(0xFFFF7A00)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: item.isCompleted
                                    ? const Color(0xFFFF7A00)
                                    : const Color(0xFF0D2B45),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: item.isCompleted
                                  ? const Color(0xFFFF7A00)
                                        .withValues(alpha: 0.12)
                                  : const Color(0xFF0D2B45)
                                        .withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${item.date} • ${item.time}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: item.isCompleted
                                    ? const Color(0xFFFF7A00)
                                    : const Color(0xFF0D2B45),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.desc,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: const Color(0xFF0D2B45).withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _outlineActionButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFF7A00), width: 1.5),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF7A00),
          ),
        ),
      ),
    );
  }

  Widget _redActionButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFB01212),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _filledActionButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFF7A00),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7A00).withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _ActivityItem {
  final String title;
  final String date;
  final String time;
  final String desc;
  bool isCompleted;

  _ActivityItem({
    required this.title,
    required this.date,
    required this.time,
    required this.desc,
    required this.isCompleted,
  });
}
