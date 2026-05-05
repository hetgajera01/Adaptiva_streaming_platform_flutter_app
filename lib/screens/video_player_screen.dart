import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:mad_project/models/video.dart';
import 'package:mad_project/services/database_service.dart';
import 'package:mad_project/services/streaming_service.dart';
import 'package:mad_project/config/theme.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Video video;
  final String userId;

  const VideoPlayerScreen({
    super.key,
    required this.video,
    required this.userId,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  BetterPlayerController? _betterPlayerController;
  final DatabaseService _databaseService = DatabaseService();
  final StreamingService _streamingService = StreamingService();
  bool _isLoading = true;
  String? _errorMessage;
  String _currentQuality = 'Auto';
  String _networkType = '';
  String _detectedDuration = '';

  @override
  void initState() {
    super.initState();
    _addToWatchHistory();
    // Defer player initialization until the widget is built (need context)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePlayer();
    });
  }

  Future<void> _initializePlayer() async {
    try {
      // Get optimal quality based on network + device
      final optimalQuality = await _streamingService.getOptimalQuality(context);
      final networkLabel = await _streamingService.getNetworkTypeLabel();

      // Fix S3 URLs: replace '+' with '%20' for proper space encoding
      final playbackUrl = widget.video.playbackUrl.replaceAll('+', '%20');

      // Determine video format
      final videoFormat = widget.video.isHls
          ? BetterPlayerVideoFormat.hls
          : BetterPlayerVideoFormat.other;

      // Create data source
      final dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        playbackUrl,
        videoFormat: videoFormat,
        bufferingConfiguration: const BetterPlayerBufferingConfiguration(
          minBufferMs: 2000,
          maxBufferMs: 10000,
          bufferForPlaybackMs: 1000,
          bufferForPlaybackAfterRebufferMs: 2000,
        ),
      );

      // Create controller with configuration
      final controller = BetterPlayerController(
        BetterPlayerConfiguration(
          autoPlay: true,
          looping: false,
          allowedScreenSleep: false,
          fullScreenByDefault: false,
          fit: BoxFit.contain,
          autoDetectFullscreenDeviceOrientation: true,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableOverflowMenu: true,
            enableQualities: widget.video.isHls,
            enableSubtitles: false,
            overflowMenuIconsColor: Colors.white,
            controlBarColor: Colors.black54,
            progressBarPlayedColor: AppTheme.accentColor,
            progressBarHandleColor: AppTheme.accentColor,
            progressBarBufferedColor: Colors.white30,
            progressBarBackgroundColor: Colors.white12,
            loadingColor: AppTheme.accentColor,
            iconsColor: Colors.white,
          ),
          errorBuilder: (context, errorMessage) {
            return _buildInlineError(errorMessage ?? 'Unknown error');
          },
        ),
        betterPlayerDataSource: dataSource,
      );

      // Listen for events to track watch progress and detect duration
      controller.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
          _onProgressUpdate(controller);
        }
        // Detect duration when video is initialized
        if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
          _onVideoInitialized(controller);
        }
      });

      if (mounted) {
        setState(() {
          _betterPlayerController = controller;
          _currentQuality = optimalQuality;
          _networkType = networkLabel;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _onVideoInitialized(BetterPlayerController controller) {
    final duration = controller.videoPlayerController?.value.duration;
    if (duration != null && duration.inSeconds > 0) {
      final formatted = _formatDuration(duration);
      if (mounted) {
        setState(() => _detectedDuration = formatted);
      }

      // Save to Firestore if stored duration is 0
      if (widget.video.duration == 0) {
        _databaseService.updateVideo(
          widget.video.id,
          {'duration': duration.inSeconds},
        );
        debugPrint('Auto-saved video duration: ${duration.inSeconds}s');
      }
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  void _onProgressUpdate(BetterPlayerController controller) {
    final position = controller.videoPlayerController?.value.position;
    final duration = controller.videoPlayerController?.value.duration;

    if (position != null && duration != null && duration.inSeconds > 0) {
      final progress = (position.inSeconds / duration.inSeconds) * 100;

      // Update progress every 10 seconds
      if (position.inSeconds % 10 == 0 && position.inSeconds > 0) {
        _updateWatchProgress(progress);
      }
    }
  }

  Future<void> _addToWatchHistory() async {
    try {
      await _databaseService.addToWatchHistory(
        widget.userId,
        widget.video.id,
      );
    } catch (e) {
      debugPrint('Error adding to watch history: $e');
    }
  }

  Future<void> _updateWatchProgress(double progress) async {
    try {
      await _databaseService.updateWatchProgress(
        widget.userId,
        widget.video.id,
        progress,
      );
    } catch (e) {
      debugPrint('Error updating watch progress: $e');
    }
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    // Reset orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.video.title,
          style: AppTheme.titleMedium.copyWith(
            color: AppTheme.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppTheme.accentColor),
                  const SizedBox(height: 16),
                  Text(
                    'Preparing stream...',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : _errorMessage != null
              ? _buildErrorWidget()
              : Column(
                  children: [
                    // ── Video Player ─────────────────────────────────────
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: _betterPlayerController != null
                          ? BetterPlayer(
                              controller: _betterPlayerController!,
                            )
                          : Container(color: AppTheme.primaryDark),
                    ),

                    // ── Video Info Section ───────────────────────────────
                    Expanded(
                      child: Container(
                        color: AppTheme.backgroundColor,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                widget.video.title,
                                style: AppTheme.headlineMedium.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Duration + Stream info
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 16,
                                      color: AppTheme.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    _detectedDuration.isNotEmpty
                                        ? _detectedDuration
                                        : widget.video.getFormattedDuration(),
                                    style: TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Stream type badge
                                  _buildBadge(
                                    widget.video.isHls ? 'HLS' : 'MP4',
                                    widget.video.isHls
                                        ? AppTheme.successColor
                                        : AppTheme.infoColor,
                                  ),
                                  const SizedBox(width: 8),
                                  // Network type badge
                                  if (_networkType.isNotEmpty)
                                    _buildBadge(_networkType, AppTheme.accentColor),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Quality selector
                              _buildQualitySelector(),
                              const SizedBox(height: 16),

                              // Description
                              Text(
                                'Description',
                                style: AppTheme.titleMedium.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.video.description,
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14,
                                  height: 1.5,
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

  // ── Helper Widgets ────────────────────────────────────────────────────────

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildQualitySelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with change button
          Row(
            children: [
              Icon(Icons.tune, color: AppTheme.accentColor, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Video Quality',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Current: $_currentQuality  •  $_networkType',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showQualityPicker,
                icon: const Icon(Icons.high_quality, size: 18),
                label: const Text('Change'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: AppTheme.primaryDark,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Quality chips row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _getQualityOptions().map((q) {
                final isSelected = q == _currentQuality;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(q),
                    selected: isSelected,
                    onSelected: (_) => _setQuality(q),
                    selectedColor: AppTheme.accentColor,
                    backgroundColor: AppTheme.primaryVariant,
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.primaryDark : AppTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.accentColor
                          : AppTheme.textTertiary.withValues(alpha: 0.3),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getQualityOptions() {
    final options = ['Auto'];
    if (widget.video.qualities.isNotEmpty) {
      options.addAll(widget.video.qualities);
    } else {
      // Default quality options
      options.addAll(['240p', '360p', '480p', '720p', '1080p']);
    }
    return options;
  }

  void _setQuality(String quality) {
    setState(() => _currentQuality = quality);

    if (_betterPlayerController == null) return;

    if (quality == 'Auto') {
      // Reset to automatic quality selection by selecting default track
      final tracks = _betterPlayerController!.betterPlayerAsmsTracks;
      if (tracks.isNotEmpty) {
        _betterPlayerController!.setTrack(tracks.first);
      }
      debugPrint('Quality set to Auto (ABR)');
    } else {
      // Try to find and set the matching track
      final tracks = _betterPlayerController!.betterPlayerAsmsTracks;
      if (tracks.isNotEmpty) {
        final qualityHeight = _qualityToHeight(quality);
        BetterPlayerAsmsTrack? matchingTrack;

        for (final track in tracks) {
          if (track.height == qualityHeight) {
            matchingTrack = track;
            break;
          }
        }

        if (matchingTrack != null) {
          _betterPlayerController!.setTrack(matchingTrack);
          debugPrint('Quality set to $quality (${matchingTrack.height}p)');
        } else {
          debugPrint('Track not found for $quality, available: ${tracks.map((t) => t.height).toList()}');
        }
      }
    }
  }

  int _qualityToHeight(String quality) {
    switch (quality) {
      case '240p': return 240;
      case '360p': return 360;
      case '480p': return 480;
      case '720p': return 720;
      case '1080p': return 1080;
      default: return 480;
    }
  }

  void _showQualityPicker() {
    final options = _getQualityOptions();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Select Video Quality',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose a quality or let the player adapt automatically',
                style: AppTheme.bodySmall.copyWith(color: AppTheme.textTertiary),
              ),
              const SizedBox(height: 12),
              ...options.map((q) {
                final isSelected = q == _currentQuality;
                return ListTile(
                  leading: Icon(
                    q == 'Auto' ? Icons.auto_awesome : Icons.hd,
                    color: isSelected ? AppTheme.accentColor : AppTheme.textSecondary,
                  ),
                  title: Text(
                    q,
                    style: TextStyle(
                      color: isSelected ? AppTheme.accentColor : AppTheme.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: q == 'Auto'
                      ? Text(
                          'Adjusts based on network speed',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textTertiary,
                          ),
                        )
                      : null,
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: AppTheme.accentColor)
                      : null,
                  onTap: () {
                    _setQuality(q);
                    Navigator.pop(ctx);
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInlineError(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: AppTheme.textPrimary, size: 60),
          const SizedBox(height: 16),
          Text(
            'Error playing video',
            style: AppTheme.headlineSmall.copyWith(color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppTheme.textPrimary, size: 80),
            const SizedBox(height: 16),
            Text(
              'Failed to load video',
              style: AppTheme.headlineMedium.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _initializePlayer();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: AppTheme.textPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
