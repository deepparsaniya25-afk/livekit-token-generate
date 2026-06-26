import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

class VideoTile extends StatelessWidget {
  const VideoTile({
    super.key,
    required this.label,
    this.track,
    this.isMirrored = false,
  });

  final String label;
  final VideoTrack? track;
  final bool isMirrored;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (track != null)
              VideoTrackRenderer(
                track!,
                fit: VideoViewFit.cover,
                mirrorMode: isMirrored
                    ? VideoViewMirrorMode.mirror
                    : VideoViewMirrorMode.off,
              )
            else
              const Center(
                child: Icon(
                  Icons.videocam_off_outlined,
                  color: Colors.white38,
                  size: 48,
                ),
              ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
