import 'package:blog_app/app_bloc.dart';
import 'package:blog_app/app_event.dart';
import 'package:blog_app/app_state.dart';
import 'package:blog_app/components/loading_screen.dart';
import 'package:blog_app/screens/blog_screen.dart';
import 'package:blog_app/screens/login_screen.dart';
import 'package:blog_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/show_auth_error.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc()
        ..add(
          const AppEventInitialize(),
        ),
      child: MaterialApp(
        title: 'Flutter Blog',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            // handle loading
            if (state.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Loading...',
              );
            } else {
              LoadingScreen.instance().hide();
            }
            //handle errors
            if (state.error != null) {
              showAuthError(
                context: context,
                error: state.error!,
              );
            }
          },
          builder: (context, state) {
            if (state is AppStateLoggedIn) {
              return const BlogScreen();
            } else if (state is AppStateLoggetOut) {
              return const LoginScreen();
            } else if (state is AppStateIsInRegistrationView) {
              return const RegisterScreen();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
