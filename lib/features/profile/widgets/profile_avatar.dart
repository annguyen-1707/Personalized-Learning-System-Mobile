import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.fullName,
    required this.size,
    this.avatarUrl,
    super.key,
  });

  final String? avatarUrl;
  final String fullName;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final normalizedUrl = avatarUrl?.trim();
    final initial =
        fullName.trim().characters.firstOrNull?.toUpperCase() ?? 'F';

    return ShadAvatar(
      normalizedUrl == null || normalizedUrl.isEmpty ? null : normalizedUrl,
      size: size,
      placeholder: Text(
        initial,
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
      ),
    );
  }
}
