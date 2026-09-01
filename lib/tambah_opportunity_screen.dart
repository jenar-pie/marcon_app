import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'sales_proposal_pipeline_screen.dart';

class TambahOpportunityScreen extends StatefulWidget {
  const TambahOpportunityScreen({super.key});

  @override
  State<TambahOpportunityScreen> createState() =>
      _TambahOpportunityScreenState();
}

class _TambahOpportunityScreenState extends State<TambahOpportunityScreen> {
  final _customerController = TextEditingController();
  final _potensiController = TextEditingController();
  final _probabilityController = TextEditingController();
  final _targetDateController = TextEditingController();
  final _catatanController = TextEditingController();

  String _selectedStage = 'Contact';
  final List<String> _stages = [
    'Lead',
    'Contact',
    'Meeting',
    'Presentasi',
    'Proposal',
    'Negosiasi',
  ];

  List<Map<String, dynamic>> _existingProspekList = [];
  List<Map<String, dynamic>> _filteredSuggestions = [];
  bool _showSuggestions = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadProspekSuggestions();
  }

  Future<void> _loadProspekSuggestions() async {
    try {
      final jsonString = await rootBundle.loadString(
        'lib/assets/sample_prospek.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);
      setState(() {
        _existingProspekList = jsonData.cast<Map<String, dynamic>>();
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _customerController.dispose();
    _potensiController.dispose();
    _probabilityController.dispose();
    _targetDateController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _onCustomerSearchChanged(String val) {
    // Debounce to prevent rapid setState calls while typing
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      if (val.trim().isEmpty) {
        // Only setState if there's something to clear
        if (_showSuggestions || _filteredSuggestions.isNotEmpty) {
          setState(() {
            _filteredSuggestions = [];
            _showSuggestions = false;
          });
        }
        return;
      }
      final q = val.toLowerCase();
      final newSuggestions = _existingProspekList.where((p) {
        final comp = (p['company'] ?? '').toString().toLowerCase();
        final name = (p['name'] ?? '').toString().toLowerCase();
        return comp.contains(q) || name.contains(q);
      }).toList();

      final newShow = newSuggestions.isNotEmpty;
      // Only rebuild if results actually changed
      if (newShow != _showSuggestions ||
          newSuggestions.length != _filteredSuggestions.length) {
        setState(() {
          _filteredSuggestions = newSuggestions;
          _showSuggestions = newShow;
        });
      } else {
        _filteredSuggestions = newSuggestions;
      }
    });
  }

  Future<void> _selectTargetDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 14)),
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      final formatted =
          "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
      setState(() {
        _targetDateController.text = formatted;
      });
    }
  }

  void _saveOpportunity() {
    final customer = _customerController.text.trim();
    if (customer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masukan atau pilih Prospek/Customer'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final potensiText = _potensiController.text.trim();
    final probabilityText = _probabilityController.text.trim();
    final targetDate = _targetDateController.text.trim();
    final catatan = _catatanController.text.trim();

    final resultData = {
      'company': customer,
      'name': customer,
      'potensi': potensiText.startsWith('Rp') ? potensiText : 'Rp $potensiText',
      'price': potensiText.startsWith('Rp') ? potensiText : 'Rp $potensiText',
      'status': _selectedStage == 'Contact' || _selectedStage == 'Lead'
          ? 'Pipeline'
          : _selectedStage,
      'stage': _selectedStage,
      'probability': probabilityText.isNotEmpty
          ? (probabilityText.contains('%')
                ? probabilityText
                : '$probabilityText%')
          : '65%',
      'targetDate': targetDate,
      'notes': catatan,
      'date': '24 Agu 2026',
    };

    const proposalStages = {'Proposal', 'Meeting', 'Deal', 'Pipeline'};
    if (proposalStages.contains(resultData['status'])) {
      SalesProposalPipelineScreen.registerProposal(resultData);
    }

    Navigator.pop(context, resultData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF7A00), // Background Oranye Utama
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── HEADER ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
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
                    'Tambah Opportunity',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                ],
              ),
            ),

            // ── MAIN CONTENT CONTAINER (WHITE ROUNDED CARD) ─────────────────
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    24,
                    16,
                    24 + MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Top Info Box ──────────────────────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7A00)
                              .withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFFF7A00)
                                .withValues(alpha: 0.30),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              size: 18,
                              color: Color(0xFFFF7A00),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Gunakan ini hanya untuk prospek yang sudah ada kesepakatan awal tapi belum tercatat sebagai Lead di sistem.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: const Color(0xFFB85C00),
                                  height: 1.45,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Field 1: Prospek / Customer ───────────────────────
                      Text(
                        'Prospek/Customer',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFF7A00),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFFF7A00),
                            width: 1.2,
                          ),
                        ),
                        child: TextField(
                          controller: _customerController,
                          onChanged: _onCustomerSearchChanged,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: const Color(0xFF0D2B45),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Cari atau pilih prospek yang ada',
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: const Color(0xFF90A4AE),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),

                      if (_showSuggestions) ...[
                        Container(
                          constraints: const BoxConstraints(maxHeight: 160),
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredSuggestions.length,
                            itemBuilder: (ctx, i) {
                              final item = _filteredSuggestions[i];
                              final comp = item['company'] ?? '';
                              return ListTile(
                                dense: true,
                                title: Text(
                                  comp,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _customerController.text = comp;
                                    _showSuggestions = false;
                                    if (item['potensi'] != null) {
                                      _potensiController.text = item['potensi']
                                          .toString();
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],

                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () {
                          _customerController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Ketik nama data baru pada field diatas',
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text(
                          '+ Belum ada di sistem? Buat data baru',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0D2B45),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Field 2: Mulai Di Tahap ───────────────────────
                      Text(
                        'Mulai Di Tahap',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFF7A00),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          _buildStagePill(_stages[0]),
                          const SizedBox(width: 8),
                          _buildStagePill(_stages[1]),
                          const SizedBox(width: 8),
                          _buildStagePill(_stages[2]),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildStagePill(_stages[3]),
                          const SizedBox(width: 8),
                          _buildStagePill(_stages[4]),
                          const SizedBox(width: 8),
                          _buildStagePill(_stages[5]),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Field 3 & 4: Nilai Potensi & Probability ──────
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nilai Potensi',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF7A00),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFFFF7A00),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _potensiController,
                                    keyboardType: TextInputType.number,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: const Color(0xFF0D2B45),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Rp 0',
                                      hintStyle: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: const Color(0xFF90A4AE),
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Probability',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF7A00),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFFFF7A00),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _probabilityController,
                                    keyboardType: TextInputType.number,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: const Color(0xFF0D2B45),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '65%',
                                      hintStyle: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: const Color(0xFF90A4AE),
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Field 5: Target Tanggal Closing ────────────────
                      Text(
                        'Target Tanggal Closing',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFF7A00),
                        ),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: _selectTargetDate,
                        child: AbsorbPointer(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFFF7A00),
                                width: 1.2,
                              ),
                            ),
                            child: TextField(
                              controller: _targetDateController,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: const Color(0xFF0D2B45),
                              ),
                              decoration: InputDecoration(
                                hintText: 'mm/dd/yyyy',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: const Color(0xFF90A4AE),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                suffixIcon: const Icon(
                                  Icons.calendar_month_outlined,
                                  color: Color(0xFFFF7A00),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Field 6: Catatan Progres / Keterangan ───────────
                      Text(
                        'Catatan Progres / Keterangan',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFF7A00),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFFF7A00),
                            width: 1.2,
                          ),
                        ),
                        child: TextField(
                          controller: _catatanController,
                          maxLines: 3,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: const Color(0xFF0D2B45),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Contoh : Referral dari RS cahaya Medika, sudah janji meeting minggu depan',
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: const Color(0xFF90A4AE),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Save Button ────────────────────────────────────
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 200,
                          height: 44,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF7A00),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 2,
                            ),
                            onPressed: _saveOpportunity,
                            child: Text(
                              'Simpan Opportunity',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildStagePill(String stage) {
    final bool isSelected = _selectedStage == stage;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedStage = stage;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF7A00) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFF7A00), width: 1.2),
          ),
          child: Text(
            stage,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF0D2B45),
            ),
          ),
        ),
      ),
    );
  }
}
