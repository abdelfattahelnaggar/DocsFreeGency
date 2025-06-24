import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../cubit/team_profile_cubit.dart';
import '../../cubit/team_profile_state.dart';

class TeamLogoWidget extends StatelessWidget {
  final String logoUrl;
  final VoidCallback onLogoTap;

  const TeamLogoWidget({
    super.key,
    required this.logoUrl,
    required this.onLogoTap,
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
            backgroundImage: NetworkImage(logoUrl),
          ),
          Positioned(
            bottom: 0,
            right: -12,
            child: GestureDetector(
              onTap: onLogoTap,
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
                child: BlocBuilder<TeamProfileCubit, TeamProfileState>(
                  builder: (context, state) {
                    if (state is TeamLogoUpdating) {
                      return const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      );
                    }
                    return const Icon(Iconsax.camera,
                        color: Colors.white, size: 20);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
