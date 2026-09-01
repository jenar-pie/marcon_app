import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'detail_proposal_sales_screen.dart';
import 'detail_prospek_screen.dart';
import 'tambah_opportunity_screen.dart';

class SalesProposalPipelineScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const SalesProposalPipelineScreen({super.key, this.onBack});

  // Global shared user proposals store for sync across screens
  static final List<Map<String, dynamic>> globalUserProposals = [];

  static void registerProposal(Map<String, dynamic> proposalData) {
    final company = (proposalData['company'] ?? proposalData['name'] ?? '')
        .toString();
    final key = company.trim().toLowerCase();

    final existingIdx = globalUserProposals.indexWhere(
      (p) => (p['company'] ?? '').toString().trim().toLowerCase() == key,
    );

    final String status = proposalData['status'] ?? 'Review';
    final String category = (status == 'Deal' || status == 'Disetujui')
        ? 'Deal'
        : (status == 'Rejected' || status == 'Ditolak'
              ? 'Rejected'
              : 'Berjalan');

    final mapped = {
      'company': company,
      'product': proposalData['product'] ?? 'Layanan Medis Utama',
      'price':
          proposalData['price'] ?? proposalData['potensi'] ?? 'Rp 120.000.000',
      'docId':
          proposalData['docId'] ??
          'NO-${company.isNotEmpty ? company[0].toUpperCase() : "X"}-2026',
      'fileName':
          proposalData['fileName'] ??
          'Proposal_Penawaran_${company.replaceAll(' ', '_')}.pdf',
      'status': status,
      'category': category,
      'progressNote':
          proposalData['progressNote'] ?? 'Menunggu review supervisor',
      'progressNoteColor':
          proposalData['progressNoteColor'] ?? const Color(0xFFFF7A00),
      'probability': proposalData['probability'] ?? 'Probability 80%',
      'notes': proposalData['notes'] ?? '',
      'submittedAt': proposalData['submittedAt'] ?? '24 Agu 2026',
      'expiredDate': proposalData['expiredDate'] ?? '25/09/2026',
      'isDiscount': proposalData['isDiscount'] ?? false,
    };

    if (existingIdx != -1) {
      globalUserProposals[existingIdx] = mapped;
    } else {
      globalUserProposals.insert(0, mapped);
    }

    if (key.isNotEmpty) {
      DetailProspekScreen.companyActivities.putIfAbsent(key, () => []);
      final now = DateTime.now();
      final dateStr =
          '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
      final timeStr =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      DetailProspekScreen.companyActivities[key]!.insert(
        0,
        ActivityItem(
          title: 'Pengajuan Proposal ($status)',
          date: dateStr,
          time: timeStr,
          desc:
              'Proposal ${mapped['docId']} (${mapped['product']}) sebesar ${mapped['price']} telah diajukan & tersinkronisasi.',
          isCompleted: true,
          type: 'proposal',
        ),
      );
    }
  }

  @override
  State<SalesProposalPipelineScreen> createState() =>
      _SalesProposalPipelineScreenState();
}

class _SalesProposalPipelineScreenState
    extends State<SalesProposalPipelineScreen> {
  String _selectedTab = 'pipeline'; // 'pipeline' or 'proposal'
  String _selectedProposalFilter =
      'Semua'; // 'Semua', 'Berjalan', 'Deal', 'Rejected'
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Data loaded from sample_prospek.json – same source as ProspekScreen
  List<Map<String, dynamic>> _prospekList = [];
  List<Map<String, dynamic>> _leadsList = [];
  List<Map<String, dynamic>> _proposalsList = [];

  // ── helper: map prospek JSON entry → proposal card data ──────────────────
  static Map<String, dynamic> _toProposalCard(Map<String, dynamic> p) {
    final prospekStatus = (p['status'] ?? '').toString();
    String proposalStatus;
    String category;
    String progressNote;
    Color progressNoteColor;
    String negotiationNote;

    switch (prospekStatus) {
      case 'Proposal':
        proposalStatus = 'Review';
        category = 'Berjalan';
        progressNote = 'Menunggu review supervisor';
        progressNoteColor = const Color(0xFFFF7A00);
        negotiationNote = '';
        break;
      case 'Meeting':
        proposalStatus = 'Negotiation';
        category = 'Berjalan';
        progressNote = 'Dalam proses negosiasi';
        progressNoteColor = const Color(0xFFFF7A00);
        negotiationNote =
            'Catatan negosiasi : Customer sedang mengevaluasi penawaran';
        break;
      case 'Deal':
        proposalStatus = 'Deal';
        category = 'Deal';
        progressNote = 'Kontrak berhasil ditutup';
        progressNoteColor = const Color(0xFF5BA32A);
        negotiationNote = '';
        break;
      case 'Pipeline':
        proposalStatus = 'Approved';
        category = 'Berjalan';
        progressNote = 'Menunggu tanda tangan customer';
        progressNoteColor = const Color(0xFF5BA32A);
        negotiationNote = '';
        break;
      default:
        proposalStatus = 'Review';
        category = 'Berjalan';
        progressNote = '';
        progressNoteColor = const Color(0xFF8FA1B0);
        negotiationNote = '';
    }

    // Format potensi as price string
    final potensi = (p['potensi'] ?? '').toString();
    final date = (p['date'] ?? '').toString();
    final company = (p['company'] ?? '').toString();
    final product = (p['product'] ?? '').toString();

    // Generate a doc ID from company initials + date
    final companyInitials = company
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(3)
        .map((w) => w[0].toUpperCase())
        .join();
    // Build short date tag from date string e.g. "24 Agu 2026" → "2608"
    final dateParts = date.split(' ');
    final monthMap = {
      'Jan': '01',
      'Feb': '02',
      'Mar': '03',
      'Apr': '04',
      'Mei': '05',
      'Jun': '06',
      'Jul': '07',
      'Agu': '08',
      'Sep': '09',
      'Okt': '10',
      'Nov': '11',
      'Des': '12',
    };
    final monthNum = dateParts.length > 1
        ? (monthMap[dateParts[1]] ?? '00')
        : '00';
    final dayNum = dateParts.isNotEmpty ? dateParts[0].padLeft(2, '0') : '00';
    final docId = 'NO-$companyInitials-$dayNum$monthNum';

    return {
      'company': company,
      'product': product,
      'price': potensi,
      'expiredDate': '',
      'fileName': 'Proposal_${company.replaceAll(' ', '_')}.pdf',
      'docId': docId,
      'status': proposalStatus,
      'category': category,
      'progressNote': progressNote,
      'progressNoteColor': progressNoteColor,
      'negotiationNote': negotiationNote,
      'probability':
          'Probability ${proposalStatus == "Deal"
              ? "100%"
              : proposalStatus == "Approved"
              ? "85%"
              : "65%"}',
      'notes': '',
      'isDiscount': false,
      'submittedAt': date,
      // Keep original prospek fields for reference
      'pic': p['pic'] ?? '',
      'contactName': p['contactName'] ?? '',
      'phone': p['phone'] ?? '',
      'address': p['address'] ?? '',
      'source': p['source'] ?? '',
    };
  }

  Future<void> _loadData() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'lib/assets/sample_prospek.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);
      final List<Map<String, dynamic>> all = jsonData
          .cast<Map<String, dynamic>>();

      const proposalStatuses = {'Proposal', 'Meeting', 'Deal', 'Pipeline'};

      final jsonProps = all
          .where((e) => proposalStatuses.contains(e['status']))
          .map(_toProposalCard)
          .toList();

      setState(() {
        _leadsList = all.where((e) => e['status'] == 'Lead Baru').toList();
        _prospekList = all.where((e) => e['status'] != 'Lead Baru').toList();

        // Deduplicate: User submitted proposals take priority over sample json
        final userCompKeys = SalesProposalPipelineScreen.globalUserProposals
            .map((p) => (p['company'] ?? '').toString().trim().toLowerCase())
            .toSet();

        final filteredJsonProps = jsonProps.where(
          (p) => !userCompKeys.contains(
            (p['company'] ?? '').toString().trim().toLowerCase(),
          ),
        );

        _proposalsList = [
          ...SalesProposalPipelineScreen.globalUserProposals,
          ...filteredJsonProps,
        ];
      });
    } catch (_) {
      // If JSON fails to load, keep empty lists
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openTambahOpportunity() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const TambahOpportunityScreen()),
    );

    if (result != null && mounted) {
      setState(() {
        _prospekList.insert(0, result);
        const proposalStatuses = {'Proposal', 'Meeting', 'Deal', 'Pipeline'};
        if (proposalStatuses.contains(result['status'])) {
          _proposalsList.insert(0, _toProposalCard(result));
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Opportunity "${result['company']}" berhasil ditambahkan!',
            ),
            backgroundColor: const Color(0xFF5BA32A),
          ),
        );
      }
    }
  }

  void _openDetailProposalSales(Map<String, dynamic> item) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => DetailProposalSalesScreen(proposalData: item),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        final newStatus = result['status'] as String?;
        if (newStatus != null) {
          item['status'] = newStatus;
          if (newStatus == 'Approved' || newStatus == 'Disetujui') {
            item['status'] = 'Approved';
            item['category'] = 'Berjalan';
            item['progressNote'] = 'Menunggu tanda tangan customer';
            item['progressNoteColor'] = const Color(0xFF5BA32A);
          } else if (newStatus == 'Deal') {
            item['status'] = 'Deal';
            item['category'] = 'Deal';
            item['progressNote'] = 'Kontrak berhasil ditutup';
            item['progressNoteColor'] = const Color(0xFF5BA32A);
          } else if (newStatus == 'Rejected' || newStatus == 'Ditolak') {
            item['status'] = 'Rejected';
            item['category'] = 'Rejected';
            item['progressNote'] =
                'Alasan : ${result['note'] ?? "Budget tidak mencukupi"}';
            item['progressNoteColor'] = const Color(0xFFFF3B30);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF7A00),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── 1. HEADER ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
                          Navigator.of(context).pop();
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 22,
                          color: Color(0xFF0D2B45),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Sales & Proposal',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                ],
              ),
            ),

            // ── 2. SEARCH BAR & BARU BUTTON ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                children: [
                  // Search Field
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.toLowerCase();
                          });
                        },
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: const Color(0xFF0D2B45),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Cari Prospek dan Customer',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: const Color(0xFF8FA1B0),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF8FA1B0),
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // + Baru Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D2B45),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: _openTambahOpportunity,
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: Text(
                      'Baru',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── 3. MAIN BODY CONTAINER ──────────────────────────────────────
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
                      color: Color(0xFFDCE2E7), // Slate Light Background
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
                          // SVG Background Decoration
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

                          // Scrollable View
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
                                // ── SEGMENTED TAB SWITCHER ─────────────────
                                _buildTabSwitcher(),
                                const SizedBox(height: 16),

                                // Tab Content
                                if (_selectedTab == 'pipeline')
                                  _buildPipelineContent()
                                else
                                  _buildProposalListContent(),
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

  // ── TAB SWITCHER ──────────────────────────────────────────────────────────
  Widget _buildTabSwitcher() {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE7B182).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Pipeline Tab
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 'pipeline'),
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedTab == 'pipeline'
                      ? const Color(0xFFE88226)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _selectedTab == 'pipeline'
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Pipeline',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Proposal Tab
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = 'proposal'),
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedTab == 'proposal'
                      ? const Color(0xFFE88226)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _selectedTab == 'proposal'
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Proposal',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── PIPELINE TAB CONTENT ──────────────────────────────────────────────────
  Widget _buildPipelineContent() {
    // ── Compute dynamic figures from real data ─────────────────────────────
    // Parse potensi string e.g. "Rp 150.000.000" → 150000000
    int parsePot(String s) {
      final cleaned = s.replaceAll(RegExp(r'[^0-9]'), '');
      return cleaned.isEmpty ? 0 : int.tryParse(cleaned) ?? 0;
    }

    String fmtRp(int v) {
      if (v >= 1000000000) return 'Rp ${(v / 1000000000).toStringAsFixed(1)}M';
      if (v >= 1000000) return 'Rp ${(v / 1000000).round()}jt';
      if (v >= 1000) return 'Rp ${(v / 1000).round()}rb';
      return 'Rp $v';
    }

    final allPipeline = _prospekList; // all non-Lead
    final totalPipelineVal = allPipeline.fold<int>(
      0,
      (sum, e) => sum + parsePot((e['potensi'] ?? '').toString()),
    );

    // Deal this month
    final dealList = allPipeline.where((e) => e['status'] == 'Deal').toList();
    final dealVal = dealList.fold<int>(
      0,
      (sum, e) => sum + parsePot((e['potensi'] ?? '').toString()),
    );

    // Weighted pipeline: sum(potensi * probability by stage)
    const stageProb = <String, double>{
      'Pipeline': 0.20,
      'Meeting': 0.50,
      'Proposal': 0.70,
      'Deal': 1.0,
    };
    final weightedVal = allPipeline.fold<double>(0, (sum, e) {
      final prob = stageProb[e['status'] ?? ''] ?? 0.3;
      return sum + parsePot((e['potensi'] ?? '').toString()) * prob;
    }).round();

    final weightedPct = totalPipelineVal > 0
        ? (weightedVal / totalPipelineVal).clamp(0.0, 1.0)
        : 0.0;
    final weightedPctLabel =
        '${(weightedPct * 100).round()}% dari total nilai pipeline';

    // Per-stage aggregation
    Map<String, int> stageVal = {};
    Map<String, int> stageCount = {};
    for (final e in allPipeline) {
      final st = (e['status'] ?? 'Pipeline').toString();
      stageVal[st] =
          (stageVal[st] ?? 0) + parsePot((e['potensi'] ?? '').toString());
      stageCount[st] = (stageCount[st] ?? 0) + 1;
    }
    // Lead count from _leadsList
    final leadVal = _leadsList.fold<int>(
      0,
      (sum, e) => sum + parsePot((e['potensi'] ?? '').toString()),
    );
    final leadCount = _leadsList.length;

    // Max val for progress bar scaling
    final maxStageVal = <int>[
      leadVal,
      ...stageVal.values,
    ].fold<int>(0, (a, b) => b > a ? b : a);
    double stageProgress(int val) =>
        maxStageVal > 0 ? (val / maxStageVal).clamp(0.0, 1.0) : 0.0;

    // Top opportunities: sort by potensi desc, take top 3
    final topOpps = [...allPipeline];
    topOpps.sort(
      (a, b) =>
          parsePot((b['potensi'] ?? '').toString())
              .compareTo(parsePot((a['potensi'] ?? '').toString())),
    );
    final top3 = topOpps.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. SUMMARY CARDS ROW (Sales Pipeline & Forecast Bulan Ini)
        Row(
          children: [
            // Sales Pipeline Card (Orange)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7A00),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF7A00).withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sales Pipeline',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        fmtRp(totalPipelineVal),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Forecast Bulan Ini Card (Navy)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D2B45),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D2B45).withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forecast Bulan Ini',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        fmtRp(dealVal),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // 2. WEIGHTED PIPELINE CARD
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFF7A00), width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weighted pipeline',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                  Text(
                    fmtRp(weightedVal),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Progress Bar (dynamic)
              Container(
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: const Color(0xFFFF7A00).withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: weightedPct,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7A00),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Text(
                '$weightedPctLabel · dihitung dari nilai × probability closing tiap opportunity',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: const Color(0xFF8FA1B0),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 3. NILAI PER TAHAPAN CARD
        Text(
          'Nilai per Tahapan',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0D2B45),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFF7A00), width: 1.2),
          ),
          child: Column(
            children: [
              _buildStageRow(
                'Lead',
                '${fmtRp(leadVal)} · $leadCount prospek',
                stageProgress(leadVal),
                isOrange: false,
              ),
              if ((stageCount['Pipeline'] ?? 0) > 0) ...[
                const SizedBox(height: 8),
                _buildStageRow(
                  'Pipeline',
                  '${fmtRp(stageVal["Pipeline"] ?? 0)} · ${stageCount["Pipeline"]} prospek',
                  stageProgress(stageVal['Pipeline'] ?? 0),
                  isOrange: false,
                ),
              ],
              if ((stageCount['Meeting'] ?? 0) > 0) ...[
                const SizedBox(height: 8),
                _buildStageRow(
                  'Meeting',
                  '${fmtRp(stageVal["Meeting"] ?? 0)} · ${stageCount["Meeting"]} prospek',
                  stageProgress(stageVal['Meeting'] ?? 0),
                  isOrange: false,
                ),
              ],
              if ((stageCount['Proposal'] ?? 0) > 0) ...[
                const SizedBox(height: 8),
                _buildStageRow(
                  'Proposal',
                  '${fmtRp(stageVal["Proposal"] ?? 0)} · ${stageCount["Proposal"]} prospek',
                  stageProgress(stageVal['Proposal'] ?? 0),
                  isOrange: true,
                ),
              ],
              if ((stageCount['Deal'] ?? 0) > 0) ...[
                const SizedBox(height: 8),
                _buildStageRow(
                  'Deal',
                  '${fmtRp(stageVal["Deal"] ?? 0)} · ${stageCount["Deal"]} prospek',
                  stageProgress(stageVal['Deal'] ?? 0),
                  isOrange: true,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 4. OPPORTUNITY TERATAS SECTION
        Text(
          'Opportunity Teratas',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0D2B45),
          ),
        ),
        const SizedBox(height: 8),

        if (top3.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                'Belum ada opportunity',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: const Color(0xFF8FA1B0),
                ),
              ),
            ),
          )
        else
          ...top3.asMap().entries.map((entry) {
            final opp = entry.value;
            final company = (opp['company'] ?? '').toString();
            final potensi = (opp['potensi'] ?? '').toString();
            final status = (opp['status'] ?? '').toString();
            final prob = stageProb[status] ?? 0.5;
            final probLabel = '${(prob * 100).round()}%';
            return Padding(
              padding: EdgeInsets.only(
                bottom: entry.key < top3.length - 1 ? 10 : 0,
              ),
              child: _buildOpportunityCard(
                title: company,
                subtitle: potensi,
                badgeText: status,
                progressPct: probLabel,
                progressVal: prob,
                data: opp,
              ),
            );
          }),
      ],
    );
  }

  // Helper Widget: Stage Row for "Nilai per Tahapan"
  Widget _buildStageRow(
    String stageName,
    String valueInfo,
    double progress, {
    required bool isOrange,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stageName,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isOrange
                    ? const Color(0xFFFF7A00)
                    : const Color(0xFF0D2B45),
              ),
            ),
            Text(
              valueInfo,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: const Color(0xFF8FA1B0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isOrange
                  ? const Color(0xFFFF7A00)
                  : const Color(0xFF0D2B45),
              width: 1.2,
            ),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: isOrange
                    ? const Color(0xFFFF7A00)
                    : const Color(0xFF0D2B45),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper Widget: Opportunity Teratas Card
  Widget _buildOpportunityCard({
    required String title,
    required String subtitle,
    required String badgeText,
    required String progressPct,
    required double progressVal,
    Map<String, dynamic>? data,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailProspekScreen(
              data: data ?? {'nama': title, 'company': title},
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFF7A00), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left Column (Title & Subtitle)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: const Color(0xFF8FA1B0),
                    ),
                  ),
                ],
              ),
            ),

            // Right Column (Badge & Progress Bar)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7A00),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badgeText,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 70,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progressVal,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF7A00),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      progressPct,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF7A00),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── PROPOSAL LIST TAB CONTENT ─────────────────────────────────────────────
  Widget _buildProposalListContent() {
    // 1. Calculate Summary counts
    final totalCount = _proposalsList.length;
    final berjalanCount = _proposalsList
        .where((i) => i['category'] == 'Berjalan')
        .length;
    final dealCount = _proposalsList
        .where((i) => i['category'] == 'Deal')
        .length;
    final rejectedCount = _proposalsList
        .where((i) => i['category'] == 'Rejected')
        .length;

    // 2. Filter list
    final filtered = _proposalsList.where((item) {
      final cat = item['category'] ?? 'Berjalan';
      bool matchesFilter = true;
      if (_selectedProposalFilter == 'Berjalan') {
        matchesFilter = cat == 'Berjalan';
      } else if (_selectedProposalFilter == 'Deal') {
        matchesFilter = cat == 'Deal';
      } else if (_selectedProposalFilter == 'Rejected') {
        matchesFilter = cat == 'Rejected';
      }

      if (!matchesFilter) return false;

      if (_searchQuery.isEmpty) return true;
      final comp = (item['company'] ?? '').toString().toLowerCase();
      final prod = (item['product'] ?? '').toString().toLowerCase();
      final doc = (item['docId'] ?? '').toString().toLowerCase();
      final stat = (item['status'] ?? '').toString().toLowerCase();
      return comp.contains(_searchQuery) ||
          prod.contains(_searchQuery) ||
          doc.contains(_searchQuery) ||
          stat.contains(_searchQuery);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── TOP METRIC CARDS ROW (3 Grey Rounded Boxes) ───────────────────
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF90A4AE).withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      'Rp 289 jt',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0D2B45),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Total nilai',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4A6070),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF90A4AE).withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      '$dealCount',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0D2B45),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Deal bulan ini',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4A6070),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF90A4AE).withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      '1',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0D2B45),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Expired < 3 hari',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4A6070),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // ── FILTER PILLS ROW ──────────────────────────────────────────────
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildProposalFilterPill('Semua', 'Semua. $totalCount'),
              const SizedBox(width: 8),
              _buildProposalFilterPill('Berjalan', 'Berjalan. $berjalanCount'),
              const SizedBox(width: 8),
              _buildProposalFilterPill('Deal', 'Deal. $dealCount'),
              const SizedBox(width: 8),
              _buildProposalFilterPill('Rejected', 'Rejected. $rejectedCount'),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ── PROPOSAL CARDS LIST ────────────────────────────────────────────
        if (filtered.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const Icon(
                  Icons.note_alt_outlined,
                  size: 48,
                  color: Color(0xFF8FA1B0),
                ),
                const SizedBox(height: 8),
                Text(
                  'Belum ada proposal pada kategori ini',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: const Color(0xFF8FA1B0),
                  ),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 12),
            itemBuilder: (ctx, index) {
              final item = filtered[index];
              final company = item['company'] ?? 'Nama Customer';
              final product = item['product'] ?? 'Produk yang diminati';
              final price = item['price'] ?? 'Nilai Penawaran';
              final docId = item['docId'] ?? 'Nomor proposal';
              final status = item['status'] ?? 'Review';
              final progressNote = item['progressNote'] ?? '';
              final Color? progressNoteColor =
                  item['progressNoteColor'] as Color?;
              final probability = item['probability'] ?? '';
              final negotiationNote = item['negotiationNote'] ?? '';

              final bool isRejected =
                  status == 'Rejected' || status == 'Ditolak';
              final bool isDeal = status == 'Deal' || status == 'Disetujui';

              return Container(
                decoration: BoxDecoration(
                  color: isDeal ? const Color(0xFFD4EDDA) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDeal
                        ? const Color(0xFF5BA32A)
                        : const Color(0xFFFF7A00),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Row: Company Name & Badges
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  company,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0D2B45),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Status Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF7A00),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  status,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              // Doc ID / Nomor proposal Badge (RED if Rejected!)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isRejected
                                      ? const Color(0xFFFF3B30)
                                      : const Color(0xFFFF7A00),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  docId,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Subtitle Line: Produk yang diminati . Nilai Penawaran
                          Text(
                            '$product . $price',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0D2B45),
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Progress Note & Probability + Lihat Detail Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Left: Progress Note
                              Expanded(
                                child: progressNote.isNotEmpty
                                    ? Text(
                                        progressNote,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: progressNoteColor != null
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color:
                                              progressNoteColor ??
                                              const Color(0xFF4A6070),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),

                              // Right: Probability & Lihat Detail
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (probability.isNotEmpty) ...[
                                    Text(
                                      probability,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: const Color(0xFF8FA1B0),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                  ],
                                  GestureDetector(
                                    onTap: () => _openDetailProposalSales(item),
                                    child: Text(
                                      'Lihat detail >',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF0D2B45),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Negotiation Note Box at bottom if present
                    if (negotiationNote.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          border: Border(
                            top: BorderSide(
                              color: const Color(0xFFFF7A00)
                                  .withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          negotiationNote,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: const Color(0xFF4A6070),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildProposalFilterPill(String filterKey, String label) {
    final bool isSelected = _selectedProposalFilter == filterKey;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProposalFilter = filterKey;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D2B45) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0D2B45)
                : const Color(0xFF8FA1B0).withValues(alpha: 0.5),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0D2B45).withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF0D2B45),
          ),
        ),
      ),
    );
  }
}
