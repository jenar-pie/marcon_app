import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckInCameraScreen extends StatefulWidget {
  final String mode; // 'checkin' or 'checkout'
  final String companyName;
  final String purpose;
  final String locationAddress;

  const CheckInCameraScreen({
    super.key,
    required this.mode,
    required this.companyName,
    required this.purpose,
    required this.locationAddress,
  });

  @override
  State<CheckInCameraScreen> createState() => _CheckInCameraScreenState();
}

class _CheckInCameraScreenState extends State<CheckInCameraScreen> {
  bool _isPhotoCaptured = false;
  String? _capturedTime;
  String? _capturedPhotoUrl;
  String? _capturedLocation;

  // Sample photo options for realistic camera simulation
  final List<String> _samplePhotos = [
    'https://images.unsplash.com/photo-1577495508048-b635879837f1?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&w=600&q=80',
    'https://images.unsplash.com/photo-1600880292203-757bb62b4baf?auto=format&fit=crop&w=600&q=80',
  ];

  void _takePhoto() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');

    setState(() {
      _isPhotoCaptured = true;
      _capturedTime = '$hour:$minute WIB';
      _capturedLocation = widget.locationAddress;
      // Select sample photo based on mode
      _capturedPhotoUrl = widget.mode == 'checkin'
          ? _samplePhotos[0]
          : _samplePhotos[1];
    });
  }

  void _retakePhoto() {
    setState(() {
      _isPhotoCaptured = false;
      _capturedTime = null;
      _capturedLocation = null;
      _capturedPhotoUrl = null;
    });
  }

  void _saveCheckIn() {
    if (!_isPhotoCaptured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan ambil foto bukti terlebih dahulu!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Navigator.pop(context, {
      'mode': widget.mode,
      'time': _capturedTime,
      'photoUrl': _capturedPhotoUrl,
      'location': _capturedLocation,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isCheckIn = widget.mode == 'checkin';
    final titleText = isCheckIn ? 'Kamera Check-in' : 'Kamera Check-out';
    final buttonText = isCheckIn ? 'Simpan Check-in' : 'Simpan Check-out';

    return Scaffold(
      backgroundColor: const Color(0xFF0D2B45), // Navy Blue theme
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2B45),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          titleText,
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
            // Company Info Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: const Color(0xFFFF7A00),
              child: Row(
                children: [
                  const Icon(Icons.business, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.companyName,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          widget.purpose,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Camera Viewfinder Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isPhotoCaptured
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFFF7A00),
                      width: 3,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Viewfinder / Captured Photo Display
                        if (_isPhotoCaptured && _capturedPhotoUrl != null)
                          Image.network(
                            _capturedPhotoUrl!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              color: Colors.grey[900],
                              child: const Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 64,
                                  color: Colors.white38,
                                ),
                              ),
                            ),
                          )
                        else
                          // Simulated Live Camera Viewfinder
                          Container(
                            color: const Color(0xFF1E293B),
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.camera_rounded,
                                        size: 64,
                                        color: Colors.white54,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Arahkan kamera ke lokasi kegiatan',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Camera Grid Overlay Lines
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Divider(
                                      color: Colors.white.withValues(alpha: 0.15),
                                    ),
                                    Divider(
                                      color: Colors.white.withValues(alpha: 0.15),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    VerticalDivider(
                                      color: Colors.white.withValues(alpha: 0.15),
                                    ),
                                    VerticalDivider(
                                      color: Colors.white.withValues(alpha: 0.15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        // Shutter / Retake Overlay Button
                        Positioned(
                          bottom: 20,
                          child: _isPhotoCaptured
                              ? ElevatedButton.icon(
                                  onPressed: _retakePhoto,
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text('Foto Ulang'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: _takePhoto,
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(
                                        color: const Color(0xFFFF7A00),
                                        width: 4,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.camera_alt_rounded,
                                        color: Color(0xFFFF7A00),
                                        size: 32,
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
            ),

            // Auto-filled Details Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
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
                          'Data Otomatis Terdeteksi:',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0D2B45),
                          ),
                        ),
                        if (_isPhotoCaptured)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 12,
                                  color: Color(0xFF4CAF50),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Foto Terambil',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2E7D32),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Waktu Auto-filled
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_filled,
                          size: 16,
                          color: Color(0xFFFF7A00),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Jam Terdeteksi: ',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          _capturedTime ?? 'Otomatis terisi saat foto diambil',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _capturedTime != null
                                ? const Color(0xFF2E7D32)
                                : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Lokasi Maps Auto-filled
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Color(0xFFD32F2F),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lokasi GPS (Maps):',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                _capturedLocation ??
                                    'Otomatis terisi dari koordinat GPS',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: _capturedLocation != null
                                      ? const Color(0xFF0D2B45)
                                      : Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Save Action Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isPhotoCaptured ? _saveCheckIn : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A00),
                    disabledBackgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
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
    );
  }
}
