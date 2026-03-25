import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/services/run_location_service.dart';
import '../../domain/run_stats_engine.dart';

class ActiveRunMapScreen extends StatefulWidget {
  const ActiveRunMapScreen({Key? key}) : super(key: key);

  @override
  State<ActiveRunMapScreen> createState() => _ActiveRunMapScreenState();
}

class _ActiveRunMapScreenState extends State<ActiveRunMapScreen> {
  // Map and Location State
  final Completer<GoogleMapController> _controller = Completer();
  final RunLocationService _locationService = RunLocationService();
  
  MapType _currentMapType = MapType.normal;
  List<LatLng> _routePoints = [];
  Set<Polyline> _polylines = {};
  
  // Running Stats State
  bool _isRunning = false;
  bool _isPaused = false;
  
  int _secondsElapsed = 0;
  double _distanceKm = 0.0;
  double _currentPace = 0.0;
  int _caloriesBurned = 0;
  
  Timer? _timer;
  
  // User Weight config (ideally loaded from settings)
  final double _userWeightKg = 70.0;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _locationService.stopTracking();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    bool hasPermission = await _locationService.requestPermissions();
    if (hasPermission) {
      Position pos = await Geolocator.getCurrentPosition();
      _moveToLocation(pos);
    }
  }

  Future<void> _moveToLocation(Position position) async {
    final GoogleMapController mapController = await _controller.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 17.0,
      ),
    ));
  }

  void _startRun() async {
    bool hasPermission = await _locationService.requestPermissions();
    if (!hasPermission) return;

    setState(() {
      _isRunning = true;
      _isPaused = false;
      _routePoints.clear();
      _polylines.clear();
      _secondsElapsed = 0;
      _distanceKm = 0.0;
      _caloriesBurned = 0;
    });

    _startTimer();

    _locationService.startTracking((Position position) {
      if (!_isRunning || _isPaused) return;

      LatLng newPoint = LatLng(position.latitude, position.longitude);
      
      // Calculate distance if we have previous points
      if (_routePoints.isNotEmpty) {
        LatLng lastPoint = _routePoints.last;
        double addedDistance = RunStatsEngine.calculateDistanceKM(
          lastPoint.latitude, lastPoint.longitude, 
          newPoint.latitude, newPoint.longitude
        );
        _distanceKm += addedDistance;
        
        // Recalculate stats dynamically
        _currentPace = RunStatsEngine.calculatePace(_distanceKm, _secondsElapsed);
        double speed = RunStatsEngine.calculateSpeedKph(_distanceKm, _secondsElapsed);
        _caloriesBurned = RunStatsEngine.calculateCalories(speed, _userWeightKg, _secondsElapsed);
      }

      setState(() {
        _routePoints.add(newPoint);
        _updatePolyline();
      });

      _moveToLocation(position);
    });
  }

  void _pauseRun() {
    setState(() {
      _isPaused = true;
    });
    _timer?.cancel();
    _locationService.pauseTracking();
  }

  void _resumeRun() {
    setState(() {
      _isPaused = false;
    });
    _startTimer();
    _locationService.resumeTracking();
  }

  void _finishRun() {
    _pauseRun();
    setState(() {
      _isRunning = false;
    });
    // In actual app, navigate to RunSummaryScreen with all stats and points
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Run completed & saved successfully!")),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _updatePolyline() {
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('run_route'),
        points: _routePoints,
        color: const Color(0xFF7C4DFF),
        width: 6,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    );
  }

  String _formatTime(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    if (h > 0) return "$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // ── Map Layer ──
          GoogleMap(
            mapType: _currentMapType,
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.7749, -122.4194), // Default fallback SF
              zoom: 14.4746,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),

          // ── Mode Switcher (Top) ──
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: _buildModeSwitcher(),
          ),

          // ── Stats Bottom Sheet ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildStatsPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSwitcher() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ModePill(
              title: "Road",
              icon: Icons.add_road,
              isSelected: _currentMapType == MapType.normal,
              onTap: () => setState(() => _currentMapType = MapType.normal),
            ),
            _ModePill(
              title: "Mountain",
              icon: Icons.terrain,
              isSelected: _currentMapType == MapType.terrain,
              onTap: () => setState(() => _currentMapType = MapType.terrain),
            ),
            _ModePill(
              title: "Track",
              icon: Icons.satellite_alt,
              isSelected: _currentMapType == MapType.satellite,
              onTap: () => setState(() => _currentMapType = MapType.satellite),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Stats Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(label: "Time", value: _formatTime(_secondsElapsed)),
              _StatItem(label: "Distance", value: "${_distanceKm.toStringAsFixed(2)} km"),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(label: "Pace", value: "${RunStatsEngine.formatPace(_currentPace)} /km"),
              _StatItem(label: "Calories", value: "$_caloriesBurned kcal"),
            ],
          ),
          const SizedBox(height: 32),
          
          // Controls
          if (!_isRunning)
            _buildPrimaryButton("Start Run", const Color(0xFF7C4DFF), _startRun)
          else if (_isPaused)
            Row(
              children: [
                Expanded(child: _buildPrimaryButton("Finish", Colors.redAccent, _finishRun)),
                const SizedBox(width: 16),
                Expanded(child: _buildPrimaryButton("Resume", const Color(0xFF7C4DFF), _resumeRun)),
              ],
            )
          else
            _buildPrimaryButton("Pause", Colors.orangeAccent, _pauseRun),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }
}

class _ModePill extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModePill({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7C4DFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.black54),
            const SizedBox(width: 6),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
