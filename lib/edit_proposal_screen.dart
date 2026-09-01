import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detail_prospek_screen.dart';
import 'sales_proposal_pipeline_screen.dart';

class EditProposalScreen extends StatefulWidget {
  final Map<String, dynamic> proposalData;

  const EditProposalScreen({
    super.key,
    required this.proposalData,
  });

  @override
  State<EditProposalScreen> createState() => _EditProposalScreenState();
}

class _EditProposalScreenState extends State<EditProposalScreen> {
  late TextEditingController _customerController;
  late TextEditingController _priceController;
  late TextEditingController _expiredDateController;
  late TextEditingController _negotiationNoteController;
  late TextEditingController _changeReasonController;

  String _selectedProduct = 'Layanan Medis Utama (Core Medical Services)';
  final List<String> _productList = [
    'Layanan Medis Utama (Core Medical Services)',
    'Layanan Pemeriksaan & Diagnosis (Diagnostic & Laboratory)',
    'Layanan Unggulan (Center of Excellence)',
    'Layanan Digital & Modifikasi (Modern Services)',
    'Program Keanggotaan & Komunitas (Hospital Programs)',
    'Marcon Enterprise CRM',
  ];

  late String _fileName;
  late String _docId;
  late String _discountText;

  @override
  void initState() {
    super.initState();
    final p = widget.proposalData;
    final company = p['company'] ?? p['name'] ?? 'Nama Customer';
    _customerController = TextEditingController(text: company);
    _priceController = TextEditingController(
      text: p['price'] ?? p['potensi'] ?? 'Rp 120.000.000',
    );
    _expiredDateController = TextEditingController(
      text: p['expiredDate'] ?? '25/08/2026',
    );
    _negotiationNoteController = TextEditingController(
      text: p['negotiationNote'] ?? p['notes'] ?? '',
    );
    _changeReasonController = TextEditingController();

    _docId = p['docId'] ?? 'Nomor Proposal';
    _fileName = p['fileName'] ?? 'Penawaran_Rs_Harapan_Semua.pdf';
    _discountText = p['discountText'] ?? 'Diajukan 5%, status : menunggu approval';

    final prod = p['product'] ?? '';
    if (_productList.contains(prod)) {
      _selectedProduct = prod;
    }
  }

  @override
  void dispose() {
    _customerController.dispose();
    _priceController.dispose();
    _expiredDateController.dispose();
    _negotiationNoteController.dispose();
    _changeReasonController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiredDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 30)),
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      final formatted =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      setState(() {
        _expiredDateController.text = formatted;
      });
    }
  }

  void _uploadRevisionFile() {
    setState(() {
      _fileName = "Proposal_Revisi_${_customerController.text.replaceAll(' ', '_')}.pdf";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File revisi "$_fileName" berhasil diunggah!'),
        backgroundColor: const Color(0xFF5BA32A),
      ),
    );
  }

  void _saveChanges({required bool resend}) {
    final price = _priceController.text.trim();
    final expiredDate = _expiredDateController.text.trim();
    final negNote = _negotiationNoteController.text.trim();
    final reason = _changeReasonController.text.trim();
    final company = _customerController.text.trim();

    // Prepare updated proposal map
    final updated = Map<String, dynamic>.from(widget.proposalData);
    updated['company'] = company;
    updated['product'] = _selectedProduct;
    updated['price'] = price.startsWith('Rp') ? price : 'Rp $price';
    updated['expiredDate'] = expiredDate;
    updated['fileName'] = _fileName;
    updated['negotiationNote'] = negNote;
    updated['notes'] = negNote;
    updated['changeReason'] = reason;

    if (resend) {
      updated['status'] = 'Review';
      updated['category'] = 'Berjalan';
      updated['progressNote'] = 'Kirim ulang proposal ke Supervisor';
      updated['progressNoteColor'] = const Color(0xFFFF7A00);
    }

    // Register updated proposal in global store to sync across all screens
    SalesProposalPipelineScreen.registerProposal(updated);

    // Add activity to global DetailProspekScreen.companyActivities
    final key = company.trim().toLowerCase();
    final now = DateTime.now();
    final dateStr =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final actDesc = resend
        ? 'Proposal direvisi & dikirim ulang ke Supervisor. Catatan: ${negNote.isNotEmpty ? negNote : "Pembaruan penawaran"}'
        : 'Proposal diperbarui. Catatan: ${negNote.isNotEmpty ? negNote : "Pembaruan data proposal"}';

    DetailProspekScreen.companyActivities.putIfAbsent(key, () => []);
    DetailProspekScreen.companyActivities[key]!.insert(
      0,
      ActivityItem(
        title: resend ? 'Proposal Dikirim Ulang' : 'Edit Proposal (Draft)',
        date: dateStr,
        time: timeStr,
        desc: actDesc,
        isCompleted: true,
        type: 'proposal',
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          resend
              ? 'Proposal berhasil diperbarui & dikirim ulang!'
              : 'Perubahan proposal berhasil disimpan!',
        ),
        backgroundColor: const Color(0xFF5BA32A),
      ),
    );

    Navigator.pop(context, {
      'action': resend ? 'resend' : 'save',
      'proposal': updated,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF7A00),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── HEADER ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Edit Proposal',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0D2B45),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _docId,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0D2B45),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── MAIN FORM CONTENT ───────────────────────────────────────────
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
                    color: const Color(0xFFE2E7EC),
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
                          // ── Field 1: Prospek / Customer (Readonly) ─────────
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
                            width: double.infinity,
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
                              enabled: false,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: const Color(0xFF0D2B45),
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '*Tidak bisa diubah setelah proposal dibuat',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: const Color(0xFF5A6E7F),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // ── Field 2: Produk / Layanan (Dropdown) ───────────
                          Text(
                            'Produk / Layanan',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF7A00),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFFF7A00),
                                width: 1.2,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedProduct,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xFFFF7A00),
                                ),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0D2B45),
                                ),
                                items: _productList.map((prod) {
                                  return DropdownMenuItem<String>(
                                    value: prod,
                                    child: Text(
                                      prod,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedProduct = val;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // ── Field 3 & 4: Nilai Penawaran & Tanggal Expired ──
                          Row(
                            children: [
                              // Nilai Penawaran
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nilai Penawaran',
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
                                        controller: _priceController,
                                        keyboardType: TextInputType.text,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          color: const Color(0xFF0D2B45),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              EdgeInsets.symmetric(
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

                              // Tanggal Expired
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tanggal Expired',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFF7A00),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    GestureDetector(
                                      onTap: _selectExpiredDate,
                                      child: AbsorbPointer(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                              color: const Color(0xFFFF7A00),
                                              width: 1.2,
                                            ),
                                          ),
                                          child: TextField(
                                            controller: _expiredDateController,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              color: const Color(0xFF0D2B45),
                                              fontWeight: FontWeight.w600,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // ── Field 5: Lampiran Dokumen ──────────────────────
                          Text(
                            'Lampiran Dokumen',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF7A00),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
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
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _fileName,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0D2B45),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  'Terkirim',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: const Color(0xFF8FA1B0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _uploadRevisionFile,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFFF7A00),
                                  width: 1.2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Text(
                                '+ Unggah versi revisi',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF7A00),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // ── Field 6: Diskon / Harga Khusus Box ─────────────
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEADBCE),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFFF7A00),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Diskon / Harga Khusus',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFFF7A00),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _discountText,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: const Color(0xFF5A6E7F),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF7A00),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Pending',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // ── Field 7: Update Catatan Negosiasi ──────────────
                          Text(
                            'Update Catatan Negosiasi',
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
                              controller: _negotiationNoteController,
                              maxLines: 3,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: const Color(0xFF0D2B45),
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    'Tambahkan perkembangan negosiasi terbaru disini',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: const Color(0xFF90A4AE),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // ── Field 8: Alasan Perubahan ──────────────────────
                          Text(
                            'Alasan Perubahan',
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
                              controller: _changeReasonController,
                              maxLines: 3,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: const Color(0xFF0D2B45),
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    'Wajib diisi jika mengubah nilai dan produk',
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

                          // ── Action Buttons (Simpan & Simpan + Kirim Ulang) ──
                          Row(
                            children: [
                              // Simpan Button
                              Expanded(
                                child: SizedBox(
                                  height: 44,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(
                                        color: Color(0xFFFF7A00),
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                    ),
                                    onPressed: () => _saveChanges(resend: false),
                                    child: Text(
                                      'Simpan',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFF7A00),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Simpan & Kirim Ulang Button
                              Expanded(
                                child: SizedBox(
                                  height: 44,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF7A00),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      elevation: 2,
                                    ),
                                    onPressed: () => _saveChanges(resend: true),
                                    child: Text(
                                      'Simpan & Kirim Ulang',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
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
}
