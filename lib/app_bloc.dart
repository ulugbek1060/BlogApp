import 'dart:io';

import 'package:blog_app/app_event.dart';
import 'package:blog_app/app_state.dart';
import 'package:blog_app/auth_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class AppBloc extends Bloc<AppEvetn, AppState> {
  AppBloc() : super(const AppStateLoggetOut(isLoaading: false)) {
    on<AppEventGoToRegistration>((event, emit) {
      emit(const AppStateIsInRegistrationView(
        isLoading: false,
      ));
    });

    on<AppEventLogin>((event, emit) async {
      emit(const AppStateLoggetOut(
        isLoaading: false,
      ));

      final email = event.email;
      final password = event.password;

      try {
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = userCredential.user!;
        final images = await _getImages(user.uid);
        emit(AppStateLoggedIn(
          user: user,
          images: images,
          isLoading: false,
        ));
      } on FirebaseAuthException catch (e) {
        emit(AppStateLoggetOut(
          isLoaading: false,
          error: AuthError.from(e),
        ));
      }
    });

    on<AppEventGoToLogin>((event, emit) {
      emit(const AppStateLoggetOut(
        isLoaading: false,
      ));
    });
    // regiser user
    on<AppEventRegister>((event, emit) async {
      emit(const AppStateIsInRegistrationView(
        isLoading: true,
      ));

      final email = event.email;
      final password = event.password;

      try {
        final credentials = FirebaseAuth.instance
          ..createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

        // // get user images
        // final uid = credentials.currentUser!.uid;

        emit(AppStateLoggedIn(
          user: credentials.currentUser!,
          images: const [],
          isLoading: false,
        ));
      } on FirebaseAuthException catch (e) {
        emit(AppStateIsInRegistrationView(
          isLoading: false,
          error: AuthError.from(e),
        ));
      }
    });

    //get the curren user
    on<AppEventInitialize>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const AppStateLoggetOut(
          isLoaading: false,
        ));
        return;
      }
      final images = await _getImages(user.uid);
      emit(AppStateLoggedIn(
        user: user,
        images: images,
        isLoading: false,
      ));
    });

    //log out event
    on<AppEventLogOut>((event, emit) async {
      emit(const AppStateLoggetOut(
        isLoaading: true,
      ));

      // log the user out
      await FirebaseAuth.instance.signOut();
      // log the user out in the ui
      emit(const AppStateLoggetOut(
        isLoaading: false,
      ));
    });

    //handle delete accoun
    on<AppEventDeleteAccount>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const AppStateLoggetOut(
          isLoaading: false,
        ));
        return;
      }

      //loading
      emit(AppStateLoggedIn(
        user: user,
        images: state.images ?? [],
        isLoading: true,
      ));

      // delete the user
      try {
        final folderContents =
            await FirebaseStorage.instance.ref(user.uid).listAll();
        for (final item in folderContents.items) {
          await item.delete().catchError((_) {});
        }
        FirebaseStorage.instance.ref(user.uid).delete().catchError((_) {});

        //delete the user
        await user.delete();
        // log the user out
        await FirebaseAuth.instance.signOut();
        // log the user out in the ui
        emit(const AppStateLoggetOut(
          isLoaading: false,
        ));
      } on FirebaseAuthException catch (e) {
        emit(AppStateLoggedIn(
          isLoading: false,
          user: user,
          images: state.images ?? [],
          error: AuthError.from(e),
        ));
      } on FirebaseException catch (e) {
        emit(AppStateLoggedIn(
          isLoading: false,
          user: user,
          images: state.images ?? [],
          error: AuthErrorUnknown(exception: e),
        ));
      }
    });

    //handle upload image
    on<AppEventUploadImage>((event, emit) async {
      final user = state.user;

      // log user put if we have not actual user in app sate
      if (user == null) {
        emit(const AppStateLoggetOut(
          isLoaading: false,
        ));
        return;
      }

      // start the loading process
      emit(AppStateLoggedIn(
        isLoading: true,
        user: user,
        images: state.images ?? [],
      ));

      // upload the file
      final file = File(event.filePathToUpload);
      await _uploadImage(file: file, uid: user.uid);

      // after upload is compleate grab the latest file references
      final images = await _getImages(user.uid);
      emit(AppStateLoggedIn(
        isLoading: false,
        user: user,
        images: images,
      ));
    });
  }

  Future<Iterable<Reference>> _getImages(
    String uid,
  ) =>
      FirebaseStorage.instance
          .ref(uid)
          .list()
          .then((listResult) => listResult.items);

  Future<bool> _uploadImage({
    required File file,
    required String uid,
  }) =>
      FirebaseStorage.instance
          .ref(uid)
          .child(const Uuid().v4())
          .putFile(file)
          .then((_) => true)
          .catchError((_) => false);
}
