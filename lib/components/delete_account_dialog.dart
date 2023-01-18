import 'package:blog_app/components/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteAccountDialog({
  required BuildContext context,
}) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete account',
    message:
        'Are you sure you want to delete your account? You cannot undo this operation!',
    optionBuilder: () => {
      'Cancel': false,
      'Delete account': true,
    },
  ).then((value) => value ?? false);
}
