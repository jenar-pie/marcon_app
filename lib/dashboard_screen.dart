import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'profile_screen.dart';
import 'prospek_screen.dart';
import 'aktivitas_screen.dart';
import 'checkin_camera_screen.dart';
import 'catat_notulensi_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0; // 0: Home, 1: Leads & CRM, 2: Activities, 3: Sales & Proposal, 4: Report, 5: Profile, 6: Setting
  bool _isSidebarOpen = true;

  final List<Map<String, String>> _sidebarItems = [
    {'label': 'Home', 'svg': 'lib/asset/home.svg'},
    {'label': 'Leads &\nCRM', 'svg': 'lib/asset/crm.svg'},
    {'label': 'Activities', 'svg': 'lib/asset/aktifitas.svg'},
    {'label': 'Sales &\nProposal', 'svg': 'lib/asset/proposal.svg'},
    {'label': 'Report', 'svg': 'lib/asset/report.svg'},
    {'label': 'Profile', 'svg': 'lib/asset/user.svg'},
    {'label': 'Setting', 'svg': 'lib/asset/settings.svg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFFF7A00,
      ), // Vibrant orange header background
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                if (_selectedIndex == 0) ...[
                  // HEADER SECTION
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Avatar + User Info
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFFF0D6),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const ClipOval(
                                  child: Icon(
                                    Icons.person,
                                    size: 36,
                                    color: Color(0xFF6D4C41),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hai, Nama user',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Jabatan marketing | Hari, Tanggal bulan tahun',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Notification Bell Icon with Badge
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(
                              Icons.notifications_none_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                            Positioned(
                              top: -4,
                              left: -6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2E7D32),
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Text(
                                  '2',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // WHITE MAIN CONTENT BODY
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
                    child: _buildMainBodyContent(),
                  ),
                ),
              ],
            ),

            // ANIMATED COLLAPSIBLE SIDEBAR OVERLAY
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              left: _isSidebarOpen ? 0 : -88,
              top: 80,
              child: _buildCollapsibleSideNavigationBar(),
            ),
          ],
        ),
      ),
    );
  }

  String _selectedJadwalFilter = 'Hari ini';
  final List<String> _jadwalFilterOptions = ['Hari ini', 'Mingguan', 'Bulanan'];

  final List<Map<String, dynamic>> _jadwalList = [
    {
      'id': '1',
      'tujuan': 'Tujuan - Bertemu dengan',
      'perusahaan': 'RS Siloam Hospitals',
      'waktu': '08:00 - 09:30',
      'tanggal': 'Hari ini',
      'filterGroup': 'Hari ini',
      'alamat': 'Jl. Garnisun Kav 2-3, Jakarta Selatan',
      'link': 'Buka di Maps',
      'status': 'pending',
      'checkInTime': null,
      'checkOutTime': null,
    },
    {
      'id': '2',
      'tujuan': 'Tujuan - Presentasi Produk',
      'perusahaan': 'RSUP Dr. Cipto Mangunkusumo',
      'waktu': '11:00 - 12:00',
      'tanggal': 'Hari ini',
      'filterGroup': 'Hari ini',
      'alamat': 'Jl. Diponegoro No.71, Jakarta Pusat',
      'link': 'Buka di Maps',
      'status': 'pending',
      'checkInTime': null,
      'checkOutTime': null,
    },
    {
      'id': '3',
      'tujuan': 'Tujuan - Follow Up Proposal',
      'perusahaan': 'RS Pondok Indah Group',
      'waktu': '14:00 - 15:00',
      'tanggal': 'Hari ini',
      'filterGroup': 'Hari ini',
      'alamat': 'Jl. Metro Duta Kav. UE, Jakarta Selatan',
      'link': 'Buka di Maps',
      'status': 'pending',
      'checkInTime': null,
      'checkOutTime': null,
    },
    {
      'id': '4',
      'tujuan': 'Tujuan - Negosiasi Kontrak',
      'perusahaan': 'RS Gading Pluit',
      'waktu': '10:00 - 11:30',
      'tanggal': 'Rabu, 02 Sept',
      'filterGroup': 'Mingguan',
      'alamat': 'Jl. Boulevard Timur, Jakarta Utara',
      'link': 'Buka di Maps',
      'status': 'pending',
      'checkInTime': null,
      'checkOutTime': null,
    },
    {
      'id': '5',
      'tujuan': 'Tujuan - Demo Reagen Baru',
      'perusahaan': 'RS Kanker Dharmais',
      'waktu': '13:00 - 14:30',
      'tanggal': 'Kamis, 03 Sept',
      'filterGroup': 'Mingguan',
      'alamat': 'Jl. Letjen S. Parman No.84, Jakarta Barat',
      'link': 'Buka di Maps',
      'status': 'pending',
      'checkInTime': null,
      'checkOutTime': null,
    },
    {
      'id': '6',
      'tujuan': 'Tujuan - Maintenance & Technical Review',
      'perusahaan': 'RS Medistra',
      'waktu': '09:00 - 10:30',
      'tanggal': 'Jumat, 04 Sept',
      'filterGroup': 'Mingguan',
      'alamat': 'Jl. Jend. Gatot Subroto Kav.59, Jakarta Selatan',
      'link': 'Buka di Maps',
      'status': 'pending',
      'checkInTime': null,
      'checkOutTime': null,
    },
    {
      'id': '7',
      'tujuan': 'Tujuan - Courtesy Visit Direksi',
      'perusahaan': 'RS Mitra Keluarga Kelapa Gading',
      'waktu': '10:00 - 12:00',
      'tanggal': '15 Sept 2026',
      'filterGroup': 'Bulanan',
      'alamat': 'Jl. Raya Gading Kirana, Jakarta Utara',
      'link': 'Buka di Maps',
      'status': 'pending',
      'checkInTime': null,
      'checkOutTime': null,
    },
    {
      'id': '8',
      'tujuan': 'Tujuan - Penandatanganan Kerjasama',
      'perusahaan': 'RS Royal Taruma',
      'waktu': '14:00 - 15:30',
      'tanggal': '22 Sept 2026',
      'filterGroup': 'Bulanan',
      'alamat': 'Jl. Daan Mogot No.34, Jakarta Barat',
      'link': 'Buka di Maps',
      'status': 'pending',
      'checkInTime': null,
      'checkOutTime': null,
    },
  ];

  List<Map<String, dynamic>> get _filteredJadwalList {
    return _jadwalList.where((item) {
      final group = item['filterGroup'] ?? 'Hari ini';
      return group == _selectedJadwalFilter;
    }).toList();
  }

  Future<void> _handleScheduleAction(Map<String, dynamic> item) async {
    final status = item['status'] as String? ?? 'pending';

    if (status == 'completed') {
      await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(
          builder: (context) => CatatNotulensiScreen(scheduleItem: item),
        ),
      );
      setState(() {});
      return;
    }

    final String mode = status == 'pending' ? 'checkin' : 'checkout';

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => CheckInCameraScreen(
          mode: mode,
          companyName: item['perusahaan'] as String,
          purpose: item['tujuan'] as String,
          locationAddress: item['alamat'] as String,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        if (mode == 'checkin') {
          item['status'] = 'ongoing';
          item['checkInTime'] = result['time'];
          item['checkInImg'] = result['photoUrl'];
        } else {
          item['status'] = 'completed';
          item['checkOutTime'] = result['time'];
          item['checkOutImg'] = result['photoUrl'];
        }
      });

      if (!mounted) return;

      if (mode == 'checkout') {
        // Automatically navigate to CatatNotulensiScreen after Check-out
        await Navigator.push<Map<String, dynamic>>(
          context,
          MaterialPageRoute(
            builder: (context) => CatatNotulensiScreen(scheduleItem: item),
          ),
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Check-in berhasil! Kegiatan sedang berlangsung.',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
            ),
            backgroundColor: const Color(0xFF2E7D32),
          ),
        );
      }
    }
  }

  //  JADWAL SECTION WITH FILTER
  Widget _buildJadwalSection() {
    final list = _filteredJadwalList;
    final String titleText = _selectedJadwalFilter == 'Hari ini'
        ? 'Jadwal hari ini'
        : (_selectedJadwalFilter == 'Mingguan'
            ? 'Jadwal mingguan'
            : 'Jadwal bulanan');

    final String progressText = _selectedJadwalFilter == 'Hari ini'
        ? '2/5'
        : (_selectedJadwalFilter == 'Mingguan' ? '8/15' : '24/40');
    final double progressFactor = _selectedJadwalFilter == 'Hari ini'
        ? 2 / 5
        : (_selectedJadwalFilter == 'Mingguan' ? 8 / 15 : 24 / 40);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleText,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D2B45),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 90,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD59E),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progressFactor,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF7A00),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      progressText,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFA88B52),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Dropdown filter for Jadwal: Hari ini, Mingguan, Bulanan
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0D2B45),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D2B45).withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedJadwalFilter,
                  dropdownColor: const Color(0xFF0D2B45),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedJadwalFilter = val);
                    }
                  },
                  items: _jadwalFilterOptions.map((opt) {
                    return DropdownMenuItem<String>(
                      value: opt,
                      child: Text(
                        opt,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (list.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Belum ada jadwal untuk periode ini.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0D2B45),
                ),
              ),
            ),
          )
        else
          ...list.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildScheduleCard(item: item),
            ),
          ),
      ],
    );
  }

  Widget _buildScheduleCard({required Map<String, dynamic> item}) {
    final String status = item['status'] as String? ?? 'pending';
    final String actionText = status == 'pending'
        ? 'Lihat detail >'
        : (status == 'ongoing' ? 'Check out >' : 'Lihat detail >');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFF7A00),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7A00).withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Tujuan + Tanggal/Status & Waktu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${item['tujuan']}\n${item['perusahaan']}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (status == 'ongoing')
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF81C784),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Kegiatan sedang berlangsung',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              else if (status == 'completed')
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B5E20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 11,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Kegiatan selesai',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item['tanggal'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item['waktu'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Row 2: Location + Action button (Lihat detail / Check out)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFD32F2F),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['alamat'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item['link'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFBBDEFB),
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFFBBDEFB),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _handleScheduleAction(item),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: status == 'ongoing'
                      ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  child: Text(
                    actionText,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: status == 'ongoing'
                          ? const Color(0xFF0D2B45)
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TARGET BULAN INI CARD
  Widget _buildTargetBulanIniCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Pie chart
          SizedBox(
            width: 80,
            height: 80,
            child: CustomPaint(painter: _PieChartPainter(percentage: 0.75)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Target Bulan Ini',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D2B45),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp 850.000.000',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D2B45),
                  ),
                ),
                const SizedBox(height: 8),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.75,
                    backgroundColor: const Color(0xFFFFD59E),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF7A00),
                    ),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildTargetChip(
                      label: 'Aktivitas Bulan Ini',
                      value: '26',
                      total: '39',
                    ),
                    const SizedBox(width: 12),
                    _buildTargetChip(
                      label: 'Leads Bulan Ini',
                      value: '12',
                      total: '15',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetChip({
    required String label,
    required String value,
    required String total,
  }) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF0D2B45),
        ),
        children: [
          TextSpan(text: '$label : '),
          TextSpan(
            text: value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E7D32),
            ),
          ),
          TextSpan(text: ' / $total'),
        ],
      ),
    );
  }

  //  STATS GRID
  Widget _buildStatsGrid() {
    final stats = [
      {
        'value': '18',
        'title': 'Prospek Baru',
        'sub': 'New Leads',
        'icon': Icons.person_add_alt_1,
      },
      {
        'value': '65',
        'title': 'Prospek Aktif',
        'sub': 'Pipeline',
        'icon': Icons.show_chart,
      },
      {
        'value': '9',
        'title': 'Follow-up Hari Ini',
        'sub': 'Scheduled',
        'icon': Icons.schedule,
      },
      {
        'value': '12',
        'title': 'Proposal Sent',
        'sub': 'Ongoing',
        'icon': Icons.description_outlined,
      },
    ];
    return GridView.builder(
      itemCount: stats.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) {
        final s = stats[i];
        return _buildStatCard(
          value: s['value'] as String,
          title: s['title'] as String,
          subtitle: s['sub'] as String,
          icon: s['icon'] as IconData,
        );
      },
    );
  }

  Widget _buildStatCard({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0D2B45).withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFFF7A00),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D2B45),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF7A00),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SALES PIPELINE & FORECAST
  Widget _buildPipelineAndForecastRow() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sales Pipeline Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF7A00),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF7A00).withValues(alpha: 0.30),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sales Pipeline',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp 4.250.000.000',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '65 Deals Aktif',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Forecast Penjualan Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF7A00),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF7A00).withValues(alpha: 0.30),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Forecast Penjualan',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0D2B45),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D2B45),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '96%',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      value: 0.96,
                      backgroundColor: Colors.white.withValues(alpha: 0.4),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF0D2B45),
                      ),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp 1.085M',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Rp 1.130M',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // PERFORMANCE OVERVIEW
  Widget _buildPerformanceOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Overview',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D2B45),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 12, height: 12, color: const Color(0xFF0D2B45)),
              const SizedBox(width: 6),
              Text(
                'Target',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0D2B45),
                ),
              ),
              const SizedBox(width: 20),
              Container(width: 12, height: 12, color: const Color(0xFFFF7A00)),
              const SizedBox(width: 6),
              Text(
                'Realisasi',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0D2B45),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: CustomPaint(
              size: const Size(double.infinity, 160),
              painter: _BarChartPainter(),
            ),
          ),
        ],
      ),
    );
  }

  //  DEAL SUCCESS & RANKING MARKETING
  Widget _buildDealSuccessAndRankingRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Card – Deal Success
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7A00),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF7A00).withValues(alpha: 0.30),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deal Success',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D2B45),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Deal Success',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                Text(
                  '22 Deals',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: Color(0xFF0D2B45), height: 1),
                ),
                Text(
                  'Deal Lost',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                Text(
                  '6 Deals',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Right Card – Ranking Marketing
        Expanded(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE9ECEF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ranking Marketing',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D2B45),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Rank',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Revenue',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _buildRankingItem(
                  'Siti Rahayu',
                  'Marketing Executive',
                  '1',
                  'Rp 358M',
                  isTop: true,
                ),
                _buildRankingItem(
                  'Budi Santoso',
                  'Senior Marketing',
                  '2',
                  'Rp 356M',
                ),
                _buildRankingItem(
                  'Dewi Lestari',
                  'Marketing Analyst',
                  '3',
                  'Rp 328M',
                ),
                _buildRankingItem(
                  'Nama User',
                  'Marketing Staff',
                  '9',
                  'Rp 141M',
                  isMe: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankingItem(
    String name,
    String role,
    String rank,
    String revenue, {
    bool isTop = false,
    bool isMe = false,
  }) {
    final bgColor = isMe
        ? const Color(0xFFFF7A00).withValues(alpha: 0.15)
        : const Color(0xFFB0BEC5).withValues(alpha: 0.45);
    final rankColor = isTop ? const Color(0xFFFF7A00) : const Color(0xFF0D2B45);
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: isMe
                ? const Color(0xFFFF7A00)
                : const Color(0xFFFFD59E),
            child: Icon(
              Icons.person,
              size: 16,
              color: isMe ? Colors.white : const Color(0xFF6D4C41),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D2B45),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  role,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 8,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            rank,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: rankColor,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            revenue,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D2B45),
            ),
          ),
        ],
      ),
    );
  }

  // 7. AKTIVITAS MARKETING CHART
  Widget _buildAktivitasMarketingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aktivitas Marketing',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D2B45),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: CustomPaint(
              size: const Size(double.infinity, 140),
              painter: _LineChartPainter(),
            ),
          ),
        ],
      ),
    );
  }

  // SIDEBAR NAVIGATION BAR
  Widget _buildCollapsibleSideNavigationBar() {
    final double maxSidebarHeight = MediaQuery.of(context).size.height - 100;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 88,
          constraints: BoxConstraints(maxHeight: maxSidebarHeight),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFFFF9E44),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(44),
              bottomRight: Radius.circular(44),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_sidebarItems.length, (index) {
                final item = _sidebarItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: _buildSidebarNavItem(
                    index: index,
                    label: item['label']!,
                    svgPath: item['svg']!,
                  ),
                );
              }),
            ),
          ),
        ),

        // Arrow Handle Button
        GestureDetector(
          onTap: () {
            setState(() {
              _isSidebarOpen = !_isSidebarOpen;
            });
          },
          child: Container(
            width: 32,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFE88226),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Icon(
                _isSidebarOpen
                    ? Icons.keyboard_double_arrow_left
                    : Icons.keyboard_double_arrow_right,
                color: const Color(0xFF0D2B45),
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainBodyContent() {
    switch (_selectedIndex) {
      case 1:
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          child: ProspekScreen(
            onBack: () => setState(() => _selectedIndex = 0),
          ),
        );
      case 2:
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          child: AktivitasScreen(
            onBack: () => setState(() => _selectedIndex = 0),
          ),
        );
      case 5:
        return const ProfileScreen();
      case 0:
      default:
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. JADWAL HARI INI
              _buildJadwalSection(),
              const SizedBox(height: 20),

              // 2. TARGET BULAN INI CARD
              _buildTargetBulanIniCard(),
              const SizedBox(height: 20),

              // 3. STATS CARDS GRID
              _buildStatsGrid(),
              const SizedBox(height: 20),

              // 4. SALES PIPELINE & FORECAST
              _buildPipelineAndForecastRow(),
              const SizedBox(height: 20),

              // 5. PERFORMANCE OVERVIEW
              _buildPerformanceOverviewCard(),
              const SizedBox(height: 20),

              // 6. DEAL SUCCESS & RANKING MARKETING
              _buildDealSuccessAndRankingRow(),
              const SizedBox(height: 20),

              // 7. AKTIVITAS MARKETING CHART
              _buildAktivitasMarketingCard(),
            ],
          ),
        );
    }
  }

  Widget _buildSidebarNavItem({
    required int index,
    required String label,
    required String svgPath,
  }) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSelected ? 44 : 36,
            height: isSelected ? 44 : 36,
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                svgPath,
                width: 22,
                height: 22,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF0D2B45),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: const Color(0xFF0D2B45),
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

// CUSTOM PAINTERS FOR CHARTS

class _PieChartPainter extends CustomPainter {
  final double percentage;

  _PieChartPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    final paintNavy = Paint()
      ..color = const Color(0xFF0D2B45)
      ..style = PaintingStyle.fill;

    final paintOrange = Paint()
      ..color = const Color(0xFFFF7A00)
      ..style = PaintingStyle.fill;

    // Background circle (Navy)
    canvas.drawCircle(center, radius, paintNavy);

    // Orange Slice
    double sweepAngle = 2 * pi * percentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      true,
      paintOrange,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BarChartPainter extends CustomPainter {
  final List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Nov',
    'Des',
  ];
  final List<double> targets = [100, 125, 122, 145, 113, 113, 79, 140, 155];
  final List<double> realisations = [80, 100, 95, 125, 90, 90, 40, 120, 100];

  @override
  void paint(Canvas canvas, Size size) {
    final double leftPadding = 35;
    final double bottomPadding = 25;
    final double chartWidth = size.width - leftPadding;
    final double chartHeight = size.height - bottomPadding;

    final linePaint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 1;

    final textStyle = TextStyle(color: Colors.grey[700], fontSize: 9);

    // Draw y-axis labels and grid lines (0, 50, 100, 150, 200)
    final yLabels = [0, 50, 100, 150, 200];
    for (int i = 0; i < yLabels.length; i++) {
      double yVal = yLabels[i].toDouble();
      double yPos = chartHeight - (yVal / 200 * chartHeight);

      TextPainter tp = TextPainter(
        text: TextSpan(text: '${yLabels[i]}', style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(leftPadding - tp.width - 5, yPos - tp.height / 2),
      );

      canvas.drawLine(
        Offset(leftPadding, yPos),
        Offset(size.width, yPos),
        linePaint,
      );
    }

    // Draw Bars
    double groupWidth = chartWidth / months.length;
    double barWidth = 6;

    final navyPaint = Paint()..color = const Color(0xFF0D2B45);
    final orangePaint = Paint()..color = const Color(0xFFFF7A00);

    for (int i = 0; i < months.length; i++) {
      double groupLeft = leftPadding + i * groupWidth;
      double centerX = groupLeft + groupWidth / 2;

      double targetH = (targets[i] / 200) * chartHeight;
      double realH = (realisations[i] / 200) * chartHeight;

      // Target bar (Navy)
      canvas.drawRect(
        Rect.fromLTWH(
          centerX - barWidth - 1,
          chartHeight - targetH,
          barWidth,
          targetH,
        ),
        navyPaint,
      );

      // Realisation bar (Orange)
      canvas.drawRect(
        Rect.fromLTWH(centerX + 1, chartHeight - realH, barWidth, realH),
        orangePaint,
      );

      // Month Label
      TextPainter tp = TextPainter(
        text: TextSpan(text: months[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(centerX - tp.width / 2, chartHeight + 6));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LineChartPainter extends CustomPainter {
  final List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Nov',
    'Des',
  ];
  final List<double> values = [10, 10, 15, 17, 25, 20, 18, 25, 29];

  @override
  void paint(Canvas canvas, Size size) {
    final double leftPadding = 30;
    final double bottomPadding = 25;
    final double chartWidth = size.width - leftPadding;
    final double chartHeight = size.height - bottomPadding;

    final gridPaint = Paint()
      ..color = Colors.grey[350]!
      ..strokeWidth = 1;

    final textStyle = TextStyle(color: Colors.grey[700], fontSize: 9);

    // Y Grid lines (10, 15, 20, 25, 30)
    final yValues = [10, 15, 20, 25, 30];
    for (var val in yValues) {
      double yPos = chartHeight - ((val - 10) / 20 * chartHeight);
      TextPainter tp = TextPainter(
        text: TextSpan(text: '$val', style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(leftPadding - tp.width - 5, yPos - tp.height / 2),
      );

      canvas.drawLine(
        Offset(leftPadding, yPos),
        Offset(size.width, yPos),
        gridPaint,
      );
    }

    double stepX = chartWidth / (months.length - 1);
    List<Offset> points = [];

    for (int i = 0; i < months.length; i++) {
      double x = leftPadding + i * stepX;
      double y = chartHeight - ((values[i] - 10) / 20 * chartHeight);
      points.add(Offset(x, y));

      TextPainter tp = TextPainter(
        text: TextSpan(text: months[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, chartHeight + 6));
    }

    // Draw connecting line
    final linePaint = Paint()
      ..color = const Color(0xFFFF7A00)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Path path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, linePaint);
    }

    // Draw dots
    final dotPaint = Paint()
      ..color = const Color(0xFFFF7A00)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
