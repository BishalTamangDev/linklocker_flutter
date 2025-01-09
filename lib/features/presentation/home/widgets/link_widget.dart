import 'package:flutter/material.dart';
import 'package:linklocker/core/constants/app_constants.dart';

class LinkWidget extends StatelessWidget {
  const LinkWidget({
    super.key,
    required this.linkWidgetData,
    required this.navCallBack,
    required this.callCallBack,
  });

  final Map<String, dynamic> linkWidgetData;

  final VoidCallback navCallBack;
  final VoidCallback callCallBack;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: navCallBack,
      leading: CircleAvatar(
        radius: 24.0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundImage: AssetImage('assets/images/blank_user.png'),
      ),
      title: Text(linkWidgetData['name']),
      subtitle: Text(linkWidgetData['email']),
      trailing: IconButton(
        color: AppConstants.callIconColor,
        onPressed: callCallBack,
        icon: Icon(Icons.call),
      ),
    );
  }
}
