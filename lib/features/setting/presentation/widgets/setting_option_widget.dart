import 'package:flutter/material.dart';

class SettingOptionWidget extends StatelessWidget {
  const SettingOptionWidget({
    super.key,
    required this.title,
    required this.description,
    required this.trailingIcon,
    required this.callback,
  });

  final String title;
  final String description;
  final IconData trailingIcon;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      isThreeLine: true,
      hoverColor: Theme.of(context).colorScheme.surface,
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Opacity(
        opacity: 0.7,
        child: Text(
          description,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
      trailing: Opacity(
        opacity: 0.6,
        child: Icon(trailingIcon, size: 20.0),
      ),
      onTap: callback,
    );
  }
}
