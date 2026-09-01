import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'catat_kontak_screen.dart';
import 'detail_prospek_screen.dart';
import 'lihat_riwayat_log_screen.dart';

class AktivitasScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const AktivitasScreen({super.key, this.onBack});

  @override
  State<AktivitasScreen> createState() => _AktivitasScreenState();
}

class _AktivitasScreenState extends State<AktivitasScreen> {
  int _selectedTab = 1; // 0: Hari ini, 1: Minggu ini, 2: Bulan ini

  // Data dictionary for each tab to make it interactive and dynamic
  final List<Map<String, dynamic>> _tabData = [
    {
      // Hari ini
      'rencana': 4,
      'realisasi': 2,
      'pendingDesc': '2 aktivitas terjadwal belum dikerjakan hari ini',
      'efektivitas': [
        {'label': 'Kunjungan', 'realisasi': 1, 'rencana': 1},
        {'label': 'Meeting', 'realisasi': 1, 'rencana': 2},
        {'label': 'Telepon', 'realisasi': 0, 'rencana': 1},
        {'label': 'Presentasi', 'realisasi': 0, 'rencana': 0},
      ],
      'infoNote': 'Kunjungan hari ini sukses dilakukan, pastikan untuk menindaklanjuti tele-marketing sebelum jam kerja berakhir.',
      'tren': [
        2,
        1,
        0,
        3,
        2,
        0,
        2,
      ], // Values for Sen, Sel, Rab, Kam, Jum, Sab, Min
      'trenTarget': [3, 2, 2, 4, 3, 1, 3],
      'trenCaption':
          'Rata-rata 2.0 aktivitas/hari. Hari rabu & sabtu paling sepi',
    },
    {
      // Minggu ini
      'rencana': 12,
      'realisasi': 9,
      'pendingDesc': '3 aktivitas terjadwal belum dikerjakan minggu ini',
      'efektivitas': [
        {'label': 'Kunjungan', 'realisasi': 3, 'rencana': 4},
        {'label': 'Meeting', 'realisasi': 2, 'rencana': 3},
        {'label': 'Telepon', 'realisasi': 1, 'rencana': 3},
        {'label': 'Presentasi', 'realisasi': 2, 'rencana': 2},
      ],
      'infoNote': 'Telepon paling sering dilakukan tapi paling rendah efektivitasnya - Coba cek kembali kualitas pembukaan percakapan',
      'tren': [4, 5, 2, 8, 6, 1, 7],
      'trenTarget': [6, 7, 4, 9, 7, 5, 8],
      'trenCaption': 'Rata-rata 3.5 aktivitas/hari. Hari sabtu paling sepi',
    },
    {
      // Bulan ini
      'rencana': 50,
      'realisasi': 38,
      'pendingDesc': '12 aktivitas terjadwal belum dikerjakan bulan ini',
      'efektivitas': [
        {'label': 'Kunjungan', 'realisasi': 11, 'rencana': 15},
        {'label': 'Meeting', 'realisasi': 9, 'rencana': 12},
        {'label': 'Telepon', 'realisasi': 8, 'rencana': 13},
        {'label': 'Presentasi', 'realisasi': 10, 'rencana': 10},
      ],
      'infoNote': 'Efektivitas keseluruhan bulan ini sangat baik (76%). Tingkatkan volume telepon untuk menambah prospek baru.',
      'tren': [7, 8, 5, 9, 6, 2, 8],
      'trenTarget': [9, 10, 7, 10, 8, 6, 9],
      'trenCaption': 'Rata-rata 6.5 aktivitas/hari. Hari sabtu paling sepi',
    },
  ];

  // Activities yang tertahan (stuck activities)
  final List<Map<String, dynamic>> _aktivitasTertahan = [
    {
      'company': 'PT Kimia Farma Tbk',
      'desc': 'Telepon 5 hari lalu, Tidak ada next action',
      'isLead': true,
      'leadData': {
        'company': 'PT Kimia Farma Tbk',
        'name': 'PT Kimia Farma Tbk',
        'contactName': 'Dr. Andi Wijaya',
        'phone': '0811-2222-3333',
        'address': 'Jl. Veteran No. 9, Jakarta',
        'status': 'Lead Baru',
        'potensi': 'Rp 150.000.000',
        'source': 'Website',
        'product': 'Layanan Medis Utama (Core Medical Services)',
        'date': '24 Agu 2026',
        'pic': 'Bertemu dengan - Dr. Andi Wijaya',
      },
    },
    {
      'company': 'BPJS Kesehatan Jakarta',
      'desc': 'Deskripsi: Sudah meeting tapi proposal penawaran belum dikirim',
      'isLead': false,
      'prospectData': {
        'company': 'BPJS Kesehatan Jakarta',
        'name': 'BPJS Kesehatan Jakarta',
        'contactName': 'Ibu Rina Lestari',
        'phone': '0812-3456-7890',
        'address': 'Jl. Letjen Suprapto, Cempaka Putih',
        'status': 'Pipeline',
        'potensi': 'Rp 450.000.000',
        'source': 'Referral',
        'product': 'Layanan Pemeriksaan & Diagnosis (Diagnostic & Laboratory)',
        'date': '22 Agu 2026',
        'pic': 'Bertemu dengan - Ibu Rina Lestari',
      },
    },
  ];

  Color _getProgressColor(double pct) {
    if (pct < 0.50) return const Color(0xFFD32F2F); // Red
    if (pct <= 0.55) return const Color(0xFFFBC02D); // Yellow
    return const Color(0xFF2E7D32); // Green
  }

  void _tindakLanjuti(Map<String, dynamic> item) {
    if (item['isLead'] == true) {
      // Navigate to CatatKontakScreen passing leadData
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CatatKontakScreen(
            leadData: item['leadData'] as Map<String, dynamic>,
          ),
        ),
      );
    } else {
      // Navigate to DetailProspekScreen passing prospectData
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailProspekScreen(
            data: item['prospectData'] as Map<String, dynamic>,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentData = _tabData[_selectedTab];
    final int rencana = currentData['rencana'] as int;
    final int realisasi = currentData['realisasi'] as int;
    final double percentage = rencana > 0 ? (realisasi / rencana) : 0.0;
    final String pctText = '${(percentage * 100).toStringAsFixed(0)}%';

    return Scaffold(
      backgroundColor: const Color(0xFFFF7A00), // Primary Orange Header
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── 1. HEADER APP BAR ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        if (widget.onBack != null) {
                          widget.onBack!();
                        } else {
                          Navigator.maybePop(context);
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 22,
                          color: Color(0xFF0D2B45), // Navy back icon
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Activity',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                ],
              ),
            ),

            // ── 2. WHITE CONTAINER CONTENT BODY ────────────────────────────
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(
                    0xFFF3F6F8,
                  ), // Soft grey-blue background matching mockup
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Tab selector ──
                      _buildTabSelector(),
                      const SizedBox(height: 20),

                      // ── Rencana vs Realisasi Card ──
                      _buildRencanaRealisasiCard(
                        realisasi,
                        rencana,
                        percentage,
                        pctText,
                        currentData['pendingDesc'] as String,
                      ),
                      const SizedBox(height: 20),

                      // ── Efektivitas per Jenis Aktivitas Card ──
                      _buildEfektivitasCard(
                        currentData['efektivitas']
                            as List<Map<String, dynamic>>,
                        currentData['infoNote'] as String,
                      ),
                      const SizedBox(height: 20),

                      // ── Aktivitas Yang Tertahan Card ──
                      _buildAktivitasTertahanSection(),
                      const SizedBox(height: 20),

                      // ── Tren Tujuh Hari Terakhir Card ──
                      _buildTrenCard(
                        currentData['tren'] as List<int>,
                        currentData['trenTarget'] as List<int>,
                        currentData['trenCaption'] as String,
                      ),
                      const SizedBox(height: 20),

                      // ── Riwayat Aktivitas Terbaru Card ──
                      _buildRiwayatAktivitasTerbaruSection(),
                      const SizedBox(height: 24),

                      // ── Lihat Riwayat Button ──
                      _buildLihatRiwayatButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFECE0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildTabButton(0, 'Hari ini'),
          _buildTabButton(1, 'Minggu ini'),
          _buildTabButton(2, 'Bulan ini'),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF9E44) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFFFF7A00),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRencanaRealisasiCard(
    int realisasi,
    int rencana,
    double percentage,
    String pctText,
    String pendingDesc,
  ) {
    final progressColor = _getProgressColor(percentage);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB8C7D3)
            .withValues(alpha: 0.6), // Translucent grey-blue card container
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rencana Vs Realisasi',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D2B45),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$realisasi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                  Text(
                    ' / $rencana Direncanakan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0D2B45).withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              Text(
                pctText,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D2B45),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 10,
              width: double.infinity,
              color: Colors.white,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage.clamp(0.0, 1.0),
                child: Container(color: progressColor),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            pendingDesc,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0D2B45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEfektivitasCard(
    List<Map<String, dynamic>> efektivitas,
    String infoNote,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB8C7D3).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Efektivitas per Jenis Aktivitas',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D2B45),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Presentase aktivitas yang berhasil mendorong prospek ke tahap berikutnya',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B8BA4),
            ),
          ),
          const SizedBox(height: 16),
          ...efektivitas.map((item) {
            final int real = item['realisasi'] as int;
            final int renc = item['rencana'] as int;
            final double pct = renc > 0 ? (real / renc) : 0.0;
            final String pctStr = '${(pct * 100).toStringAsFixed(0)}%';
            final color = _getProgressColor(pct);

            // Hide items that have 0 target rencana
            if (renc == 0) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['label'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0D2B45),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '$real dari $renc',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF6B8BA4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            pctStr,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0D2B45),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 8,
                      width: double.infinity,
                      color: Colors.white,
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: pct.clamp(0.0, 1.0),
                        child: Container(color: color),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 4),
          // Yellow Tip Note Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE89E4E).withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: Color(0xFF0D2B45),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    infoNote,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAktivitasTertahanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 10.0),
          child: Text(
            'Aktivitas Yang Tertahan',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D2B45),
            ),
          ),
        ),
        ..._aktivitasTertahan.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7A00), // Vibrant Orange
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['company'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['desc'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _tindakLanjuti(item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D2B45), // Navy Button
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Tindak Lanjuti',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTrenCard(
    List<int> actualValues,
    List<int> targetValues,
    String captionText,
  ) {
    final List<String> days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    // Find max value to normalize bar heights
    int maxVal = 1;
    for (var v in targetValues) {
      if (v > maxVal) maxVal = v;
    }
    for (var v in actualValues) {
      if (v > maxVal) maxVal = v;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tren Tujuh Hari Terakhir',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D2B45),
            ),
          ),
          const SizedBox(height: 24),
          // Chart bar row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (i) {
              final double targetHeight = (targetValues[i] / maxVal) * 70.0;
              final double actualHeight = (actualValues[i] / maxVal) * 70.0;

              return Column(
                children: [
                  SizedBox(
                    height: 70,
                    width: 22,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Target Bar (Light Grey)
                        Container(
                          height: targetHeight.clamp(4.0, 70.0),
                          width: 14,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        // Realisation Bar (Navy Blue)
                        Container(
                          height: actualHeight.clamp(2.0, 70.0),
                          width: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D2B45),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    days[i],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B8BA4),
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),
          // Caption label
          Center(
            child: Text(
              captionText,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D2B45).withValues(alpha: 0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatAktivitasTerbaruSection() {
    final recentList = LihatRiwayatLogScreen.globalActivities.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.history_rounded, color: Color(0xFFFF7A00), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Riwayat Aktivitas Terbaru',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LihatRiwayatLogScreen(),
                    ),
                  );
                  setState(() {});
                },
                child: Text(
                  'Lihat Semua',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF7A00),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (recentList.isEmpty)
            Center(
              child: Text(
                'Belum ada riwayat aktivitas',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            )
          else
            Column(
              children: recentList.map((item) {
                final String jenis = item['jenis']?.toString() ?? 'Aktivitas';
                final String customer = item['customer']?.toString() ?? 'Customer';
                final String waktu = item['waktu']?.toString() ?? '-';
                final String nextAct = item['nextAction']?.toString() ?? 'Follow up';
                final String notulensi = item['notulensi']?.toString() ?? '';

                Color badgeColor;
                IconData badgeIcon;
                switch (jenis.toLowerCase()) {
                  case 'kunjungan':
                    badgeColor = const Color(0xFFFF7A00);
                    badgeIcon = Icons.location_on_rounded;
                    break;
                  case 'telepon':
                    badgeColor = const Color(0xFF1976D2);
                    badgeIcon = Icons.phone_in_talk_rounded;
                    break;
                  case 'whatsapp':
                    badgeColor = const Color(0xFF2E7D32);
                    badgeIcon = Icons.chat_rounded;
                    break;
                  case 'meeting':
                    badgeColor = const Color(0xFF7B1FA2);
                    badgeIcon = Icons.groups_rounded;
                    break;
                  default:
                    badgeColor = const Color(0xFFE65100);
                    badgeIcon = Icons.assignment_rounded;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(badgeIcon, color: badgeColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    customer,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0D2B45),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  waktu,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              notulensi.isNotEmpty ? notulensi : 'Catatan aktivitas',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: const Color(0xFF475569),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Next Action: $nextAct',
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
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildLihatRiwayatButton() {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LihatRiwayatLogScreen(),
          ),
        );
        setState(() {});
      },
      child: Container(
        width: double.infinity,
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
            'Lihat Riwayat & Log Lengkap',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
