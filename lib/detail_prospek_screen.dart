import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'buat_proposal_screen.dart';
import 'approval_proposal_screen.dart';
import 'catat_notulensi_screen.dart';
import 'jadwalkan_follow_up_screen.dart';

class DetailProspekScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  const DetailProspekScreen({super.key, this.data});

  // Global static activity store per company
  static final Map<String, List<ActivityItem>> companyActivities = {};

  static void addActivityForCompany(
    String companyName,
    Map<String, dynamic> activityData,
  ) {
    final key = companyName.trim().toLowerCase();
    companyActivities.putIfAbsent(key, () => []);

    final bool isOtw = activityData['isCompleted'] != true;
    final String notulensiRaw =
        (activityData['notulensi'] as String? ?? '').trim();
    final String descText = notulensiRaw.isNotEmpty
        ? notulensiRaw
        : 'Check in lokasi & notulensi kunjungan';

    companyActivities[key]!.add(
      ActivityItem(
        title: activityData['hasil'] ?? 'Check In-Out & Notulensi Kunjungan',
        date: activityData['date'] as String? ?? _todayStrStatic(),
        time: activityData['time'] as String? ??
            '${activityData['checkIn'] ?? "08:30"} - ${activityData['checkOut'] ?? "10:02"}',
        desc: descText,
        isCompleted: !isOtw,
        isOtw: isOtw,
        type: 'checkin',
        rawData: activityData,
      ),
    );

    final followUp = activityData['followUpData'] as Map<String, dynamic>?;
    if (followUp != null) {
      final jenis = followUp['jenis'] ?? 'Kunjungan';
      final tgl = followUp['date'] ?? _todayStrStatic();
      final jam = followUp['time'] ?? '10:00';
      final purpose = (followUp['purpose'] as String? ?? '').trim();
      final notes = (followUp['notes'] as String? ?? '').trim();
      final desc = purpose.isNotEmpty
          ? purpose
          : (notes.isNotEmpty ? notes : 'Agenda follow-up $jenis');

      companyActivities[key]!.add(
        ActivityItem(
          title: 'Follow Up: $jenis',
          date: tgl,
          time: jam,
          desc: desc,
          isCompleted: false,
          isOtw: true,
          type: 'followup',
          rawData: followUp,
        ),
      );
    }
  }

  static String _todayStrStatic() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }

  @override
  State<DetailProspekScreen> createState() => _DetailProspekScreenState();
}

class _DetailProspekScreenState extends State<DetailProspekScreen> {
  late List<ActivityItem> _activities;
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    final companyName =
        widget.data?['company'] ?? widget.data?['name'] ?? 'Nama perusahaan';
    final key = companyName.trim().toLowerCase();
    final entryDate = widget.data?['date'] ?? '16 Jan 2026';
    _currentStatus = widget.data?['status'] ?? 'Pipeline';

    if (!DetailProspekScreen.companyActivities.containsKey(key) ||
        DetailProspekScreen.companyActivities[key]!.isEmpty) {
      DetailProspekScreen.companyActivities[key] = [
        ActivityItem(
          title: 'Check In-Out & Notulensi Kunjungan',
          date: entryDate,
          time: '08:30 - 10:02',
          desc:
              'Presentasi solusi produk dan diskusi syarat kerjasama berjalan lancar.',
          isCompleted: true,
          type: 'checkin',
          rawData: {
            'checkIn': '08.30',
            'checkOut': '10.02',
            'notulensi':
                'Presentasi solusi produk dan diskusi syarat kerjasama berjalan lancar.',
            'checkInImg':
                'https://images.unsplash.com/photo-1577495508048-b635879837f1?auto=format&fit=crop&w=500&q=80',
            'checkOutImg':
                'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=500&q=80',
          },
        ),
        ActivityItem(
          title: 'Pengajuan Proposal Penawaran',
          date: entryDate,
          time: '11:30',
          desc:
              'Dokumen proposal penawaran harga & spesifikasi teknis Marcon Penawaran',
          isCompleted: true,
          type: 'proposal',
          rawData: {
            'fileName': 'Penawaran_Proposal_Marcon.pdf',
            'docId': 'DOC-20260901-7B1A',
          },
        ),
        const ActivityItem(
          title: 'Data Masuk & Registrasi',
          date: '15 Jan 2026',
          time: '09:00',
          desc: 'Prospek berhasil didaftarkan ke sistem Marcon CRM',
          isCompleted: true,
          type: 'checkin',
        ),
      ];
    }

    _activities = DetailProspekScreen.companyActivities[key]!;
    _sortActivities();
  }

  void _sortActivities() {
    _activities.sort((a, b) {
      final dtA = _parseDateTime(a.date, a.time);
      final dtB = _parseDateTime(b.date, b.time);
      return dtB.compareTo(dtA); // Urutan terbaru / mendatang di atas
    });
  }

  DateTime _parseDateTime(String dateStr, String timeStr) {
    try {
      int year = DateTime.now().year;
      int month = DateTime.now().month;
      int day = DateTime.now().day;
      int hour = 9;
      int minute = 0;

      final cleanTime = timeStr
          .split('-')
          .first
          .replaceAll('.', ':')
          .replaceAll('WIB', '')
          .trim();
      final timeParts = cleanTime.split(':');
      if (timeParts.length >= 2) {
        hour = int.tryParse(timeParts[0]) ?? 9;
        minute = int.tryParse(timeParts[1]) ?? 0;
      }

      if (dateStr.toLowerCase().contains('hari ini')) {
        return DateTime(year, month, day, hour, minute);
      }

      if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          day = int.tryParse(parts[0]) ?? day;
          month = int.tryParse(parts[1]) ?? month;
          year = int.tryParse(parts[2]) ?? year;
          return DateTime(year, month, day, hour, minute);
        }
      }

      final dateParts = dateStr.trim().split(' ');
      if (dateParts.length >= 3) {
        day = int.tryParse(dateParts[0]) ?? day;
        year = int.tryParse(dateParts[2]) ?? year;
        final mStr = dateParts[1].toLowerCase();
        const monthMap = {
          'jan': 1,
          'januari': 1,
          'feb': 2,
          'februari': 2,
          'mar': 3,
          'maret': 3,
          'apr': 4,
          'april': 4,
          'mei': 5,
          'may': 5,
          'jun': 6,
          'juni': 6,
          'jul': 7,
          'juli': 7,
          'agu': 8,
          'agustus': 8,
          'aug': 8,
          'sep': 9,
          'september': 9,
          'okt': 10,
          'oktober': 10,
          'oct': 10,
          'nov': 11,
          'november': 11,
          'des': 12,
          'desember': 12,
          'dec': 12,
        };
        month = monthMap[mStr] ?? month;
        return DateTime(year, month, day, hour, minute);
      }
    } catch (_) {}
    return DateTime.now();
  }

  Future<void> _openTambahAktivitas() async {
    final companyName =
        widget.data?['company'] ?? widget.data?['name'] ?? 'Nama perusahaan';
    final address = widget.data?['address'] ?? 'Jl. Garnisun Kav 2-3, Jakarta';

    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => CatatNotulensiScreen(
          scheduleItem: {
            'perusahaan': companyName,
            'checkInTime': '08.30',
            'checkOutTime': '10.02',
            'alamat': address,
            'notulensi': '',
            'checkInImg': '',
            'checkOutImg': '',
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        final bool hasPhoto =
            (result['checkInImg'] as String? ?? '').isNotEmpty &&
            (result['checkOutImg'] as String? ?? '').isNotEmpty;
        final String notulensiRaw =
            (result['notulensi'] as String? ?? '').trim();
        final String descText = notulensiRaw.isNotEmpty
            ? notulensiRaw
            : 'Check in lokasi & notulensi kunjungan';

        _activities.add(
          ActivityItem(
            title: result['hasil'] ?? 'Check In-Out & Notulensi Kunjungan',
            date: result['date'] as String? ?? _todayStr(),
            time:
                '${result['checkIn'] ?? '08:30'} - ${result['checkOut'] ?? '10:02'}',
            desc: descText,
            isCompleted: hasPhoto,
            isOtw: !hasPhoto,
            type: 'checkin',
            rawData: {
              'checkIn': result['checkIn'],
              'checkOut': result['checkOut'],
              'checkInImg': result['checkInImg'],
              'checkOutImg': result['checkOutImg'],
              'notulensi': descText,
            },
          ),
        );

        final followUpData = result['followUpData'] as Map<String, dynamic>?;
        if (followUpData != null) {
          final jenis = followUpData['jenis'] ?? 'Kunjungan';
          final tgl = followUpData['date'] ?? _todayStr();
          final jam = followUpData['time'] ?? '10:00';
          final purpose = (followUpData['purpose'] as String? ?? '').trim();
          final notes = (followUpData['notes'] as String? ?? '').trim();
          final desc = purpose.isNotEmpty
              ? purpose
              : (notes.isNotEmpty ? notes : 'Agenda follow-up $jenis');

          _activities.add(
            ActivityItem(
              title: 'Follow Up: $jenis',
              date: tgl,
              time: jam,
              desc: desc,
              isCompleted: false,
              isOtw: true,
              type: 'followup',
              rawData: followUpData,
            ),
          );
        }

        _sortActivities();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Aktivitas & jadwal follow-up berhasil masuk ke Riwayat!',
            ),
            backgroundColor: Color(0xFF0D2B45),
          ),
        );
      }
    }
  }

  String _todayStr() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }

  Future<void> _openJadwalkanFollowUp() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => JadwalkanFollowUpScreen(
          prospekData: widget.data,
        ),
      ),
    );

    if (result != null) {
      final jenis = result['jenis'] ?? 'Kunjungan';
      final tgl = result['date'] ?? _todayStr();
      final jam = result['time'] ?? '10:00';
      final purpose = (result['purpose'] as String? ?? '').trim();
      final notes = (result['notes'] as String? ?? '').trim();
      final desc = purpose.isNotEmpty
          ? purpose
          : (notes.isNotEmpty
                ? notes
                : (result['desc'] ?? 'Agenda follow-up $jenis'));

      setState(() {
        _activities.add(
          ActivityItem(
            title: result['title'] ?? 'Follow Up: $jenis',
            date: tgl,
            time: jam,
            desc: desc,
            isCompleted: false,
            isOtw: true,
            type: 'followup',
            rawData: result,
          ),
        );
        _sortActivities();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Jadwal follow-up tanggal $tgl berhasil diagendakan ke timeline!',
            ),
            backgroundColor: const Color(0xFF0D2B45),
          ),
        );
      }
    }
  }

  Future<void> _openBuatProposal(
    String company,
    String product,
    String price,
  ) async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => BuatProposalScreen(
          initialCompany: company,
          initialProduct: product,
          initialPrice: price,
        ),
      ),
    );

    if (result != null) {
      final statusDecision = result['status'];
      setState(() {
        if (statusDecision == 'Disetujui') {
          _currentStatus = 'Proposal Disetujui';
          _activities.add(
            const ActivityItem(
              title: 'Proposal Disetujui',
              date: '23/08/2026',
              time: '14:30',
              desc:
                  'Proposal disetujui oleh Manager. Siap ditindaklanjuti ke penutupan deal.',
              isCompleted: true,
            ),
          );
        } else if (statusDecision == 'Ditolak') {
          _currentStatus = 'Revisi Proposal';
          _activities.add(
            const ActivityItem(
              title: 'Proposal Perlu Revisi',
              date: '23/08/2026',
              time: '14:30',
              desc:
                  'Proposal dikembalikan oleh Manager untuk penyesuaian harga/diskon.',
              isCompleted: true,
            ),
          );
        } else {
          _currentStatus = 'Menunggu Approval';
          _activities.add(
            const ActivityItem(
              title: 'Pengajuan Proposal',
              date: '23/08/2026',
              time: '14:15',
              desc:
                  'Proposal telah diajukan dan sedang menunggu persetujuan Manager.',
              isCompleted: true,
            ),
          );
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status proposal: $_currentStatus'),
            backgroundColor: const Color(0xFF0D2B45),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final companyName = data?['company'] ?? data?['name'] ?? 'Nama perusahaan';
    final source = data?['source'] ?? 'Website Inbound';
    final product = data?['product'] ?? 'SaaS Marcon CRM';
    final contactName = data?['contactName'];
    final picName = contactName != null && contactName != '-'
        ? '$contactName (${data?['pic'] ?? data?['role'] ?? 'PIC'})'
        : (data?['pic'] ?? 'Ahmad R (jabatan)');
    final phone = data?['phone'] ?? '0881-734-728-21';
    final address = data?['address'] ?? 'Jl.ini, Bekasi';
    final potential = data?['potensi'] ?? data?['potential'] ?? 'Rp 85.000.000';
    final entryDate = data?['date'] ?? '16 Jan 2026';

    return Scaffold(
      backgroundColor: const Color(0xFFFF7A00),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── HEADER (Orange) ───────────────────────────────────────
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
                    'Detail Prospek',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                ],
              ),
            ),

            // ── LAYER 1: WHITE container (rounded top) ────────────────
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
                    color: const Color(
                      0xFFF3F6F8,
                    ), // Clean light slate background
                    child: SingleChildScrollView(
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
                          // ── LAYER 2: Company Card ───────────────────────
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
                                        color: const Color(0xFFFF7A00),
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
                                  'produk : $product',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: const Color(0xFF0D2B45),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ── Info Rows ───────────────────────────────────
                          _infoRow('PIC', picName),
                          _infoRow('No. Telepon', phone),
                          _infoRow('Alamat', address),
                          _infoRow('Potensi nilai', potential),
                          _infoRow('Waktu masuk', entryDate),
                          const SizedBox(height: 14),

                          // ── Hubungi ─────────────────────────────────────
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
                              _contactButton('Telepon'),
                              const SizedBox(width: 8),
                              _contactButton('WhatsApp'),
                              const SizedBox(width: 8),
                              _contactButton('Gmail'),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // ── Riwayat Aktivitas Section ───────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Riwayat Aktivitas',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0D2B45),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF7A00)
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_activities.length} Kegiatan',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF7A00),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Flowing Timeline with Completed (Orange) & Upcoming (Grey/White)
                          _activityTimeline(),
                          const SizedBox(height: 20),

                          // ── Action Buttons ──────────────────────────────
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: _openTambahAktivitas,
                                  behavior: HitTestBehavior.opaque,
                                  child: _outlineActionButton(
                                    '+ Tambah Aktivitas',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _openBuatProposal(
                                    companyName,
                                    product,
                                    potential,
                                  ),
                                  behavior: HitTestBehavior.opaque,
                                  child: _outlineActionButton(
                                    '+ Buat Proposal',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: _openJadwalkanFollowUp,
                              behavior: HitTestBehavior.opaque,
                              child: _filledActionButton(
                                'Jadwalkan Follow-Up',
                              ),
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

  // ── Info row helper ─────────────────────────────────────────────────────────
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
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

  // ── Contact button ──────────────────────────────────────────────────────────
  Widget _contactButton(String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFF7A00),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ── Flowing Timeline (Clickable to view Check In-Out Proof / Proposal) ─────
  Widget _activityTimeline() {
    final companyName =
        widget.data?['company'] ?? widget.data?['name'] ?? 'Nama perusahaan';
    final product = widget.data?['product'] ?? 'SaaS Marcon CRM';
    final potential =
        widget.data?['potensi'] ?? widget.data?['potential'] ?? 'Rp 85.000.000';
    final address = widget.data?['address'] ?? 'Jl. Garnisun Kav 2-3, Jakarta';

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
          final isProposal = item.type == 'proposal' ||
              item.title.toLowerCase().contains('proposal');

          // Dot color based on item status
          final Color dotColor;
          if (item.isOtw) {
            dotColor = const Color(0xFFFFB300); // Amber for OTW
          } else if (item.isCompleted) {
            dotColor = isProposal
                ? const Color(0xFFD32F2F)
                : const Color(0xFFFF7A00);
          } else {
            dotColor = const Color(0xFF0D2B45);
          }

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Timeline icon dot & connecting line (Mengalir mulus tanpa putus)
                Column(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (item.isCompleted || item.isOtw)
                            ? dotColor
                            : Colors.white,
                        border: (item.isCompleted || item.isOtw)
                            ? null
                            : Border.all(
                                color: const Color(0xFF0D2B45),
                                width: 2,
                              ),
                        boxShadow: (item.isCompleted || item.isOtw)
                            ? [
                                BoxShadow(
                                  color: dotColor.withValues(alpha: 0.35),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Icon(
                          item.isOtw
                              ? Icons.pending_actions_rounded
                              : (isProposal
                                  ? Icons.description_rounded
                                  : (item.isCompleted
                                      ? Icons.check
                                      : Icons.schedule_rounded)),
                          size: 14,
                          color: (item.isCompleted || item.isOtw)
                              ? Colors.white
                              : const Color(0xFF0D2B45),
                        ),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 3,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            color: item.isOtw
                                ? const Color(0xFFFFB300).withValues(alpha: 0.6)
                                : (item.isCompleted
                                    ? (isProposal
                                        ? const Color(0xFFD32F2F)
                                        : const Color(0xFFFF7A00))
                                    : Colors.grey[350]),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),

                // Activity content container (Interactive & Clickable)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 16),
                    child: InkWell(
                      onTap: () async {
                        if (isProposal) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApprovalProposalScreen(
                                proposalData: {
                                  'company': companyName,
                                  'product': product,
                                  'price': potential,
                                  'fileName': item.rawData?['fileName'] ??
                                      'Proposal_Penawaran_$companyName.pdf',
                                  'docId': item.rawData?['docId'] ??
                                      'DOC-20260901-7B1A',
                                  'status': _currentStatus,
                                  'notes': item.desc,
                                },
                              ),
                            ),
                          );
                        } else {
                          // Buka CatatNotulensiScreen dan tangkap hasilnya jika user mengedit notulensi / jadwal follow-up
                          final result =
                              await Navigator.push<Map<String, dynamic>>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CatatNotulensiScreen(
                                scheduleItem: {
                                  'perusahaan': companyName,
                                  'checkInTime': item.rawData?['checkIn'] ??
                                      item.time.split('-').first.trim(),
                                  'checkOutTime': item.rawData?['checkOut'] ??
                                      item.time.split('-').last.trim(),
                                  'alamat': address,
                                  'notulensi': item.desc,
                                  'checkInImg': item.rawData?['checkInImg'] ??
                                      'https://images.unsplash.com/photo-1577495508048-b635879837f1?auto=format&fit=crop&w=500&q=80',
                                  'checkOutImg': item.rawData?['checkOutImg'] ??
                                      'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=500&q=80',
                                },
                              ),
                            ),
                          );

                          if (result != null && mounted) {
                            setState(() {
                              final updatedNotulensi =
                                  (result['notulensi'] as String? ?? '').trim();
                              if (updatedNotulensi.isNotEmpty) {
                                final updatedItem = ActivityItem(
                                  title: item.title,
                                  date: item.date,
                                  time: item.time,
                                  desc: updatedNotulensi,
                                  isCompleted: item.isCompleted,
                                  isOtw: item.isOtw,
                                  type: item.type,
                                  rawData: result,
                                );
                                final idx = _activities.indexOf(item);
                                if (idx != -1) {
                                  _activities[idx] = updatedItem;
                                }
                              }

                              final followUpData = result['followUpData']
                                  as Map<String, dynamic>?;
                              if (followUpData != null) {
                                final jenis =
                                    followUpData['jenis'] ?? 'Kunjungan';
                                final tgl =
                                    followUpData['date'] ?? _todayStr();
                                final jam = followUpData['time'] ?? '10:00';
                                final purpose =
                                    (followUpData['purpose'] as String? ?? '')
                                        .trim();
                                final notes =
                                    (followUpData['notes'] as String? ?? '')
                                        .trim();
                                final desc = purpose.isNotEmpty
                                    ? purpose
                                    : (notes.isNotEmpty
                                        ? notes
                                        : 'Agenda follow-up $jenis');

                                _activities.add(
                                  ActivityItem(
                                    title: 'Follow Up: $jenis',
                                    date: tgl,
                                    time: jam,
                                    desc: desc,
                                    isCompleted: false,
                                    isOtw: true,
                                    type: 'followup',
                                    rawData: followUpData,
                                  ),
                                );
                              }

                              _sortActivities();
                            });
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: _buildActivityCard(item, isProposal),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ── Activity Card dengan dukungan warna OTW ─────────────────────────────────
  Widget _buildActivityCard(ActivityItem item, bool isProposal) {
    final Color bgColor;
    final Color borderColor;
    final Color badgeBg;
    final Color badgeText;
    final String badgeLabel;
    final Color titleColor;

    if (item.isOtw) {
      bgColor = const Color(0xFFFFFDE7);
      borderColor = const Color(0xFFFFB300);
      badgeBg = const Color(0xFFFFB300).withValues(alpha: 0.18);
      badgeText = const Color(0xFFE65100);
      badgeLabel = '🚀 OTW';
      titleColor = const Color(0xFF5D4037);
    } else if (isProposal) {
      bgColor = const Color(0xFFFFF8F8);
      borderColor = const Color(0xFFEF9A9A);
      badgeBg = const Color(0xFFFFEBEE);
      badgeText = const Color(0xFFC62828);
      badgeLabel = 'Proposal';
      titleColor = const Color(0xFF0D2B45);
    } else if (item.isCompleted) {
      bgColor = const Color(0xFFF8FAFC);
      borderColor = const Color(0xFFCBD5E1);
      badgeBg = const Color(0xFFFFF3E0);
      badgeText = const Color(0xFFE65100);
      badgeLabel = 'Selesai ✓';
      titleColor = const Color(0xFF0D2B45);
    } else {
      bgColor = const Color(0xFFF8FAFC);
      borderColor = const Color(0xFFCBD5E1);
      badgeBg = const Color(0xFF0D2B45).withValues(alpha: 0.08);
      badgeText = const Color(0xFF0D2B45);
      badgeLabel = 'Terjadwal';
      titleColor = const Color(0xFF0D2B45);
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: item.isOtw ? 1.5 : 1),
        boxShadow: item.isOtw
            ? [
                BoxShadow(
                  color: const Color(0xFFFFB300).withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.date} • ${item.time}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: item.isOtw
                            ? const Color(0xFFE65100)
                            : (isProposal
                                ? const Color(0xFFD32F2F)
                                : (item.isCompleted
                                    ? const Color(0xFFFF7A00)
                                    : const Color(0xFF8FA1B0))),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(8),
                  border: item.isOtw
                      ? Border.all(color: const Color(0xFFFFB300), width: 1)
                      : null,
                ),
                child: Text(
                  badgeLabel,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: badgeText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.desc,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: item.isOtw ? const Color(0xFF795548) : const Color(0xFF4A6070),
              height: 1.3,
            ),
          ),
          // Notifikasi OTW: belum ada bukti check-in/out
          if (item.isOtw) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB300).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFFFB300).withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.pending_actions_rounded,
                    color: Color(0xFFE65100),
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.type == 'followup'
                          ? 'Menunggu pelaksanaan — belum ada bukti check-in'
                          : 'Belum ada bukti check in-out untuk aktivitas ini',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE65100),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Tombol lihat detail untuk item yang sudah selesai / terjadwal
          if (!item.isOtw) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isProposal
                        ? const Color(0xFFFFEBEE)
                        : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isProposal
                            ? 'Buka & Lihat Proposal'
                            : 'Buka Bukti Check In-Out',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isProposal
                              ? const Color(0xFFC62828)
                              : const Color(0xFFE65100),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 10,
                        color: isProposal
                            ? const Color(0xFFC62828)
                            : const Color(0xFFE65100),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── Outline action button ───────────────────────────────────────────────────
  Widget _outlineActionButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFFF7A00), width: 1.5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF7A00),
          ),
        ),
      ),
    );
  }

  // ── Filled action button ────────────────────────────────────────────────────
  Widget _filledActionButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFF7A00),
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
}

class ActivityItem {
  final String title;
  final String date;
  final String time;
  final String desc;
  final bool isCompleted;
  final bool isOtw; // On The Way: dijadwalkan tapi belum ada bukti check-in/out
  final String type;
  final Map<String, dynamic>? rawData;

  const ActivityItem({
    required this.title,
    required this.date,
    required this.time,
    required this.desc,
    this.isCompleted = true,
    this.isOtw = false,
    this.type = 'general',
    this.rawData,
  });
}
