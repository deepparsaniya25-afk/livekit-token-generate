import 'package:flutter/material.dart';

class CallControls extends StatelessWidget {
  const CallControls({
    super.key,
    required this.isMicEnabled,
    required this.isCameraEnabled,
    required this.onToggleMic,
    required this.onToggleCamera,
    required this.onLeave,
  });

  final bool isMicEnabled;
  final bool isCameraEnabled;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleCamera;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ControlButton(
            icon: isMicEnabled ? Icons.mic : Icons.mic_off,
            label: isMicEnabled ? 'Mute' : 'Unmute',
            backgroundColor: isMicEnabled ? Colors.white24 : Colors.orange,
            onPressed: onToggleMic,
          ),
          _ControlButton(
            icon: isCameraEnabled ? Icons.videocam : Icons.videocam_off,
            label: isCameraEnabled ? 'Camera Off' : 'Camera On',
            backgroundColor: isCameraEnabled ? Colors.white24 : Colors.orange,
            onPressed: onToggleCamera,
          ),
          _ControlButton(
            icon: Icons.call_end,
            label: 'Leave',
            backgroundColor: Colors.red,
            onPressed: onLeave,
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: backgroundColor,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox(
              width: 56,
              height: 56,
              child: Icon(icon, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
