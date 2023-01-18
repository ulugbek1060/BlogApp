import 'package:blog_app/auth_error.dart';
import 'package:blog_app/components/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showAuthError({
  required BuildContext context,
  required AuthError error,
}) {
  return showGenericDialog<bool>(
    context: context,
    title: error.errorTitle,
    message: error.errorDescription,
    optionBuilder: () => {
      'Ok': true,
    },
  );
}
