import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'buat_proposal_screen.dart';
import 'jadwalkan_follow_up_screen.dart';
import 'tambah_aktivitas_screen.dart';

class DetailProspekScreen extends StatefulWidget {
  final Map<String, dynamic>? data;

  const DetailProspekScreen({super.key, this.data});

  @override
  State<DetailProspekScreen> createState() => _DetailProspekScreenState();
}

class _DetailProspekScreenState extends State<DetailProspekScreen> {
  late List<_ActivityItem> _activities;
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    final entryDate = widget.data?['date'] ?? '16 Jan 2026';
    _currentStatus = widget.data?['status'] ?? 'Pipeline';

    // Activity timeline ordered from top to bottom (chronological)
    // Completed activities have isCompleted = true (Orange filled)
    // Upcoming / pending follow-up schedules have isCompleted = false (White/grey outline)
    _activities = [
      _ActivityItem(
        title: 'Data Masuk',
        date: entryDate,
        time: '09:00',
        desc: 'Prospek berhasil didaftarkan ke sistem Lokativa CRM',
        isCompleted: true,
      ),
      _ActivityItem(
        title: 'Contact & Call',
        date: entryDate,
        time: '11:30',
        desc: 'Menghubungi PIC untuk konfirmasi kebutuhan awal & profil',
        isCompleted: true,
      ),
      _ActivityItem(
        title: 'Meeting & Presentasi',
        date: entryDate,
        time: '14:00',
        desc: 'Presentasi proposal solusi dan penjelasan fitur produk',
        isCompleted: true,
      ),
    ];
  }

  Future<void> _openTambahAktivitas() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => const TambahAktivitasScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        // Tambah aktivitas yang sudah dilakukan (isCompleted: true -> Oranye)
        _activities.add(
          _ActivityItem(
            title: result['jenis'] ?? 'Aktivitas Baru',
            date: result['date'] ?? '23/08/2026',
            time: result['time'] ?? '10:00',
            desc: result['desc'] ?? 'Aktivitas berhasil dicatat',
            isCompleted: true,
          ),
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aktivitas baru berhasil dicatat dan masuk timeline!'),
            backgroundColor: Color(0xFF0D2B45),
          ),
        );
      }
    }
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
      setState(() {
        // Jadwalkan follow-up masa depan (isCompleted: false -> Belum berwarna oranye)
        _activities.add(
          _ActivityItem(
            title: result['title'] ?? 'Jadwal Follow-Up',
            date: result['date'] ?? '26/08/2026',
            time: result['time'] ?? '10:00',
            desc: result['desc'] ?? 'Agenda follow-up mendatang',
            isCompleted: false, // FALSE: Belum dikerjakan -> Tidak berwarna oranye
          ),
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Jadwal follow-up tanggal ${result['date']} berhasil diagendakan ke timeline!',
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
            const _ActivityItem(
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
            const _ActivityItem(
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
            const _ActivityItem(
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
    final product = data?['product'] ?? 'SaaS Lokativa CRM';
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
                          _infoRow('Tanggal masuk', entryDate),
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

  // ── Flowing Timeline (Orange if Completed, Outline/Grey if Pending) ─────────
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
              // Timeline icon dot & connecting line
              Column(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.isCompleted
                          ? const Color(0xFFFF7A00) // SUDAH DIKERJAKAN: ORANGE
                          : Colors.white, // BELUM DIKERJAKAN: PUTIH OUTLINE
                      border: item.isCompleted
                          ? null
                          : Border.all(
                              color: const Color(0xFF0D2B45),
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
                        item.isCompleted
                            ? Icons.check
                            : Icons.schedule_rounded,
                        size: 15,
                        color: item.isCompleted
                            ? Colors.white
                            : const Color(0xFF0D2B45),
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

              // Activity content
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
                                color: const Color(0xFF0D2B45),
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
                          color: const Color(0xFF4A6070),
                          height: 1.3,
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

class _ActivityItem {
  final String title;
  final String date;
  final String time;
  final String desc;
  final bool isCompleted;

  const _ActivityItem({
    required this.title,
    required this.date,
    required this.time,
    required this.desc,
    this.isCompleted = true,
  });
}
