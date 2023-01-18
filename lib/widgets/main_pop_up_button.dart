import 'package:blog_app/app_bloc.dart';
import 'package:blog_app/app_event.dart';
import 'package:blog_app/components/delete_account_dialog.dart';
import 'package:blog_app/components/log_out_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MenuAction {
  logout,
  deleteAccount,
}

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (action) async {
        if (action == MenuAction.logout) {
          final sholdLogOut = await showLogOutDialog(context: context);
          if (sholdLogOut) {
            context.read<AppBloc>().add(const AppEventLogOut());
          }
        } else {
          final shoultDelete = await showDeleteAccountDialog(context: context);
          if (shoultDelete) {
            context.read<AppBloc>().add(const AppEventDeleteAccount());
          }
        }
      },
      itemBuilder: (_) {
        return [
          const PopupMenuItem(
            value: MenuAction.logout,
            child: Text('Log out'),
          ),
          const PopupMenuItem(
            value: MenuAction.deleteAccount,
            child: Text('Delete account'),
          ),
        ];
      },
    );
  }
}
