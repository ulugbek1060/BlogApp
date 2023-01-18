import 'package:blog_app/components/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showLogOutDialog({
  required BuildContext context,
}) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    message: 'Are you sure you want to log out?',
    optionBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then((value) => value ?? false);
}
