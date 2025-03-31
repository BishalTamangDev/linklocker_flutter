import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linklocker/features/mini_profile/presentation/blocs/mini_profile_bloc.dart';
import 'package:linklocker/features/profile/domain/entities/profile_contact_entity.dart';
import 'package:linklocker/features/profile/domain/entities/profile_entity.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/functions/app_functions.dart';

class MiniProfileWidgetLoaded extends StatelessWidget {
  const MiniProfileWidgetLoaded({
    super.key,
    required this.profileEntity,
    required this.contacts,
  });

  final ProfileEntity profileEntity;
  final List<ProfileContactEntity> contacts;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 32.0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        backgroundImage: profileEntity.profilePicture!.isNotEmpty ? MemoryImage(profileEntity.profilePicture!) : AssetImage(AppConstants.defaultUserImage),
      ),
      title: Text(AppFunctions.getCapitalizedWords(profileEntity.name!)),
      subtitle: Opacity(
        opacity: 0.6,
        child: Text("My Profile", style: Theme.of(context).textTheme.bodyLarge),
      ),
      trailing: profileEntity.id == null
          ? null
          : IconButton(
              onPressed: () {
                context.read<MiniProfileBloc>().add(MiniProfileQrShareEvent(profileEntity: profileEntity, contacts: contacts));
              },
              icon: Icon(Icons.qr_code),
            ),
      onTap: () => context.read<MiniProfileBloc>().add(MiniProfileViewNavigateEvent()),
    );
  }
}
