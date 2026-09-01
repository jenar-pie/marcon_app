import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LihatRiwayatLogScreen extends StatefulWidget {
  const LihatRiwayatLogScreen({super.key});

  // Global shared dataset for history activities
  static final List<Map<String, dynamic>> globalActivities = [
    {
      'id': '1',
      'waktu': '20 agustus 11.30',
      'jenis': 'Telepon',
      'customer': 'PT Kimia Farma Tbk',
      'hasil': 'Pengenalan Produk',
      'nextAction': 'Follow up 22 Agust',
      'marketing': 'Budi S',
      'lokasi': 'Jl. Veteran No. 9, Jakarta',
      'checkIn': '08.30',
      'checkOut': '10.02',
      'durasi': '48 menit',
      'notulensi':
          'Diskusi pengenalan produk alat medis baru dengan tim procurement.',
      'checkInImg': 'https://images.unsplash.com/photo-1577495508048-b635879837f1?auto=format&fit=crop&w=500&q=80',
      'checkOutImg': 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=500&q=80',
      'range': 'Hari ini',
    },
    {
      'id': '2',
      'waktu': '22 agustus 09.30',
      'jenis': 'Kunjungan',
      'customer': 'BPJS Kesehatan Jakarta',
      'hasil': 'Pemaparan proposal',
      'nextAction': 'Follow up 29 Agust',
      'marketing': 'cantika',
      'lokasi': 'Jl. Letjen Suprapto, Cempaka Putih',
      'checkIn': '09.15',
      'checkOut': '11.00',
      'durasi': '105 menit',
      'notulensi': 'Presentasi proposal teknis & sistem integrasi lab.',
      'checkInImg': 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&w=500&q=80',
      'checkOutImg': 'https://images.unsplash.com/photo-1600880292203-757bb62b4baf?auto=format&fit=crop&w=500&q=80',
      'range': '3 Hari',
    },
    {
      'id': '3',
      'waktu': '29 agustus 15.30',
      'jenis': 'Whatsapp',
      'customer': 'Halodoc Indonesia',
      'hasil': 'Pengambilan produk',
      'nextAction': 'closing',
      'marketing': 'Budi, cantika',
      'lokasi': 'Kuningan, Jakarta Selatan',
      'checkIn': '15.10',
      'checkOut': '16.00',
      'durasi': '50 menit',
      'notulensi': 'Penandatanganan berita acara serah terima dokumen & PO.',
      'checkInImg': 'https://images.unsplash.com/photo-1556761175-5973dc0f32e7?auto=format&fit=crop&w=500&q=80',
      'checkOutImg': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=500&q=80',
      'range': 'Hari ini',
    },
    {
      'id': '4',
      'waktu': '15 agustus 10.00',
      'jenis': 'Meeting',
      'customer': 'Siloam Hospitals Group',
      'hasil': 'Negosiasi Harga',
      'nextAction': 'Kirim Kontrak',
      'marketing': 'Budi S',
      'lokasi': 'Lippo Karawaci, Tangerang',
      'checkIn': '10.00',
      'checkOut': '11.30',
      'durasi': '90 menit',
      'notulensi': 'Finalisasi diskon volume pembelian unit reagen.',
      'checkInImg': 'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&w=500&q=80',
      'checkOutImg': 'https://images.unsplash.com/photo-1542744836-561584347714?auto=format&fit=crop&w=500&q=80',
      'range': '1 Minggu',
    },
    {
      'id': '5',
      'waktu': '10 agustus 14.00',
      'jenis': 'Kunjungan',
      'customer': 'Bio Farma (Persero)',
      'hasil': 'Demo Alat Medis',
      'nextAction': 'Follow Up Trial',
      'marketing': 'cantika',
      'lokasi': 'Jl. Pasteur No. 28, Bandung',
      'checkIn': '13.45',
      'checkOut': '15.45',
      'durasi': '120 menit',
      'notulensi': 'Uji coba operasional mesin otomatisasi darah.',
      'checkInImg': 'https://images.unsplash.com/photo-1582750433449-648ed127bb54?auto=format&fit=crop&w=500&q=80',
      'checkOutImg': 'https://images.unsplash.com/photo-1551076805-e1869033e561?auto=format&fit=crop&w=500&q=80',
      'range': '1 Bulan',
    },
  ];

  static void addGlobalActivity(Map<String, dynamic> item) {
    globalActivities.insert(0, item);
  }

  @override
  State<LihatRiwayatLogScreen> createState() => _LihatRiwayatLogScreenState();
}

class _LihatRiwayatLogScreenState extends State<LihatRiwayatLogScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedJenis = 'Semua jenis aktivitas';
  String _selectedTimeRange = 'Hari ini';

  final List<String> _jenisOptions = [
    'Semua jenis aktivitas',
    'Telepon',
    'Kunjungan',
    'Whatsapp',
    'Meeting',
    'Presentasi',
  ];

  final List<String> _timeRangeOptions = [
    'Hari ini',
    '3 Hari',
    '1 Minggu',
    '1 Bulan',
    '3 Bulan',
    '6 Bulan',
    '1 Tahun',
  ];

  late Map<String, dynamic> _selectedBukti;

  @override
  void initState() {
    super.initState();
    _selectedBukti = LihatRiwayatLogScreen.globalActivities.first;
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter dataset based on search, jenis, and date range
  List<Map<String, dynamic>> get _filteredActivities {
    return LihatRiwayatLogScreen.globalActivities.where((item) {
      // Search text match
      final query = _searchController.text.trim().toLowerCase();
      final matchSearch =
          query.isEmpty ||
          item['customer'].toString().toLowerCase().contains(query) ||
          item['jenis'].toString().toLowerCase().contains(query) ||
          item['hasil'].toString().toLowerCase().contains(query) ||
          item['marketing'].toString().toLowerCase().contains(query);

      // Jenis match
      final matchJenis =
          _selectedJenis == 'Semua jenis aktivitas' ||
          item['jenis'].toString().toLowerCase() ==
              _selectedJenis.toLowerCase();

      // Range match
      final itemRange = item['range']?.toString() ?? 'Hari ini';
      bool matchRange = true;
      if (_selectedTimeRange == 'Hari ini') {
        matchRange = itemRange == 'Hari ini';
      } else if (_selectedTimeRange == '3 Hari') {
        matchRange = itemRange == 'Hari ini' || itemRange == '3 Hari';
      } else if (_selectedTimeRange == '1 Minggu') {
        matchRange =
            itemRange == 'Hari ini' ||
            itemRange == '3 Hari' ||
            itemRange == '1 Minggu';
      } else if (_selectedTimeRange == '1 Bulan') {
        matchRange =
            itemRange == 'Hari ini' ||
            itemRange == '3 Hari' ||
            itemRange == '1 Minggu' ||
            itemRange == '1 Bulan';
      }

      return matchSearch && matchJenis && matchRange;
    }).toList();
  }

  void _showImageDialog(String title, String imageUrl) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bukti $title',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color(0xFF0D2B45),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 240,
                  color: Colors.grey[300],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.photo, size: 48, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          'Gambar Bukti $title',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

  void _showLocationDialog(String lokasiName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Color(0xFF2E7D32)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Detail Lokasi Check-in',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D2B45),
                ),
              ),
            ),
          ],
        ),
        content: Text(
          lokasiName,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: const Color(0xFF0D2B45),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D2B45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Tutup',
              style: GoogleFonts.plusJakartaSans(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredActivities;

    // Automatically update Bukti card to follow active filter selection
    final Map<String, dynamic>? activeBukti =
        filteredList.contains(_selectedBukti)
        ? _selectedBukti
        : (filteredList.isNotEmpty ? filteredList.first : null);

    return Scaffold(
      backgroundColor: const Color(0xFF0D2B45), // Navy Header Background
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── 1. NAVY HEADER BAR & FILTERS ────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  // App Bar Title + Back Button
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Lihat riwayat & log',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Filter Inputs Row
                  Row(
                    children: [
                      // Search Field
                      Expanded(
                        flex: 5,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: GoogleFonts.plusJakartaSans(fontSize: 12),
                            decoration: InputDecoration(
                              hintText: 'Cari customer/prospek',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 18,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Jenis Dropdown
                      Expanded(
                        flex: 6,
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedJenis,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 20,
                                color: Color(0xFF0D2B45),
                              ),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0D2B45),
                              ),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedJenis = val);
                                }
                              },
                              items: _jenisOptions.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Date Range Dropdown
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedTimeRange,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 20,
                              color: Color(0xFF0D2B45),
                            ),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0D2B45),
                            ),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedTimeRange = val);
                              }
                            },
                            items: _timeRangeOptions.map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── 2. WHITE CONTAINER MAIN CONTENT ─────────────────────────────
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
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── CARD 1: BUKTI CHECK IN-OUT ──
                      _buildBuktiCheckInOutCard(activeBukti),
                      const SizedBox(height: 24),

                      // ── CARD 2: HISTORY ACTIVITY EXCEL-STYLE TABLE HEADER ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'History Activity',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0D2B45),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFECE0),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFFF9E44)
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.swipe_left_rounded,
                                  size: 14,
                                  color: Color(0xFFFF7A00),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Geser tabel ➔',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF7A00),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Beautiful Excel Table
                      _buildExcelStyleTable(filteredList),
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

  // ── WIDGET BUKTI CHECK IN-OUT CARD ─────────────────────────────────────────
  Widget _buildBuktiCheckInOutCard(Map<String, dynamic>? data) {
    if (data == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFE5ECEF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            'Tidak ada data bukti check in-out yang sesuai dengan filter.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0D2B45),
            ),
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE5ECEF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Dashed container for check-in and check-out photos
          CustomPaint(
            painter: _DashedRectPainter(
              color: Colors.black.withValues(alpha: 0.3),
              strokeWidth: 1.2,
              gap: 4,
            ),
            child: Container(
              width: 135,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Check-in',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => _showImageDialog(
                      'Check-in',
                      data['checkInImg'] as String,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        data['checkInImg'] as String,
                        height: 60,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(
                          height: 60,
                          color: const Color(0xFF90A4AE),
                          child: const Center(
                            child: Icon(
                              Icons.meeting_room,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Check-out',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => _showImageDialog(
                      'Check-out',
                      data['checkOutImg'] as String,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        data['checkOutImg'] as String,
                        height: 60,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(
                          height: 60,
                          color: const Color(0xFF78909C),
                          child: const Center(
                            child: Icon(Icons.groups, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Right: Log details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bukti Check in-out',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D2B45),
                  ),
                ),
                const SizedBox(height: 12),

                _buildInfoRow(
                  'Customer',
                  data['customer'] as String,
                  isValueBold: true,
                ),
                const SizedBox(height: 4),
                _buildInfoRow('Check-in', data['checkIn'] as String),
                const SizedBox(height: 4),
                _buildInfoRow('Check-out', data['checkOut'] as String),
                const SizedBox(height: 4),
                _buildInfoRow(
                  'Durasi',
                  data['durasi'] as String,
                  isValueBold: true,
                ),
                const SizedBox(height: 4),
                _buildInfoRow('Lokasi', data['lokasi'] as String),
                const SizedBox(height: 10),

                Text(
                  data['notulensi'] as String? ?? 'Catatan aktivitas/notulensi',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isValueBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 75,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: isValueBold ? FontWeight.bold : FontWeight.w600,
              color: const Color(0xFF0D2B45),
            ),
          ),
        ),
      ],
    );
  }

  // ── BEAUTIFIED EXCEL-STYLE TABLE FOR HISTORY ACTIVITY ─────────────────────
  Widget _buildExcelStyleTable(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF7C59F),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'Tidak ada riwayat aktivitas yang sesuai filter.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0D2B45),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6BC88),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE59B5C), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7A00).withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(
              color: const Color(0xFFE09A5B).withValues(alpha: 0.7),
              width: 0.8,
            ),
            columnWidths: const {
              0: FixedColumnWidth(115), // Waktu
              1: FixedColumnWidth(110), // Jenis
              2: FixedColumnWidth(125), // Customer/prospek
              3: FixedColumnWidth(125), // Hasil
              4: FixedColumnWidth(125), // Next Action
              5: FixedColumnWidth(100), // Marketing
              6: FixedColumnWidth(90), // Lokasi
            },
            children: [
              // TABLE HEADER ROW (Excel styled header)
              TableRow(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF29B4F), Color(0xFFEE8D3B)],
                  ),
                ),
                children: [
                  _buildHeaderCell('Waktu', Icons.calendar_today_rounded),
                  _buildHeaderCell('Jenis', Icons.category_rounded),
                  _buildHeaderCell('Customer/prospek', Icons.business_rounded),
                  _buildHeaderCell('Hasil', Icons.assignment_turned_in_rounded),
                  _buildHeaderCell('Next Action', Icons.next_plan_rounded),
                  _buildHeaderCell('Marketing', Icons.person_rounded),
                  _buildHeaderCell('Lokasi', Icons.place_rounded),
                ],
              ),

              // TABLE DATA ROWS
              ...items.map((item) {
                final bool isSelected = _selectedBukti['id'] == item['id'];

                return TableRow(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFFDBBD)
                        : Colors.transparent,
                  ),
                  children: [
                    // Waktu Cell
                    _buildTextCell(
                      item['waktu'] as String,
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedBukti = item),
                    ),

                    // Jenis Cell (Pill Badge)
                    TableCell(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedBukti = item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 8,
                          ),
                          child: _buildJenisBadge(item['jenis'] as String),
                        ),
                      ),
                    ),

                    // Customer Cell
                    _buildTextCell(
                      item['customer'] as String,
                      isBold: true,
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedBukti = item),
                    ),

                    // Hasil Cell
                    _buildTextCell(
                      item['hasil'] as String,
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedBukti = item),
                    ),

                    // Next Action Cell (Badge)
                    TableCell(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedBukti = item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 8,
                          ),
                          child: _buildNextActionBadge(
                            item['nextAction'] as String,
                          ),
                        ),
                      ),
                    ),

                    // Marketing Cell
                    _buildTextCell(
                      item['marketing'] as String,
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedBukti = item),
                    ),

                    // Lokasi Cell (Green Action Button)
                    TableCell(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedBukti = item);
                          _showLocationDialog(item['lokasi'] as String);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 8,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 11,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'Lokasi',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Header Cell Helper
  Widget _buildHeaderCell(String text, IconData icon) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 12, color: const Color(0xFF0D2B45)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0D2B45),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Text Cell Helper
  Widget _buildTextCell(
    String text, {
    bool isBold = false,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return TableCell(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isSelected
                  ? const Color(0xFF000000)
                  : const Color(0xFF0D2B45),
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }

  // Jenis Badge Helper
  Widget _buildJenisBadge(String jenis) {
    Color bg = const Color(0xFF0D2B45);
    IconData icon = Icons.info_outline;

    switch (jenis.toLowerCase()) {
      case 'telepon':
        bg = const Color(0xFF1565C0);
        icon = Icons.phone_in_talk;
        break;
      case 'kunjungan':
        bg = const Color(0xFFE65100);
        icon = Icons.directions_walk;
        break;
      case 'whatsapp':
        bg = const Color(0xFF2E7D32);
        icon = Icons.chat;
        break;
      case 'meeting':
        bg = const Color(0xFF6A1B9A);
        icon = Icons.groups;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: bg.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: bg),
          const SizedBox(width: 4),
          Text(
            jenis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: bg,
            ),
          ),
        ],
      ),
    );
  }

  // Next Action Badge Helper
  Widget _buildNextActionBadge(String nextAction) {
    final bool isClosing = nextAction.toLowerCase() == 'closing';
    final color = isClosing ? const Color(0xFF2E7D32) : const Color(0xFFD87010);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        nextAction,
        textAlign: TextAlign.center,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

// ── CUSTOM PAINTER FOR DASHED BORDER ────────────────────────────────────────
class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  _DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(16),
        ),
      );

    final Path dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
