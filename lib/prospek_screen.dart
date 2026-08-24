import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'detail_prospek_screen.dart';
import 'tambah_data_screen.dart';

class ProspekScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final int initialTab; // 0: Leads, 1: List Prospek, 2: Kanban

  const ProspekScreen({
    super.key,
    this.onBack,
    this.initialTab = 1, // Default to 1 (List Prospek) as requested
  });

  @override
  State<ProspekScreen> createState() => _ProspekScreenState();
}

class _ProspekScreenState extends State<ProspekScreen> {
  late int _selectedTab;
  final TextEditingController _searchController = TextEditingController();

  // Data for List Prospek (Orange Cards)
  final List<Map<String, dynamic>> _prospekList = [
    {
      'company': 'PT Telekomunikasi Indonesia',
      'pic': 'Bertemu dengan - Manajer IT',
      'contactName': 'Ir. Hendra Gunawan',
      'phone': '0811-2233-4455',
      'address': 'Jl. Gatot Subroto No. 52, Jakarta Selatan',
      'potensi': 'Rp 85.000.000',
      'status': 'Pipeline',
      'source': 'Corporate Inbound',
      'product': 'Lokativa Enterprise CRM',
      'date': '18 Feb 2026',
    },
    {
      'company': 'CV Sentosa Abadi Jaya',
      'pic': 'Bertemu dengan - Procurement Lead',
      'contactName': 'Siti Rahmawati',
      'phone': '0821-9988-7766',
      'address': 'Kawasan Industri MM2100, Cikarang',
      'potensi': 'Rp 35.000.000',
      'status': 'Pipeline',
      'source': 'Pameran Expo Industri',
      'product': 'Lokativa Pro Plan',
      'date': '20 Feb 2026',
    },
    {
      'company': 'PT Digital Mega Pratama',
      'pic': 'Bertemu dengan - Direktur Operasional',
      'contactName': 'Agus Supriyadi',
      'phone': '0857-4433-2211',
      'address': 'Jl. Asia Afrika No. 10, Bandung',
      'potensi': 'Rp 50.000.000',
      'status': 'Meeting',
      'source': 'Referral Mitra',
      'product': 'Lokativa Custom CRM',
      'date': '21 Feb 2026',
    },
    {
      'company': 'PT Nusantara Logistik Makmur',
      'pic': 'Bertemu dengan - General Manager',
      'contactName': 'Dimas Anggara',
      'phone': '0878-1122-3344',
      'address': 'Jl. Pemuda No. 88, Surabaya',
      'potensi': 'Rp 120.000.000',
      'status': 'Meeting',
      'source': 'Website Leads',
      'product': 'Lokativa Fleet & CRM',
      'date': '22 Feb 2026',
    },
  ];

  // Data for Leads Tab (Matching Orange Card Style)
  final List<Map<String, dynamic>> _leadsList = [
    {
      'company': 'PT Maju Bersama Logistik',
      'name': 'PT Maju Bersama Logistik',
      'role': 'Purchasing Manager',
      'pic': 'Purchasing Manager',
      'contactName': 'Budi Santoso',
      'phone': '0812-3456-7890',
      'address': 'Jl. Daan Mogot Km. 14, Jakarta Barat',
      'status': 'Lead Baru',
      'potensi': 'Rp 15.000.000',
      'source': 'Website Form',
      'product': 'Lokativa Basic Plan',
      'date': '22 Feb 2026',
    },
    {
      'company': 'CV Surya Kencana Abadi',
      'name': 'CV Surya Kencana Abadi',
      'role': 'Direktur Operasional',
      'pic': 'Direktur Operasional',
      'contactName': 'Dewi Lestari',
      'phone': '0813-9876-5432',
      'address': 'Jl. Ahmad Yani No. 45, Bekasi',
      'status': 'Follow Up',
      'potensi': 'Rp 28.000.000',
      'source': 'LinkedIn Outreach',
      'product': 'Lokativa Business Plan',
      'date': '21 Feb 2026',
    },
    {
      'company': 'Toko Bangunan Sejahtera',
      'name': 'Toko Bangunan Sejahtera',
      'role': 'Owner / Pemilik',
      'pic': 'Owner / Pemilik',
      'contactName': 'Hendra Wijaya',
      'phone': '0857-1122-3344',
      'address': 'Jl. Raya Bogor Km. 28, Depok',
      'status': 'Lead Baru',
      'potensi': 'Rp 10.000.000',
      'source': 'Direct Call',
      'product': 'Lokativa Retail CRM',
      'date': '20 Feb 2026',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  Future<void> _openTambahData() async {
    final defaultCat = _selectedTab == 0 ? 'Leads' : 'Prospek';

    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => TambahDataScreen(initialCategory: defaultCat),
      ),
    );

    if (result != null) {
      setState(() {
        if (result['category'] == 'Prospek') {
          _prospekList.insert(0, {
            'company': result['company'],
            'name': result['company'],
            'pic': 'Bertemu dengan - ${result['pic']}',
            'role': result['pic'],
            'contactName': result['contactName'],
            'phone': result['phone'],
            'address': result['address'],
            'potensi': result['potential'],
            'status': 'Pipeline',
            'source': 'Manual Input',
            'product': 'Lokativa Solution',
            'date': result['date'] ?? '23 Agu 2026',
          });
          _selectedTab = 1; // Direct to List Prospek
        } else {
          _leadsList.insert(0, {
            'company': result['company'],
            'name': result['company'],
            'role': result['pic'],
            'pic': result['pic'],
            'contactName': result['contactName'],
            'phone': result['phone'],
            'address': result['address'],
            'status': 'Lead Baru',
            'potensi': result['potential'],
            'source': 'Manual Input',
            'product': 'Lokativa Solution',
            'date': result['date'] ?? '23 Agu 2026',
          });
          _selectedTab = 0; // Direct to Leads
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${result['category']} "${result['company']}" berhasil ditambahkan!',
            ),
            backgroundColor: const Color(0xFF0D2B45),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF7A00), // Vibrant Orange Header
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── 1. HEADER SECTION (Orange Background) ────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              child: Column(
                children: [
                  // Back Arrow + Title "Leads & CRM"
                  Stack(
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
                        'Leads & CRM',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0D2B45),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Search Field + "+ Baru" Button Row
                  Row(
                    children: [
                      // White Search Field Pill
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: const Color(0xFF0D2B45),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Cari Perusahaan atau PIC',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: Colors.grey[400],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // "+ Baru" Button (Dark Navy)
                      GestureDetector(
                        onTap: _openTambahData,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D2B45),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Baru',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── 2. MAIN WHITE CONTENT CONTAINER ──────────────────────────────
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

                          // Tab Bar + Card Content
                          Column(
                            children: [
                              const SizedBox(height: 12),

                              // 3-Tab Switcher Pill (Leads | List Prospek | Kanban)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: Container(
                                  height: 46,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECC49E), // Peach Pill
                                    borderRadius: BorderRadius.circular(23),
                                  ),
                                  child: Row(
                                    children: [
                                      // Tab 0: "Leads"
                                      _buildTabItem(title: 'Leads', index: 0),

                                      // Tab 1: "List Prospek"
                                      _buildTabItem(
                                        title: 'List Prospek',
                                        index: 1,
                                      ),

                                      // Tab 2: "Kanban"
                                      _buildTabItem(title: 'Kanban', index: 2),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Dynamic View per Tab
                              Expanded(
                                child: IndexedStack(
                                  index: _selectedTab,
                                  children: [
                                    _buildLeadsView(),
                                    _buildProspekCardList(),
                                    _buildKanbanView(),
                                  ],
                                ),
                              ),
                            ],
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

  // ── TAB BUTTON HELPER ──────────────────────────────────────────────────────
  Widget _buildTabItem({required String title, required int index}) {
    final bool isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF2994A) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? Border.all(
                    color: const Color(0xFFE28B38).withValues(alpha: 0.5),
                    width: 1,
                  )
                : null,
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── 1. LIST PROSPEK VIEW (MATCHING SCREENSHOT) ─────────────────────────────
  Widget _buildProspekCardList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      itemCount: _prospekList.length,
      itemBuilder: (context, index) {
        final item = _prospekList[index];
        return _buildSingleProspekCard(item: item);
      },
    );
  }

  Widget _buildSingleProspekCard({required Map<String, dynamic> item}) {
    final company = item['company'] ?? item['name'] ?? 'perusahaan/instansi';
    final picAndRole = item['pic'] ?? 'Bertemu dengan - Jabatan';
    final status = item['status'] ?? 'Pipeline';
    final potensi = item['potensi'] ?? item['potential'] ?? 'Nilai transaksi';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFF7A00), // Vibrant Orange Card
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line 1: "perusahaan/instansi" & Badge "Pipeline" / "Meeting"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  company,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Status Badge (Dark Navy)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D2B45),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),

          // Line 2: "Bertemu dengan - Jabatan"
          Text(
            picAndRole,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),

          // Line 3: "Potensi Nilai transaksi" & "Lihat detail >"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Potensi ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: potensi,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D2B45),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DetailProspekScreen(data: item),
                    ),
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    'Lihat detail >',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
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

  // ── 0. LEADS TAB VIEW (ORANGE CARDS MATCHING PROSPEK STYLE) ────────────────
  Widget _buildLeadsView() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      itemCount: _leadsList.length,
      itemBuilder: (context, index) {
        final item = _leadsList[index];
        return _buildSingleLeadCard(item: item);
      },
    );
  }

  Widget _buildSingleLeadCard({required Map<String, dynamic> item}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFF7A00), // Same Vibrant Orange Card as Prospek
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line 1: Nama Leads / Perusahaan & Badge Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item['name'] ?? item['company'] ?? 'Nama Leads',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Status Badge (Dark Navy)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D2B45),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  item['status'] ?? 'Lead Baru',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),

          // Line 2: Jabatan / PIC
          Text(
            'Jabatan / PIC: ${item['role'] ?? item['pic'] ?? '-'}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),

          // Line 3: Nama Kontak & Nomor Telepon
          Text(
            'Kontak: ${item['contactName'] ?? '-'} (${item['phone'] ?? '-'})',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ),
          const SizedBox(height: 6),

          // Line 4: Potensi Nilai & Konversi ke Prospek
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Potensi ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: item['potensi'] ?? 'Nilai transaksi',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D2B45),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Convert Lead to Prospek
                  setState(() {
                    _prospekList.insert(0, {
                      'company': item['name'] ?? item['company'],
                      'name': item['name'] ?? item['company'],
                      'pic':
                          'Bertemu dengan - ${item['role'] ?? item['pic'] ?? ''}',
                      'contactName': item['contactName'],
                      'phone': item['phone'],
                      'address': item['address'],
                      'potensi': item['potensi'],
                      'status': 'Pipeline',
                      'source': item['source'] ?? 'Lead Conversion',
                      'product': item['product'] ?? 'Lokativa Plan',
                      'date': '23 Agu 2026',
                    });
                    _leadsList.remove(item);
                    _selectedTab = 1; // Switch to List Prospek
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${item['name']} berhasil dikonversi ke Prospek!',
                      ),
                      backgroundColor: const Color(0xFF0D2B45),
                    ),
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    'Konversi ke Prospek >',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
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

  // ── 2. KANBAN TAB VIEW ─────────────────────────────────────────────────────
  Widget _buildKanbanView() {
    final columns = [
      {
        'title': 'Pipeline (2)',
        'items': [
          {
            'title': 'PT Telekomunikasi Indonesia',
            'company': 'PT Telekomunikasi Indonesia',
            'pic': 'Ir. Hendra Gunawan',
            'val': 'Rp 85.000.000',
            'potensi': 'Rp 85.000.000',
            'status': 'Pipeline',
          },
          {
            'title': 'CV Sentosa Abadi Jaya',
            'company': 'CV Sentosa Abadi Jaya',
            'pic': 'Siti Rahmawati',
            'val': 'Rp 35.000.000',
            'potensi': 'Rp 35.000.000',
            'status': 'Pipeline',
          },
        ],
      },
      {
        'title': 'Meeting (2)',
        'items': [
          {
            'title': 'PT Digital Mega Pratama',
            'company': 'PT Digital Mega Pratama',
            'pic': 'Agus Supriyadi',
            'val': 'Rp 50.000.000',
            'potensi': 'Rp 50.000.000',
            'status': 'Meeting',
          },
          {
            'title': 'PT Nusantara Logistik Makmur',
            'company': 'PT Nusantara Logistik Makmur',
            'pic': 'Dimas Anggara',
            'val': 'Rp 120.000.000',
            'potensi': 'Rp 120.000.000',
            'status': 'Meeting',
          },
        ],
      },
      {
        'title': 'Deal (1)',
        'items': [
          {
            'title': 'PT Jaya Sentosa Abadi',
            'company': 'PT Jaya Sentosa Abadi',
            'pic': 'Maya Puspita',
            'val': 'Rp 65.000.000',
            'potensi': 'Rp 65.000.000',
            'status': 'Deal',
          },
        ],
      },
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      itemCount: columns.length,
      itemBuilder: (context, colIndex) {
        final col = columns[colIndex];
        final items = col['items'] as List<Map<String, String>>;

        return Container(
          width: 260,
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    col['title'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                  const Icon(
                    Icons.more_horiz,
                    color: Color(0xFF0D2B45),
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DetailProspekScreen(data: item),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7A00),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title']!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item['pic']!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item['val']!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0D2B45),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
