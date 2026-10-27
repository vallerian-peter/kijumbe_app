import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/core.dart';

class LocationPinpointResult {
  final double latitude;
  final double longitude;
  final String address;

  const LocationPinpointResult({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class LocationPinpointSheet extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final String? initialAddress;

  const LocationPinpointSheet({
    super.key,
    this.initialLat,
    this.initialLng,
    this.initialAddress,
  });

  static Future<LocationPinpointResult?> show(
    BuildContext context, {
    double? initialLat,
    double? initialLng,
    String? initialAddress,
  }) {
    return showModalBottomSheet<LocationPinpointResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationPinpointSheet(
        initialLat: initialLat,
        initialLng: initialLng,
        initialAddress: initialAddress,
      ),
    );
  }

  @override
  State<LocationPinpointSheet> createState() => _LocationPinpointSheetState();
}

class _LocationPinpointSheetState extends State<LocationPinpointSheet> {
  late TextEditingController _searchController;
  late double _currentLat;
  late double _currentLng;
  late String _currentAddress;
  bool _isLocating = false;

  // Pre-populated quick locations for rapid user selection
  final List<Map<String, dynamic>> _quickLocations = [
    {
      'name': 'Mikocheni B, Dar es Salaam',
      'lat': -6.7645,
      'lng': 39.2452,
    },
    {
      'name': 'Masaki Peninsula, Dar es Salaam',
      'lat': -6.7460,
      'lng': 39.2798,
    },
    {
      'name': 'Posta / CBD, Dar es Salaam',
      'lat': -6.8160,
      'lng': 39.2890,
    },
    {
      'name': 'Mlimani City, Ubungo, Dar es Salaam',
      'lat': -6.7725,
      'lng': 39.2215,
    },
    {
      'name': 'Kijitonyama, Dar es Salaam',
      'lat': -6.7780,
      'lng': 39.2410,
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentLat = widget.initialLat ?? -6.7924;
    _currentLng = widget.initialLng ?? 39.2083;
    _currentAddress = widget.initialAddress ?? 'Mikocheni, Dar es Salaam';
    _searchController = TextEditingController(text: _currentAddress);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchDeviceGPS() async {
    setState(() => _isLocating = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _applyCoordinates(-6.7924, 39.2083, 'Dar es Salaam, Tanzania (GPS Default)');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _applyCoordinates(-6.7924, 39.2083, 'Mikocheni, Dar es Salaam');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _applyCoordinates(-6.7924, 39.2083, 'Mikocheni, Dar es Salaam');
        return;
      }

      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 5),
      );

      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      _applyCoordinates(
        position.latitude,
        position.longitude,
        'Current Device GPS Location',
      );
    } catch (_) {
      _applyCoordinates(-6.7924, 39.2083, 'Mikocheni, Dar es Salaam (GPS Fallback)');
    } finally {
      if (mounted) {
        setState(() => _isLocating = false);
      }
    }
  }

  void _applyCoordinates(double lat, double lng, String address) {
    if (!mounted) return;
    setState(() {
      _currentLat = lat;
      _currentLng = lng;
      _currentAddress = address;
      _searchController.text = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;
    final effectivePrimary = isDark ? AppColors.darkModePrimaryColor : AppColors.primaryColor;

    return Material(
      color: isDark ? const Color(0xFF1E232A) : Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.88,
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Handle
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.pinpointStayAddressTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 0.6,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
            ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Search Address Field
                CustomTextField(
                  label: l10n.searchAddressPlaceholder,
                  hintText: 'e.g. Mikocheni, Masaki, Posta...',
                  controller: _searchController,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                        )
                      : null,
                  onChanged: (val) {
                    setState(() {
                      _currentAddress = val;
                    });
                  },
                ),
                const SizedBox(height: 14),

                // Button: Use Current GPS
                OutlinedButton.icon(
                  onPressed: _isLocating ? null : _fetchDeviceGPS,
                  icon: _isLocating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.my_location_rounded, color: effectivePrimary, size: 18),
                  label: Text(
                    _isLocating ? l10n.detectingGps : l10n.useCurrentLocation,
                    style: TextStyle(
                      color: effectivePrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: effectivePrimary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 18),

                // Pinpoint Map Card Preview
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [const Color(0xFF13171D), const Color(0xFF263238)]
                          : [const Color(0xFFE0F2F1), const Color(0xFFB2DFDB)],
                    ),
                    border: Border.all(
                      color: effectivePrimary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Grid lines graphic background
                      Opacity(
                        opacity: 0.15,
                        child: CustomPaint(
                          size: const Size(double.infinity, 180),
                          painter: _GridPainter(),
                        ),
                      ),
                      // Pin Marker
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 44,
                            color: effectivePrimary,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.black87 : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Text(
                              _searchController.text.trim().isNotEmpty
                                  ? _searchController.text.trim()
                                  : l10n.selectedLocation,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      // Lat/Lng Pill
                      Positioned(
                        bottom: 10,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_currentLat.toStringAsFixed(4)}, ${_currentLng.toStringAsFixed(4)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Quick area suggestions
                Text(
                  l10n.popularAreasInDar,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white70 : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),

                ...List.generate(_quickLocations.length, (index) {
                  final loc = _quickLocations[index];
                  final isSelected = _currentAddress == loc['name'];

                  return Material(
                    color: Colors.transparent,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: Icon(
                        Icons.place_outlined,
                        size: 20,
                        color: isSelected ? effectivePrimary : Colors.grey,
                      ),
                      title: Text(
                        loc['name'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? effectivePrimary
                              : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle_rounded, color: effectivePrimary, size: 18)
                          : null,
                      onTap: () {
                        _applyCoordinates(
                          loc['lat'] as double,
                          loc['lng'] as double,
                          loc['name'] as String,
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          // Bottom Confirmation Bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E232A) : Colors.white,
            ),
            child: CustomButton(
              text: l10n.confirmLocation,
              onPressed: () {
                Navigator.of(context).pop(
                  LocationPinpointResult(
                    latitude: _currentLat,
                    longitude: _currentLng,
                    address: _searchController.text.trim().isNotEmpty
                        ? _searchController.text.trim()
                        : _currentAddress,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
