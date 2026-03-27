import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../models/run_data.dart';
import '../../services/location_service.dart';
import '../../services/run_storage_service.dart';
import '../../services/points_manager.dart';
import '../../utils/gamification_overlay.dart';

enum RunState { idle, countdown, running, paused, finished }

class ActiveRunScreen extends StatefulWidget {
  final RunType runType;
  final double targetDistanceKm;
  final int targetDurationMin;
  final double? targetCalories;
  final int? targetSteps;

  const ActiveRunScreen({
    super.key,
    required this.runType,
    required this.targetDistanceKm,
    required this.targetDurationMin,
    this.targetCalories,
    this.targetSteps,
  });

  @override
  State<ActiveRunScreen> createState() => _ActiveRunScreenState();
}

class _ActiveRunScreenState extends State<ActiveRunScreen>
    with TickerProviderStateMixin {
  // ── Map ──
  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  final List<LatLng> _routePoints = [];

  // ── GPS ──
  final LocationService _locationService = LocationService();
  Position? _lastPosition;

  // ── Run State ──
  RunState _runState = RunState.idle;
  int _elapsedSeconds = 0;
  double _totalDistanceMeters = 0;
  int _steps = 0;
  double _currentSpeed = 0; // km/h
  Timer? _timer;
  DateTime? _startTime;

  // ── Countdown ──
  int _countdownValue = 3;
  Timer? _countdownTimer;

  // ── Animations ──
  late AnimationController _panelAnimCtrl;
  late Animation<Offset> _panelSlide;
  late AnimationController _pulseAnimCtrl;

  // ── Bottom sheet ──
  bool _isStatsExpanded = false;

  @override
  void initState() {
    super.initState();
    _panelAnimCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _panelSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _panelAnimCtrl, curve: Curves.easeOut));

    _pulseAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _initLocation();
  }

  Future<void> _initLocation() async {
    final pos = await LocationService.getCurrentPosition();
    if (pos != null && mounted) {
      setState(() {
        _currentLatLng = LatLng(pos.latitude, pos.longitude);
        _lastPosition = pos;
        _updateMarkers();
      });
      _panelAnimCtrl.forward();
    }
  }

  void _updateMarkers() {
    if (_currentLatLng == null) return;
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('current'),
        position: _currentLatLng!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'You are here'),
      ),
    );
    if (_routePoints.isNotEmpty) {
      _markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: _routePoints.first,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Start'),
        ),
      );
    }
  }

  void _updatePolyline() {
    _polylines.clear();
    if (_routePoints.length >= 2) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('run_route'),
          points: _routePoints,
          color: AppColors.sageGreen,
          width: 5,
          patterns: const [],
        ),
      );
    }
  }

  // ── COUNTDOWN + START ──
  void _startCountdown() {
    setState(() {
      _runState = RunState.countdown;
      _countdownValue = 3;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _countdownValue--;
        if (_countdownValue <= 0) {
          t.cancel();
          _startRun();
        }
      });
    });
  }

  void _startRun() {
    setState(() {
      _runState = RunState.running;
      _startTime ??= DateTime.now();
    });

    // Start GPS tracking
    _locationService.startTracking(
      onPosition: (pos) {
        if (!mounted || _runState != RunState.running) return;
        final newLatLng = LatLng(pos.latitude, pos.longitude);

        double addedDist = 0;
        if (_lastPosition != null) {
          addedDist = LocationService.distanceBetween(_lastPosition!, pos);
        }

        setState(() {
          _currentLatLng = newLatLng;
          _routePoints.add(newLatLng);
          _totalDistanceMeters += addedDist;
          _currentSpeed = (pos.speed * 3.6).clamp(0, 60); // m/s → km/h
          // Estimate steps (avg stride ~0.75m)
          _steps = (_totalDistanceMeters / 0.75).round();
          _lastPosition = pos;
          _updateMarkers();
          _updatePolyline();
        });

        // Animate camera to follow
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(newLatLng),
        );
      },
    );

    // Start timer
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _elapsedSeconds++);
    });
  }

  void _pauseRun() {
    setState(() => _runState = RunState.paused);
    _timer?.cancel();
    _locationService.stopTracking();
  }

  void _resumeRun() {
    setState(() => _runState = RunState.running);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _elapsedSeconds++);
    });
    _locationService.startTracking(
      onPosition: (pos) {
        if (!mounted || _runState != RunState.running) return;
        final newLatLng = LatLng(pos.latitude, pos.longitude);
        double addedDist = 0;
        if (_lastPosition != null) {
          addedDist = LocationService.distanceBetween(_lastPosition!, pos);
        }
        setState(() {
          _currentLatLng = newLatLng;
          _routePoints.add(newLatLng);
          _totalDistanceMeters += addedDist;
          _currentSpeed = (pos.speed * 3.6).clamp(0, 60);
          _steps = (_totalDistanceMeters / 0.75).round();
          _lastPosition = pos;
          _updateMarkers();
          _updatePolyline();
        });
        _mapController?.animateCamera(CameraUpdate.newLatLng(newLatLng));
      },
    );
  }

  void _stopRun() async {
    _timer?.cancel();
    _locationService.stopTracking();
    setState(() => _runState = RunState.finished);

    final endTime = DateTime.now();
    final caloriesBurned = _totalDistanceMeters / 1000.0 * 60; // rough approx

    // Save the run
    final record = RunRecord(
      id: endTime.millisecondsSinceEpoch.toString(),
      type: widget.runType,
      distanceMeters: _totalDistanceMeters,
      durationSeconds: _elapsedSeconds,
      steps: _steps,
      calories: caloriesBurned,
      startTime: _startTime ?? endTime,
      endTime: endTime,
      route: _routePoints
          .map((p) => LatLngPoint(p.latitude, p.longitude))
          .toList(),
      targetDistanceMeters: widget.targetDistanceKm * 1000,
      targetDurationSeconds: widget.targetDurationMin * 60,
      targetCalories: widget.targetCalories,
      targetSteps: widget.targetSteps,
    );
    await RunStorageService.saveRun(record);

    // Award points
    int earnedPoints = (record.distanceKm * 100).toInt();
    if (earnedPoints > 0) {
      final success = await PointsManager().addWorkoutPoints(
        earnedPoints,
        minutes: _elapsedSeconds ~/ 60,
        calories: caloriesBurned.toInt(),
      );
      if (success && mounted) {
        GamificationOverlay.showPointsEarned(context, earnedPoints);
      }
    }
  }

  void _resetRun() {
    _timer?.cancel();
    _locationService.stopTracking();
    setState(() {
      _runState = RunState.idle;
      _elapsedSeconds = 0;
      _totalDistanceMeters = 0;
      _steps = 0;
      _currentSpeed = 0;
      _routePoints.clear();
      _polylines.clear();
      _startTime = null;
      _updateMarkers();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _countdownTimer?.cancel();
    _locationService.dispose();
    _mapController?.dispose();
    _panelAnimCtrl.dispose();
    _pulseAnimCtrl.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final h = _elapsedSeconds ~/ 3600;
    final m = (_elapsedSeconds % 3600) ~/ 60;
    final s = _elapsedSeconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  double get _distanceKm => _totalDistanceMeters / 1000.0;

  String get _avgPace {
    if (_distanceKm == 0) return '--:--';
    final paceSeconds = (_elapsedSeconds / _distanceKm).floor();
    final pm = paceSeconds ~/ 60;
    final ps = paceSeconds % 60;
    return '$pm:${ps.toString().padLeft(2, '0')}';
  }

  double get _progress =>
      (_distanceKm / widget.targetDistanceKm).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── GOOGLE MAP ──
          _currentLatLng == null
              ? Container(
                  color: AppColors.sageMapBg,
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: AppColors.sageGreen),
                        SizedBox(height: 16),
                        Text('Getting your location…',
                            style: TextStyle(color: AppColors.sageTextMuted)),
                      ],
                    ),
                  ),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentLatLng!,
                    zoom: 16.5,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  markers: _markers,
                  polylines: _polylines,
                  mapType: MapType.normal,
                ),

          // ── COUNTDOWN OVERLAY ──
          if (_runState == RunState.countdown)
            Container(
              color: Colors.black.withValues(alpha: 0.7),
              child: Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.5, end: 1.0),
                  duration: const Duration(milliseconds: 300),
                  key: ValueKey(_countdownValue),
                  builder: (ctx, value, child) => Transform.scale(
                    scale: value,
                    child: Text(
                      '$_countdownValue',
                      style: AppTextStyles.sageStatBig.copyWith(
                        fontSize: 120,
                        color: AppColors.sageGreen,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // ── TOP BACK BUTTON + RUN TYPE ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Back button
                GestureDetector(
                  onTap: () {
                    if (_runState == RunState.running ||
                        _runState == RunState.paused) {
                      _showExitDialog();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back_ios_new,
                        size: 18, color: AppColors.sageTextDark),
                  ),
                ),
                const Spacer(),
                // Run type badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(widget.runType.emoji, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(widget.runType.label,
                          style: AppTextStyles.sageSubtitle.copyWith(
                              color: AppColors.sageTextDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                    ],
                  ),
                ),
                const Spacer(),
                // My Location button
                GestureDetector(
                  onTap: () {
                    if (_currentLatLng != null) {
                      _mapController?.animateCamera(
                          CameraUpdate.newLatLngZoom(_currentLatLng!, 16.5));
                    }
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10),
                      ],
                    ),
                    child: const Icon(Icons.my_location,
                        size: 20, color: AppColors.sageGreen),
                  ),
                ),
              ],
            ),
          ),

          // ── BOTTOM STATS PANEL ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _panelSlide,
              child: _buildBottomPanel(),
            ),
          ),
        ],
      ),
    );
  }

  // ── BOTTOM PANEL ──
  Widget _buildBottomPanel() {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < 0) {
            setState(() => _isStatsExpanded = true);
          } else {
            setState(() => _isStatsExpanded = false);
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        padding: EdgeInsets.fromLTRB(
            24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // ── MAIN DISTANCE + PROGRESS ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(_distanceKm.toStringAsFixed(2),
                    style: AppTextStyles.sageTitle.copyWith(fontSize: 44)),
                const SizedBox(width: 6),
                Text('/ ${widget.targetDistanceKm.toStringAsFixed(1)} km',
                    style: AppTextStyles.sageSubtitle.copyWith(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: AppColors.sageBg,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.sageGreen),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 16),

            // ── STATS ROW ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(Icons.timer_outlined, _formattedTime, 'Time'),
                _buildStatDivider(),
                _buildStatItem(Icons.speed, '${_currentSpeed.toStringAsFixed(1)} km/h', 'Speed'),
                _buildStatDivider(),
                _buildStatItem(Icons.directions_walk, '$_steps', 'Steps'),
              ],
            ),

            // ── EXPANDED DETAIL ──
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(Icons.speed_outlined, '$_avgPace /km', 'Pace'),
                    _buildStatDivider(),
                    _buildStatItem(Icons.local_fire_department,
                        (_totalDistanceMeters / 1000.0 * 60).toStringAsFixed(0), 'Cal'),
                    _buildStatDivider(),
                    _buildStatItem(Icons.flag,
                        '${(_progress * 100).toStringAsFixed(0)}%', 'Goal'),
                  ],
                ),
              ),
              crossFadeState: _isStatsExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),

            const SizedBox(height: 20),

            // ── CONTROL BUTTONS ──
            _buildControlButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.sageGreen, size: 18),
        const SizedBox(height: 4),
        Text(value,
            style: AppTextStyles.sageTitle
                .copyWith(fontSize: 18, letterSpacing: -0.5)),
        Text(label, style: AppTextStyles.sageSubtitle.copyWith(fontSize: 11)),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 40, color: AppColors.sageBg);
  }

  // ── CONTROL BUTTONS ──
  Widget _buildControlButtons() {
    switch (_runState) {
      case RunState.idle:
        return _buildPrimaryButton('Start Run', Icons.play_arrow_rounded, _startCountdown);

      case RunState.countdown:
        return _buildPrimaryButton('Get Ready…', Icons.hourglass_top, null,
            color: Colors.orange.shade600);

      case RunState.running:
        return Row(
          children: [
            Expanded(
              child: _buildActionButton('Pause', Icons.pause, _pauseRun,
                  color: Colors.white,
                  textColor: AppColors.sageTextDark,
                  borderColor: AppColors.sageBg),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildActionButton('Stop', Icons.stop_rounded, _stopRun,
                  color: AppColors.sageDark, textColor: Colors.white),
            ),
          ],
        );

      case RunState.paused:
        return Row(
          children: [
            Expanded(
              child: _buildActionButton(
                  'Resume', Icons.play_arrow_rounded, _resumeRun,
                  color: AppColors.sageGreen, textColor: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildActionButton('Stop', Icons.stop_rounded, _stopRun,
                  color: AppColors.sageDark, textColor: Colors.white),
            ),
          ],
        );

      case RunState.finished:
        return Row(
          children: [
            Expanded(
              child: _buildActionButton(
                  'New Run', Icons.refresh_rounded, _resetRun,
                  color: AppColors.sageGreen, textColor: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildActionButton(
                  'Done', Icons.check_rounded, () => Navigator.pop(context),
                  color: AppColors.sageDark, textColor: Colors.white),
            ),
          ],
        );
    }
  }

  Widget _buildPrimaryButton(String label, IconData icon, VoidCallback? onTap,
      {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: color != null
              ? null
              : const LinearGradient(
                  colors: [Color(0xFF2D6A4F), Color(0xFF52B788)]),
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: (color ?? AppColors.sageGreen).withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(label,
                style: AppTextStyles.sageCardTitle
                    .copyWith(fontSize: 18, letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onTap, {
    required Color color,
    required Color textColor,
    Color? borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28),
          border: borderColor != null
              ? Border.all(color: borderColor, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 22),
            const SizedBox(width: 8),
            Text(label,
                style: AppTextStyles.sageCardTitle
                    .copyWith(color: textColor, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  // ── EXIT DIALOG ──
  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('End Run?'),
        content: const Text(
            'Your run is still active. Do you want to stop and save, or discard it?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _resetRun();
              Navigator.pop(context);
            },
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sageGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _stopRun();
            },
            child: const Text('Save & Stop',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
