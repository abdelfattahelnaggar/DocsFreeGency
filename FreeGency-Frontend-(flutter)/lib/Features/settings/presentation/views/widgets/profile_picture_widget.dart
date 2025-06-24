import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onImageTap;
  final bool isUpdating;

  const ProfilePictureWidget({
    super.key,
    required this.imageUrl,
    required this.onImageTap,
    this.isUpdating = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          Positioned(
            bottom: 0,
            right: -12,
            child: GestureDetector(
              onTap: onImageTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                  border: Border.all(
                      width: 2,
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
                child: isUpdating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Iconsax.camera, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
