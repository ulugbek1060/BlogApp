import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvetn {
  const AppEvetn();
}

@immutable
class AppEventUploadImage implements AppEvetn {
  final String filePathToUpload;
  const AppEventUploadImage({
    required this.filePathToUpload,
  });
}

@immutable
class AppEventDeleteAccount implements AppEvetn {
  const AppEventDeleteAccount();
}

@immutable
class AppEventInitialize implements AppEvetn {
  const AppEventInitialize();
}

@immutable
class AppEventLogOut implements AppEvetn {
  const AppEventLogOut();
}

@immutable
class AppEventGoToLogin implements AppEvetn {
  const AppEventGoToLogin();
}

@immutable
class AppEventLogin implements AppEvetn {
  final String email;
  final String password;

  const AppEventLogin({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventRegister implements AppEvetn {
  final String email;
  final String password;

  const AppEventRegister({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventGoToRegistration implements AppEvetn {
  const AppEventGoToRegistration();
}
