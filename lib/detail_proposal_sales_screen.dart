import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'detail_prospek_screen.dart';
import 'edit_proposal_screen.dart';

class DetailProposalSalesScreen extends StatefulWidget {
  final Map<String, dynamic> proposalData;

  const DetailProposalSalesScreen({
    super.key,
    required this.proposalData,
  });

  @override
  State<DetailProposalSalesScreen> createState() =>
      _DetailProposalSalesScreenState();
}

class _DetailProposalSalesScreenState extends State<DetailProposalSalesScreen> {
  late Map<String, dynamic> _data;

  final List<String> _stages = [
    'Draft',
    'Send',
    'Review',
    'Negotiation',
    'Approved',
    'Deal',
  ];

  @override
  void initState() {
    super.initState();
    _data = Map<String, dynamic>.from(widget.proposalData);
  }

  int _getStageIndex(String status) {
    switch (status) {
      case 'Draft':
        return 0;
      case 'Send':
        return 1;
      case 'Review':
        return 2;
      case 'Negotiation':
        return 3;
      case 'Approved':
      case 'Disetujui':
        return 4;
      case 'Deal':
        return 5;
      default:
        return 2; // Default to Review
    }
  }



  void _openEditProposalScreen() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProposalScreen(proposalData: _data),
      ),
    );

    if (result != null && mounted) {
      final updated = result['proposal'] as Map<String, dynamic>?;
      if (updated != null) {
        setState(() {
          _data = updated;
        });
      }
    }
  }

  void _markAsDeal() {
    setState(() {
      _data['status'] = 'Deal';
      _data['category'] = 'Deal';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Proposal telah ditandai sebagai DEAL!'),
        backgroundColor: Color(0xFF5BA32A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final company = _data['company'] ?? 'Nama Customer';
    final product = _data['product'] ?? 'Nama produk yang diminati';
    final price = _data['price'] ?? 'Rp 120.000.000';
    final docId = _data['docId'] ?? 'Nomor Proposal';
    final status = _data['status'] ?? 'Review';
    final submittedAt = _data['submittedAt'] ?? _data['date'] ?? '15 Agu 2026';
    final expiredDate = _data['expiredDate'] ?? '25 Agu 2026';
    final probability = _data['probability'] ?? '80%';
    final bool isDiscount = _data['isDiscount'] ?? true;
    final String discountNote = _data['negotiationNote'] ??
        _data['notes'] ??
        'Menunggu approval supervisor';

    final currentStageIdx = _getStageIndex(status);

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
                      onTap: () => Navigator.pop(context, _data),
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
                    'Detail Proposal',
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
                          // ── Top Card (Nomor Proposal & Status) ────────────
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFBCCCDA),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        docId,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF0D2B45),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        company,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF4A6070),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'produk : $product',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: const Color(0xFF4A6070),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF7A00),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    status,
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
                          const SizedBox(height: 16),

                          // ── Tahapan Status Stepper ─────────────────────────
                          Text(
                            'Tahapan Status',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0D2B45),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFBCCCDA),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: List.generate(_stages.length, (idx) {
                                final bool isReached = idx <= currentStageIdx;
                                return Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: idx < _stages.length - 1 ? 4 : 0,
                                    ),
                                    child: Column(
                                      children: [
                                        // Segment bar
                                        Container(
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: isReached
                                                ? const Color(0xFF0D2B45)
                                                : const Color(0xFFE2E7EC),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        // Label text
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            _stages[idx],
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 9,
                                              fontWeight: isReached
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                              color: const Color(0xFF0D2B45),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ── Detail Rows (Nilai Penawaran, Dates, etc.) ────
                          _buildDetailRow('Nilai Penawaran', price,
                              isBoldValue: true),
                          _buildDetailRow('Tanggal Dibuat', submittedAt),
                          _buildDetailRow('Tanggal Dikirim', submittedAt),
                          _buildDetailRow('Expired', expiredDate,
                              valueColor: const Color(0xFFFF3B30)),
                          _buildDetailRow('Probability Closing', probability),
                          _buildDetailRow('Nama Marketing', 'Cantika'),
                          const SizedBox(height: 16),

                          // ── Status Ajuan Diskon Card ──────────────────────
                          Text(
                            'Status Ajuan Diskon',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0D2B45),
                            ),
                          ),
                          const SizedBox(height: 8),
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
                                        isDiscount
                                            ? 'Diskon 5% diajukan'
                                            : 'Tidak ada diskon',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFFF7A00),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        discountNote,
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
                          const SizedBox(height: 16),

                          // ── Riwayat Negosiasi Timeline ────────────────────
                          Text(
                            'Riwayat Negosiasi',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0D2B45),
                            ),
                          ),
                          const SizedBox(height: 12),

                          Builder(
                            builder: (context) {
                              final compKey = company.trim().toLowerCase();
                              final actList = DetailProspekScreen
                                      .companyActivities[compKey] ??
                                  [];

                              if (actList.isNotEmpty) {
                                return Column(
                                  children: List.generate(actList.length, (idx) {
                                    final act = actList[idx];
                                    final bool isProp = act.type == 'proposal' ||
                                        act.title.toLowerCase().contains('proposal');
                                    return _buildActivityTimelineRow(
                                      title: act.title,
                                      date: act.date,
                                      time: act.time,
                                      desc: act.desc,
                                      isCompleted: act.isCompleted,
                                      isProposal: isProp,
                                      isLast: idx == actList.length - 1,
                                    );
                                  }),
                                );
                              } else {
                                return Column(
                                  children: [
                                    _buildActivityTimelineRow(
                                      title: 'Pengajuan Proposal Internal',
                                      date: '16 Agu 2026',
                                      time: '10:00',
                                      desc:
                                          'Proposal terkirim ke PIC, menunggu review internal',
                                      isCompleted: true,
                                      isProposal: true,
                                      isLast: false,
                                    ),
                                    _buildActivityTimelineRow(
                                      title: 'Pengajuan Diskon & Negosiasi',
                                      date: '18 Agu 2026',
                                      time: '14:30',
                                      desc:
                                          'Customer minta diskon 5% karena volume besar, diajukan ke Supervisor',
                                      isCompleted: true,
                                      isProposal: true,
                                      isLast: true,
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 24),

                          // ── Bottom Action Buttons ─────────────────────────
                          Row(
                            children: [
                              // Edit Proposal Button (Outline)
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
                                    onPressed: _openEditProposalScreen,
                                    child: Text(
                                      'Edit Proposal',
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

                              // Tandai Deal Button (Solid Orange)
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
                                    onPressed: _markAsDeal,
                                    child: Text(
                                      'Tandai Deal',
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

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBoldValue = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D2B45),
              ),
            ),
          ),
          Text(
            ':',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D2B45),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: isBoldValue ? FontWeight.w900 : FontWeight.bold,
                color: valueColor ?? const Color(0xFF0D2B45),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTimelineRow({
    required String title,
    required String date,
    required String time,
    required String desc,
    required bool isCompleted,
    required bool isProposal,
    required bool isLast,
  }) {
    final Color dotColor = isProposal
        ? const Color(0xFFD32F2F)
        : (isCompleted ? const Color(0xFFFF7A00) : const Color(0xFF8FA1B0));

    final Color bgColor = isProposal
        ? const Color(0xFFFFF8F8)
        : const Color(0xFFF8FAFC);

    final Color borderColor = isProposal
        ? const Color(0xFFEF9A9A)
        : const Color(0xFFCBD5E1);

    final Color badgeBg = isProposal
        ? const Color(0xFFFFEBEE)
        : (isCompleted
            ? const Color(0xFFFFF3E0)
            : const Color(0xFF0D2B45).withValues(alpha: 0.08));

    final Color badgeText = isProposal
        ? const Color(0xFFC62828)
        : (isCompleted ? const Color(0xFFE65100) : const Color(0xFF0D2B45));

    final String badgeLabel = isProposal
        ? 'Proposal'
        : (isCompleted ? 'Selesai ✓' : 'Terjadwal');

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline connector (Left)
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: dotColor.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    isProposal
                        ? Icons.description_rounded
                        : (isCompleted ? Icons.check : Icons.schedule_rounded),
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 3,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: isProposal
                          ? const Color(0xFFD32F2F)
                          : (isCompleted
                              ? const Color(0xFFFF7A00)
                              : Colors.grey[350]),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Activity Card (Right)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                time.isNotEmpty ? '$date • $time' : date,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isProposal
                                      ? const Color(0xFFD32F2F)
                                      : (isCompleted
                                          ? const Color(0xFFFF7A00)
                                          : const Color(0xFF8FA1B0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badgeLabel,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: badgeText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      desc,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: const Color(0xFF4A6070),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
