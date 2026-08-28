import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'detail_prospek_screen.dart';
import 'tambah_data_screen.dart';
import 'detail_leads.dart';

import 'dart:convert';

import 'package:flutter/services.dart';

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

  // Data for List Prospek (Orange Cards) - loaded from asset
  late List<Map<String, dynamic>> _prospekList = [];

  // Data for Leads Tab (Matching Orange Card Style) - loaded from asset
  late List<Map<String, dynamic>> _leadsList = [];

  Future<void> _loadSampleData() async {
    final String jsonString = await rootBundle.loadString(
      'lib/assets/sample_prospek.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    final List<Map<String, dynamic>> data = jsonData
        .cast<Map<String, dynamic>>();
    setState(() {
      _prospekList = data.where((e) => e['status'] != 'Lead Baru').toList();
      // Leads are entries with status "Lead Baru"
      _leadsList = data.where((e) => e['status'] == 'Lead Baru').toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _loadSampleData();
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
            'product': 'Layanan Medis Utama (Core Medical Services)',
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
            'product': 'Layanan Medis Utama (Core Medical Services)',
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
                        _selectedTab == 2 ? 'Kanban Prospek' : 'Leads & CRM',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0D2B45),
                        ),
                      ),
                    ],
                  ),
                  if (_selectedTab != 2) ...[
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
                                    color: const Color(
                                      0xFFECC49E,
                                    ), // Peach Pill
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
          // Line 1: Nama Leads / Perusahaan & Badge Waktu Masuk
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

              // Waktu Masuk Badge (Dark Navy)
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
                  item['date'] ?? 'Waktu masuk',
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

          // Line 2: PIC & No Telp
          Text(
            'PIC: ${item['contactName'] ?? item['role'] ?? item['pic'] ?? '-'} (${item['phone'] ?? '-'})',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),

          // Line 3: Sumber Lead
          Text(
            'Sumber lead: ${item['source'] ?? 'Manual Input'}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ),
          const SizedBox(height: 6),

          // Line 4: Potensi Nilai & Lihat Detail
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
                onTap: () async {
                  final result = await Navigator.of(context)
                      .push<Map<String, dynamic>>(
                        MaterialPageRoute(
                          builder: (_) => DetailLeadsScreen(data: item),
                        ),
                      );
                  if (result != null) {
                    if (result['action'] == 'convert') {
                      final convertedData = result['data'];
                      setState(() {
                        _prospekList.insert(0, {
                          'company':
                              convertedData['company'] ??
                              convertedData['name'] ??
                              '',
                          'name':
                              convertedData['company'] ??
                              convertedData['name'] ??
                              '',
                          'pic':
                              'Bertemu dengan - ${convertedData['role'] ?? convertedData['pic'] ?? ''}',
                          'contactName': convertedData['contactName'] ?? '-',
                          'phone': convertedData['phone'] ?? '-',
                          'address': convertedData['address'] ?? '-',
                          'potensi': convertedData['potensi'] ?? '-',
                          'status': 'Pipeline',
                          'source':
                              convertedData['source'] ?? 'Lead Conversion',
                          'product':
                              convertedData['product'] ??
                              'Layanan Medis Utama (Core Medical Services)',
                          'date': convertedData['date'] ?? '23 Agu 2026',
                        });
                        _leadsList.remove(item);
                        _selectedTab = 1; // Switch to List Prospek
                      });
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${convertedData['company'] ?? convertedData['name']} berhasil dikonversi ke Prospek!',
                            ),
                            backgroundColor: const Color(0xFF0D2B45),
                          ),
                        );
                      }
                    } else if (result['action'] == 'update') {
                      final updatedData = result['data'];
                      setState(() {
                        final idx = _leadsList.indexOf(item);
                        if (idx != -1) {
                          _leadsList[idx] = updatedData;
                        }
                      });
                    }
                  }
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

  // ── 2. KANBAN TAB VIEW ─────────────────────────────────────────────────────
  String _kanbanWaktu = 'Semua Waktu';
  String _kanbanProduk = 'Semua Produk';
  String _kanbanUrutan = 'Terbaru Masuk';

  Widget _buildKanbanView() {
    final allProducts = const [
      'Layanan Medis Utama (Core Medical Services)',
      'Layanan Pemeriksaan & Diagnosis (Diagnostic & Laboratory)',
      'Layanan Unggulan (Center of Excellence)',
      'Layanan Digital & Modifikasi (Modern Services)',
      'Program Keanggotaan & Komunitas (Hospital Programs)',
    ];

    // Filtered & sorted list combining both Leads and Prospects
    final List<Map<String, dynamic>> combined = [
      ..._leadsList,
      ..._prospekList,
    ];
    List<Map<String, dynamic>> filtered = List.from(combined);

    // Filter by produk
    if (_kanbanProduk != 'Semua Produk') {
      filtered = filtered.where((e) => e['product'] == _kanbanProduk).toList();
    }

    // Sort
    if (_kanbanUrutan == 'Nilai potensi tertinggi') {
      filtered.sort((a, b) {
        final aVal =
            int.tryParse(
              (a['potensi'] ?? '0').toString().replaceAll(
                RegExp(r'[^0-9]'),
                '',
              ),
            ) ??
            0;
        final bVal =
            int.tryParse(
              (b['potensi'] ?? '0').toString().replaceAll(
                RegExp(r'[^0-9]'),
                '',
              ),
            ) ??
            0;
        return bVal.compareTo(aVal);
      });
    }

    // Lane definitions
    const lanes = [
      {'key': 'Lead', 'label': 'Lead'},
      {'key': 'Contact', 'label': 'Contact'},
      {'key': 'Meeting', 'label': 'Meeting'},
      {'key': 'Proposal', 'label': 'Proposal'},
      {'key': 'Deal', 'label': 'Deal'},
    ];

    // Map prospek status to lane key
    String toLaneKey(String status) {
      switch (status) {
        case 'Pipeline':
          return 'Contact';
        case 'Meeting':
          return 'Meeting';
        case 'Deal':
          return 'Deal';
        case 'Proposal':
          return 'Proposal';
        default:
          return 'Lead';
      }
    }

    return Column(
      children: [
        // ── Filter Bar ─────────────────────────────────────────────────
        Container(
          color: const Color(0xFFF3F6F8),
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            children: [
              Expanded(
                child: _kanbanDropdown(
                  label: 'Waktu Masuk',
                  value: _kanbanWaktu,
                  options: const [
                    'Semua Waktu',
                    '7 hari terakhir',
                    '30 hari terakhir',
                  ],
                  onChanged: (v) => setState(() => _kanbanWaktu = v),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _kanbanDropdown(
                  label: 'Produk',
                  value: _kanbanProduk,
                  options: ['Semua Produk', ...allProducts],
                  onChanged: (v) => setState(() => _kanbanProduk = v),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _kanbanDropdown(
                  label: 'Urutkan Berdasarkan',
                  value: _kanbanUrutan,
                  options: const [
                    'Terbaru Masuk',
                    'Nilai potensi tertinggi',
                    'Terlama tanpa aktivitas',
                  ],
                  onChanged: (v) => setState(() => _kanbanUrutan = v),
                ),
              ),
            ],
          ),
        ),

        // ── Lane List (vertical scroll) ─────────────────────────────────
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            itemCount: lanes.length,
            itemBuilder: (context, laneIndex) {
              final lane = lanes[laneIndex];
              final laneKey = lane['key']!;
              final laneLabel = lane['label']!;
              final scrollController = ScrollController();

              final laneItems = filtered
                  .where((e) => toLaneKey(e['status'] ?? '') == laneKey)
                  .toList();

              // Total potensi in this lane
              int totalPotensi = 0;
              for (final item in laneItems) {
                final raw = (item['potensi'] ?? '0').toString().replaceAll(
                  RegExp(r'[^0-9]'),
                  '',
                );
                totalPotensi += int.tryParse(raw) ?? 0;
              }
              final totalStr = totalPotensi > 0
                  ? 'Rp ${(totalPotensi / 1000000).toStringAsFixed(0)}jt'
                  : 'Rp 0';

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B8BA4).withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lane header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$laneLabel . ${laneItems.length}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0D2B45),
                            ),
                          ),
                          Text(
                            totalStr,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0D2B45),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Horizontal scrollable cards or empty state
                    if (laneItems.isEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                        child: Text(
                          'List $laneLabel Kosong',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: const Color(0xFF0D2B45)
                                .withValues(alpha: 0.45),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 130,
                        child: Scrollbar(
                          controller: scrollController,
                          thumbVisibility: true,
                          thickness: 4.0,
                          radius: const Radius.circular(8),
                          child: ListView.builder(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                            itemCount: laneItems.length,
                            itemBuilder: (context, i) {
                              final item = laneItems[i];
                              final company =
                                  item['company'] ??
                                  item['name'] ??
                                  'Nama Perusahaan';
                              final date = item['date'] ?? '';
                              final potensi =
                                  item['potensi'] ?? 'Nilai Transaksi';

                              return GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailProspekScreen(data: item),
                                  ),
                                ),
                                child: Container(
                                  width: 170,
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.06,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        company,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF0D2B45),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        date.isNotEmpty
                                            ? 'Masuk $date'
                                            : 'Lama Prospek ada di tahap ini',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 10,
                                          color: const Color(0xFF6B8BA4),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Text(
                                            'Potensi ',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 10,
                                              color: const Color(0xFF6B8BA4),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              potensi,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(
                                                      0xFF4CAF50,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _kanbanDropdown({
    required String label,
    required String value,
    required List<String> options,
    required void Function(String) onChanged,
  }) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
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
                        fontWeight: value == opt
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: const Color(0xFF0D2B45),
                      ),
                    ),
                    trailing: value == opt
                        ? const Icon(
                            Icons.check_rounded,
                            color: Color(0xFFFF7A00),
                          )
                        : null,
                    onTap: () {
                      Navigator.of(context).pop();
                      onChanged(opt);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF0D2B45).withValues(alpha: 0.18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0D2B45),
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: Color(0xFF0D2B45),
            ),
          ],
        ),
      ),
    );
  }
}
