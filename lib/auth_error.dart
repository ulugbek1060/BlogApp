import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/foundation.dart' show immutable;

const Map<String, AuthError> authErrorMapping = {
  'no-current-user': AuthErrorNoCurrentUser(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
  'operation-not-allowed': AuthErrorOperationNotAllowed(),
  'user-not-found': AuthErrorUserNotFound(),
  'weak-password': AuthErrorWeakPassword(),
  'invaild-email': AuthErrorInavalidEmail(),
  'email-already-in-use': AuthErrorEmailInUser()
};

@immutable
abstract class AuthError {
  final String errorTitle;
  final String errorDescription;

  const AuthError({
    required this.errorTitle,
    required this.errorDescription,
  });

  factory AuthError.from(FirebaseAuthException exception) =>
      authErrorMapping[exception.code.toLowerCase().trim()] ??
      AuthErrorUnknown(exception: exception);
}

@immutable
class AuthErrorUnknown extends AuthError {
  //implement custom error
  AuthErrorUnknown({Exception? exception})
      : super(
          errorTitle: 'Authentication error',
          errorDescription: exception?.toString() ?? 'Unknown Auth error',
        );
}

//auth/no-current-user
@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          errorTitle: 'No current user!',
          errorDescription: 'No current user with this information was found!',
        );
}

//auth/requires-recent-login
@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin()
      : super(
          errorTitle: 'Requires recent login',
          errorDescription:
              'You need to log out and login in order to perform this operation.',
        );
}

//auth/operation-not-allowed
@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed()
      : super(
          errorTitle: 'Operation not allowed',
          errorDescription:
              'You cannot regisert using this method at this time!',
        );
}

//auth/user-not-found
@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          errorTitle: 'User not found',
          errorDescription: 'The given user was not found on the server!',
        );
}

//auth/weak-password
@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
          errorTitle: 'Weak password',
          errorDescription:
              'Please choose a stronger password consisting of more character!',
        );
}

//auth/invaild-email
@immutable
class AuthErrorInavalidEmail extends AuthError {
  const AuthErrorInavalidEmail()
      : super(
          errorTitle: 'Invalid email',
          errorDescription: 'Please double check your email and try again!',
        );
}

//auth/email-already-in-use
@immutable
class AuthErrorEmailInUser extends AuthError {
  const AuthErrorEmailInUser()
      : super(
          errorTitle: 'Email already in user',
          errorDescription: 'Please choose another email to register with!',
        );
}
