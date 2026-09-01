import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'approval_proposal_screen.dart';
import 'sales_proposal_pipeline_screen.dart';

class BuatProposalScreen extends StatefulWidget {
  final String? initialCompany;
  final String? initialProduct;
  final String? initialPrice;

  const BuatProposalScreen({
    super.key,
    this.initialCompany,
    this.initialProduct,
    this.initialPrice,
  });

  @override
  State<BuatProposalScreen> createState() => _BuatProposalScreenState();
}

class _BuatProposalScreenState extends State<BuatProposalScreen> {
  late String _selectedCustomer;
  late String _selectedProduct;
  late TextEditingController _priceController;
  final TextEditingController _expiredDateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isDiscountRequested = true;
  String _uploadedFileName = 'Penawaran_Rs_Harapan_Semua.pdf';
  late String _uploadedDocId;
  bool _isCustomerDropdownOpen = false;
  bool _isProductDropdownOpen = false;

  final List<String> _customerList = [
    'PT Telekomunikasi Indonesia',
    'CV Sentosa Abadi Jaya',
    'PT Digital Mega Pratama',
    'PT Nusantara Logistik Makmur',
    'PT Maju Bersama Logistik',
  ];

  final List<String> _productList = [
    'Marcon Kerjasama',
    'Marcon Penawaran Produk',
    'Marcon Penjualan Produk',
    'Marcon Revise Penawaran',
    'Marcon Revise Kerjasama',
  ];

  String _generateDocId() {
    final now = DateTime.now();
    final dateStr =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final randomHex =
        Random().nextInt(0xFFFF).toRadixString(16).padLeft(4, '0').toUpperCase();
    return 'DOC-$dateStr-$randomHex';
  }

  @override
  void initState() {
    super.initState();
    _uploadedDocId = _generateDocId();
    _selectedCustomer = widget.initialCompany ?? _customerList.first;
    if (!_customerList.contains(_selectedCustomer)) {
      _customerList.insert(0, _selectedCustomer);
    }

    _selectedProduct = widget.initialProduct ?? _productList.first;
    if (!_productList.contains(_selectedProduct)) {
      _productList.insert(0, _selectedProduct);
    }

    _priceController = TextEditingController(
      text: widget.initialPrice ?? 'Rp 85.000.000',
    );

    // Default expired date: 30 days from now
    final exp = DateTime.now().add(const Duration(days: 30));
    _expiredDateController.text =
        '${exp.day.toString().padLeft(2, '0')}/${exp.month.toString().padLeft(2, '0')}/${exp.year}';
  }

  @override
  void dispose() {
    _priceController.dispose();
    _expiredDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiredDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF7A00),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0D2B45),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _expiredDateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _simulateUploadFile() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pilih Dokumen PDF Proposal',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D2B45),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                title: Text(
                  'Proposal_Penawaran_${_selectedCustomer.replaceAll(' ', '_')}.pdf',
                  style: GoogleFonts.plusJakartaSans(fontSize: 13),
                ),
                subtitle: Text(
                  'Klik untuk memperbarui & generate ID Berkas baru',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: const Color(0xFF8FA1B0),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _uploadedFileName =
                        'Proposal_Penawaran_${_selectedCustomer.replaceAll(' ', '_')}.pdf';
                    _uploadedDocId = _generateDocId();
                  });
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                title: Text(
                  'Penawaran_Rs_Harapan_Semua.pdf',
                  style: GoogleFonts.plusJakartaSans(fontSize: 13),
                ),
                subtitle: Text(
                  'Klik untuk memperbarui & generate ID Berkas baru',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: const Color(0xFF8FA1B0),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _uploadedFileName = 'Penawaran_Rs_Harapan_Semua.pdf';
                    _uploadedDocId = _generateDocId();
                  });
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitProposal() async {
    final proposalData = {
      'company': _selectedCustomer,
      'product': _selectedProduct,
      'price': _priceController.text.trim(),
      'expiredDate': _expiredDateController.text.trim(),
      'fileName': _uploadedFileName,
      'docId': _uploadedDocId,
      'isDiscount': _isDiscountRequested,
      'notes': _notesController.text.trim(),
      'status': 'Menunggu Approval',
      'submittedAt': '23 Agu 2026',
    };

    // Register proposal globally for full synchronization across screens
    SalesProposalPipelineScreen.registerProposal(proposalData);

    // Navigate to Approval Screen for supervisor/manager review
    final approvalResult = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => ApprovalProposalScreen(proposalData: proposalData),
      ),
    );

    if (mounted) {
      Navigator.of(context).pop(
        approvalResult ??
            {'status': 'Menunggu Approval', 'proposal': proposalData},
      );
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
                    'Buat Proposal',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                ],
              ),
            ),

            // ── 2. MAIN CONTENT ─────────────────────────────────────────────
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
                        fit: StackFit.expand,
                        children: [
                          // SVG background
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

                          // Scrollable Form
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
                                // ── 1. PROSPEK / CUSTOMER ────────────────────
                                Text(
                                  'Prospek / Customer',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF7A00),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                _buildCustomerSelector(),
                                const SizedBox(height: 12),

                                // ── 2. PRODUK / LAYANAN ──────────────────────
                                Text(
                                  'Produk / Layanan',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF7A00),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                _buildProductSelector(),
                                const SizedBox(height: 12),

                                // ── 3. NILAI PENAWARAN & TANGGAL EXPIRED ─────
                                Row(
                                  children: [
                                    // Nilai Penawaran
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Nilai Penawaran',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFFFF7A00),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            height: 42,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: const Color(0xFFFF7A00),
                                                width: 1.2,
                                              ),
                                            ),
                                            child: TextField(
                                              controller: _priceController,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(
                                                      0xFF0D2B45,
                                                    ),
                                                  ),
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 10,
                                                    ),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Tanggal Expired
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Tanggal Expired',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFFFF7A00),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          GestureDetector(
                                            onTap: _selectExpiredDate,
                                            child: Container(
                                              height: 42,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFFF7A00,
                                                  ),
                                                  width: 1.2,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          10,
                                                        ),
                                                    child: const Icon(
                                                      Icons
                                                          .calendar_today_outlined,
                                                      color: Color(0xFFFF7A00),
                                                      size: 18,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 1.2,
                                                    height: 42,
                                                    color: const Color(
                                                      0xFFFF7A00,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: Text(
                                                        _expiredDateController
                                                            .text,
                                                        style:
                                                            GoogleFonts.plusJakartaSans(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  const Color(
                                                                    0xFF0D2B45,
                                                                  ),
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // ── 4. LAMPIRAN DOKUMEN ──────────────────────
                                Text(
                                  'Lampiran Dokumen',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF7A00),
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Dashed Upload Area
                                GestureDetector(
                                  onTap: _simulateUploadFile,
                                  child: Container(
                                    width: double.infinity,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: const Color(0xFFFF7A00),
                                        width: 1.2,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.cloud_upload_outlined,
                                            color: Color(0xFFFF7A00),
                                            size: 26,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Ketuk untuk ungggah PDF proposal',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF8FA1B0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Uploaded File Pill
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFFF7A00),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.red,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              _uploadedFileName,
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF0D2B45),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 3),
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFFF7A00)
                                                        .withValues(alpha: 0.12),
                                                    borderRadius:
                                                        BorderRadius.circular(6),
                                                  ),
                                                  child: Text(
                                                    'ID Berkas: $_uploadedDocId',
                                                    style: GoogleFonts
                                                        .plusJakartaSans(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w700,
                                                      color: const Color(
                                                          0xFFFF7A00),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _simulateUploadFile,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF3F6F8),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.swap_horiz,
                                            color: Color(0xFFFF7A00),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // ── 5. AJUKAN DISKON / HARGA KHUSUS ──────────
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Ajukan diskon / harga khusus',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF0D2B45),
                                          ),
                                        ),
                                        Text(
                                          'Perlu approval supervisor',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11,
                                            color: const Color(0xFF4A6070),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Switch(
                                      value: _isDiscountRequested,
                                      activeThumbColor: const Color(0xFFFF7A00),
                                      activeTrackColor: const Color(0xFF0D2B45)
                                          .withValues(alpha: 0.25),
                                      onChanged: (val) {
                                        setState(() {
                                          _isDiscountRequested = val;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // ── 6. CATATAN NEGOSIASI ─────────────────────
                                Text(
                                  'Catatan Negosiasi',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF7A00),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color(0xFFFF7A00),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _notesController,
                                    minLines: 4,
                                    maxLines: 5,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: const Color(0xFF0D2B45),
                                    ),
                                    decoration: InputDecoration(
                                      hintText:
                                          'Catatan tambahan untuk proposal ini',
                                      hintStyle: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: const Color(0xFF8FA1B0),
                                      ),
                                      contentPadding: const EdgeInsets.all(14),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // ── 7. TOMBOL KIRIM PROPOSAL ─────────────────
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF7A00),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 3,
                                    ),
                                    onPressed: _submitProposal,
                                    child: Text(
                                      'Kirim Proposal',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSelector() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isCustomerDropdownOpen = !_isCustomerDropdownOpen;
              _isProductDropdownOpen = false;
            });
          },
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFF7A00), width: 1.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedCustomer,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  _isCustomerDropdownOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFFFF7A00),
                  size: 26,
                ),
              ],
            ),
          ),
        ),
        if (_isCustomerDropdownOpen)
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFF7A00).withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: _customerList.map((cust) {
                final isSel = cust == _selectedCustomer;
                return ListTile(
                  dense: true,
                  title: Text(
                    cust,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      color: isSel
                          ? const Color(0xFFFF7A00)
                          : const Color(0xFF0D2B45),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedCustomer = cust;
                      _isCustomerDropdownOpen = false;
                    });
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildProductSelector() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isProductDropdownOpen = !_isProductDropdownOpen;
              _isCustomerDropdownOpen = false;
            });
          },
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFF7A00), width: 1.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedProduct,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D2B45),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  _isProductDropdownOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFFFF7A00),
                  size: 26,
                ),
              ],
            ),
          ),
        ),
        if (_isProductDropdownOpen)
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFF7A00).withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: _productList.map((prod) {
                final isSel = prod == _selectedProduct;
                return ListTile(
                  dense: true,
                  title: Text(
                    prod,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      color: isSel
                          ? const Color(0xFFFF7A00)
                          : const Color(0xFF0D2B45),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedProduct = prod;
                      _isProductDropdownOpen = false;
                    });
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
