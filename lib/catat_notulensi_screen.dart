import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lihat_riwayat_log_screen.dart';

class CatatNotulensiScreen extends StatefulWidget {
  final Map<String, dynamic> scheduleItem;

  const CatatNotulensiScreen({
    super.key,
    required this.scheduleItem,
  });

  @override
  State<CatatNotulensiScreen> createState() => _CatatNotulensiScreenState();
}

class _CatatNotulensiScreenState extends State<CatatNotulensiScreen> {
  final TextEditingController _notulensiController = TextEditingController();

  late String _companyName;
  late String _checkInTime;
  late String _checkOutTime;
  late String _locationAddress;
  late String _checkInImg;
  late String _checkOutImg;
  late String _durationText;

  @override
  void initState() {
    super.initState();
    _companyName = widget.scheduleItem['perusahaan'] as String? ?? 'PT SUMBER MAKMUR';
    _checkInTime = widget.scheduleItem['checkInTime'] as String? ?? '08.30';
    _checkOutTime = widget.scheduleItem['checkOutTime'] as String? ?? '10.02';
    _locationAddress = widget.scheduleItem['alamat'] as String? ?? 'Jl. Swadarma Raya Kampung Baru 9';
    _checkInImg = widget.scheduleItem['checkInImg'] as String? ??
        'https://images.unsplash.com/photo-1577495508048-b635879837f1?auto=format&fit=crop&w=500&q=80';
    _checkOutImg = widget.scheduleItem['checkOutImg'] as String? ??
        'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=500&q=80';

    if (widget.scheduleItem['notulensi'] != null) {
      _notulensiController.text = widget.scheduleItem['notulensi'] as String;
    }

    _durationText = _calculateDuration(_checkInTime, _checkOutTime);
  }

  @override
  void dispose() {
    _notulensiController.dispose();
    super.dispose();
  }

  // Automatic calculation of duration between checkIn and checkOut
  String _calculateDuration(String inStr, String outStr) {
    try {
      // Normalize format like "08:30 WIB" or "08.30"
      final inClean = inStr.replaceAll('WIB', '').trim().replaceAll('.', ':');
      final outClean = outStr.replaceAll('WIB', '').trim().replaceAll('.', ':');

      final inParts = inClean.split(':');
      final outParts = outClean.split(':');

      if (inParts.length >= 2 && outParts.length >= 2) {
        final inMin = int.parse(inParts[0]) * 60 + int.parse(inParts[1]);
        final outMin = int.parse(outParts[0]) * 60 + int.parse(outParts[1]);

        int diff = outMin - inMin;
        if (diff <= 0) diff += 24 * 60; // fallback if crossed midnight
        return '$diff menit';
      }
    } catch (_) {}
    return '46 menit'; // fallback default if parsing fails
  }

  void _simpanBuktiOnly() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Bukti Check-in & Check-out tersimpan!',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF2E7D32),
      ),
    );
  }

  void _simpanCatatanAndLog() {
    final notulensiText = _notulensiController.text.trim();

    // Create activity record for LihatRiwayatLogScreen
    final newActivity = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'waktu': 'Hari ini, $_checkOutTime',
      'jenis': 'Kunjungan',
      'customer': _companyName,
      'hasil': 'Notulensi Kunjungan',
      'nextAction': 'Follow up',
      'marketing': 'User Marketing',
      'lokasi': _locationAddress,
      'checkIn': _checkInTime,
      'checkOut': _checkOutTime,
      'durasi': _durationText,
      'notulensi': notulensiText.isNotEmpty ? notulensiText : 'Meeting & Notulensi Kunjungan',
      'checkInImg': _checkInImg,
      'checkOutImg': _checkOutImg,
      'range': 'Hari ini',
    };

    // Add to global activities dataset in LihatRiwayatLogScreen
    LihatRiwayatLogScreen.addGlobalActivity(newActivity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Catatan & Log berhasil disimpan ke Riwayat!',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF2E7D32),
      ),
    );

    Navigator.pop(context, newActivity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D2B45), // Navy Header Background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2B45),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Check in & Check out',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    children: [
                      // ── 1. COMPANY NAME & DURATION ──────────────────────────
                      Text(
                        _companyName.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0D2B45),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Duration',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Text(
                            _durationText,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── 2. TWO PHOTO THUMBNAILS (CHECK IN & CHECK OUT) ──────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Photo: Check in
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  _checkInTime,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0D2B45),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 170,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.redAccent.withValues(alpha: 0.8),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      _checkInImg,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (ctx, err, stack) => Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(Icons.photo, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _locationAddress,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Bukti Check in',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0D2B45),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Right Photo: Check out
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  _checkOutTime,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0D2B45),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 170,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.redAccent.withValues(alpha: 0.8),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      _checkOutImg,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (ctx, err, stack) => Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(Icons.photo, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _locationAddress,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Bukti Check in-out',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0D2B45),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // ── 3. SIMPAN BUKTI BUTTON ───────────────────────────────
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: _simpanBuktiOnly,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D2B45),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Simpan Bukti',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // ── 4. NOTULENSI TEXT CONTAINER ──────────────────────────
                      Container(
                        width: double.infinity,
                        height: 220,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF91A7B4).withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _notulensiController,
                          maxLines: null,
                          expands: true,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: const Color(0xFF0D2B45),
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Notulensi hari ini.........',
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: const Color(0xFF0D2B45).withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ── 5. SIMPAN CATATAN BUTTON ─────────────────────────────
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: _simpanCatatanAndLog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D2B45),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Simpan Catatan',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
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
}
