import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'profile_screen.dart';
import 'prospek_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0; // 0: Home, 1: Leads & CRM, 2: Activity, 3: Sales & Proposal, 4: Report, 5: Profile, 6: Setting
  bool _isSidebarOpen = true;

  final List<Map<String, String>> _sidebarItems = [
    {'label': 'Home', 'svg': 'lib/asset/home.svg'},
    {'label': 'Leads &\nCRM', 'svg': 'lib/asset/crm.svg'},
    {'label': 'Activity', 'svg': 'lib/asset/aktifitas.svg'},
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
                if (_selectedIndex != 5) ...[
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
                    child: _selectedIndex == 5
                        ? const ProfileScreen()
                        : SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //  JADWAL HARI INI
                                _buildJadwalSection(),
                                const SizedBox(height: 20),

                                //  TARGET BULAN INI CARD
                                _buildTargetBulanIniCard(),
                                const SizedBox(height: 20),

                                // STATS CARDS GRID
                                _buildStatsGrid(),
                                const SizedBox(height: 20),

                                // SALES PIPELINE & FORECAST
                                _buildPipelineAndForecastRow(),
                                const SizedBox(height: 20),

                                // PERFORMANCE OVERVIEW
                                _buildPerformanceOverviewCard(),
                                const SizedBox(height: 20),

                                // DEAL SUCCESS & RANKING MARKETING
                                _buildDealSuccessAndRankingRow(),
                                const SizedBox(height: 20),

                                // AKTIVITAS MARKETING CHART
                                _buildAktivitasMarketingCard(),
                              ],
                            ),
                          ),
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

  //  JADWAL HARI INI
  Widget _buildJadwalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jadwal hari ini',
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
                        widthFactor: 2 / 5,
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
                      '2/5',
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
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Lihat semua',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0D2B45),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildScheduleCard(),
        const SizedBox(height: 10),
        _buildScheduleCard(),
        const SizedBox(height: 10),
        _buildScheduleCard(),
      ],
    );
  }

  Widget _buildScheduleCard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tujuan - Bertemu dengan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Tanggal & jam',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alamat',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Link alamat',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E88E5),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Lihat detail >',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D2B45),
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                    children: [
                      const TextSpan(text: 'Rp 850.000.000 '),
                      TextSpan(
                        text: '/ Rp 1.130.000.000',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0D2B45),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0D2B45),
                    ),
                    children: [
                      const TextSpan(text: 'Aktivitas Bulan Ini : '),
                      TextSpan(
                        text: '26 ',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF2E7D32),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: '/ 39'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //  STATS GRID
  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildStatCard('18', 'Prospek Baru', 'New Leads'),
        _buildStatCard('65', 'Prospek Aktif', 'Pipeline'),
        _buildStatCard('9', 'Follow-up Hari Ini', 'Scheduled'),
        _buildStatCard('12', 'Proposal Sent', 'Ongoing'),
      ],
    );
  }

  Widget _buildStatCard(String value, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0D2B45), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9E44),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D2B45),
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
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D2B45),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
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
    return Row(
      children: [
        // Sales Pipeline Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7A00),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sales Pipeline',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D2B45),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp 4.250.000.000',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7A00),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Forecast Penjualan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D2B45),
                      ),
                    ),
                    Text(
                      '96%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D2B45),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.96,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D2B45),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
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
        // Left Solid Orange Card (Deal Success)
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7A00),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deal Success',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D2B45),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Deal Success',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0D2B45),
                  ),
                ),
                Text(
                  '22 Deals',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Divider(color: Color(0xFF0D2B45), height: 20),
                Text(
                  'Deal Lost',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0D2B45),
                  ),
                ),
                Text(
                  '6 Deals',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Right Ranking Marketing Card
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
                    fontSize: 14,
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
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Revenue',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _buildRankingItem(
                  'Nama Marketing 1',
                  'Jabatan',
                  '1',
                  'Rp 358M',
                ),
                _buildRankingItem(
                  'Nama Marketing 2',
                  'Jabatan',
                  '2',
                  'Rp 356M',
                ),
                _buildRankingItem(
                  'Nama Marketing 3',
                  'Jabatan',
                  '3',
                  'Rp 328M',
                ),
                _buildRankingItem('Nama User', 'Jabatan', '9', 'Rp 141M'),
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
    String revenue,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFB0BEC5).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 12,
            backgroundColor: Color(0xFFFFD59E),
            child: Icon(Icons.person, size: 16, color: Color(0xFF6D4C41)),
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
                    color: const Color(0xFF0D2B45),
                  ),
                ),
              ],
            ),
          ),
          Text(
            rank,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D2B45),
            ),
          ),
          const SizedBox(width: 12),
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

  Widget _buildSidebarNavItem({
    required int index,
    required String label,
    required String svgPath,
  }) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        if (index == 1) {
          // Leads & CRM: navigate as full page since ProspekScreen has its own Scaffold
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProspekScreen()),
          );
        } else {
          setState(() => _selectedIndex = index);
        }
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
    path.moveTo(points[2].dx, points[2].dy);
    for (int i = 3; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    // Draw dots
    final dotPaint = Paint()
      ..color = const Color(0xFFFF7A00)
      ..style = PaintingStyle.fill;

    for (int i = 2; i < points.length; i++) {
      canvas.drawCircle(points[i], 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
