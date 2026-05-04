import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service that determines optimal streaming quality based on
/// network conditions and device capabilities.
class StreamingService {
  // ── Singleton ──────────────────────────────────────────────────────────────
  static final StreamingService _instance = StreamingService._internal();
  factory StreamingService() => _instance;
  StreamingService._internal();

  // ── Quality Levels ─────────────────────────────────────────────────────────
  static const Map<String, int> qualityBitrates = {
    '240p': 400,
    '360p': 800,
    '480p': 1500,
    '720p': 3000,
    '1080p': 5000,
  };

  // ── Network-Based Quality Selection ────────────────────────────────────────

  /// Detect current network type and return the recommended max quality.
  Future<String> getNetworkBasedQuality() async {
    try {
      final result = await Connectivity().checkConnectivity();

      if (result.contains(ConnectivityResult.wifi)) {
        return '1080p'; // WiFi → allow full HD
      } else if (result.contains(ConnectivityResult.mobile)) {
        return '480p'; // Mobile data → limit to 480p
      } else if (result.contains(ConnectivityResult.ethernet)) {
        return '1080p'; // Ethernet → allow full HD
      } else {
        return '360p'; // Unknown/slow → low quality
      }
    } catch (_) {
      return '480p'; // Fallback
    }
  }

  // ── Device-Based Quality Selection ─────────────────────────────────────────

  /// Determine maximum quality based on screen size.
  /// Small screens don't benefit from 1080p, so we cap it.
  String getDeviceMaxQuality(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final physicalWidth = screenWidth * pixelRatio;

    if (physicalWidth >= 1920) {
      return '1080p';
    } else if (physicalWidth >= 1280) {
      return '720p';
    } else if (physicalWidth >= 854) {
      return '480p';
    } else {
      return '360p';
    }
  }

  /// Get the optimal quality considering both network and device constraints.
  Future<String> getOptimalQuality(BuildContext context) async {
    final networkQuality = await getNetworkBasedQuality();
    final deviceQuality = getDeviceMaxQuality(context);

    final networkBitrate = qualityBitrates[networkQuality] ?? 1500;
    final deviceBitrate = qualityBitrates[deviceQuality] ?? 3000;

    // Use the lower of the two constraints
    final optimalBitrate =
        networkBitrate < deviceBitrate ? networkBitrate : deviceBitrate;

    // Find the quality label for this bitrate
    return qualityBitrates.entries
        .firstWhere((e) => e.value == optimalBitrate,
            orElse: () => const MapEntry('480p', 1500))
        .key;
  }

  /// Get a human-readable label for the current network type.
  Future<String> getNetworkTypeLabel() async {
    try {
      final result = await Connectivity().checkConnectivity();
      if (result.contains(ConnectivityResult.wifi)) return 'Wi-Fi';
      if (result.contains(ConnectivityResult.mobile)) return 'Mobile Data';
      if (result.contains(ConnectivityResult.ethernet)) return 'Ethernet';
      return 'Unknown';
    } catch (_) {
      return 'Unknown';
    }
  }
}
