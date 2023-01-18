import 'package:blog_app/auth_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;

extension GetUser on AppState {
  User? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

extension GetImages on AppState {
  Iterable<Reference>? get images {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.images;
    } else {
      return null;
    }
  }
}

@immutable
class AppState {
  final bool isLoading;
  final AuthError? error;

  const AppState({
    required this.isLoading,
    required this.error,
  });

  @override
  String toString() => {
        'isLoading': isLoading,
        'error': error,
      }.toString();
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;

  const AppStateLoggedIn({
    required this.user,
    required this.images,
    required bool isLoading,
    AuthError? error,
  }) : super(
          isLoading: isLoading,
          error: error,
        );

  @override
  bool operator ==(other) {
    final otherClass = other;
    if (otherClass is AppStateLoggedIn) {
      return isLoading == otherClass.isLoading &&
          user.uid == otherClass.user.uid &&
          images.length != otherClass.images.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(
        user.uid,
        images,
      );
}

@immutable
class AppStateLoggetOut extends AppState {
  const AppStateLoggetOut({
    required bool isLoaading,
    AuthError? error,
  }) : super(
          isLoading: isLoaading,
          error: error,
        );
}

@immutable
class AppStateIsInRegistrationView extends AppState {
  const AppStateIsInRegistrationView({
    required bool isLoading,
    AuthError? error,
  }) : super(
          isLoading: isLoading,
          error: error,
        );
}
