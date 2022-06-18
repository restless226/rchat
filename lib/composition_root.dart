import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/data/services/image_uploader.dart';
import 'package:my_chat_app/states_management/onboarding/onboarding_cubit.dart';
import 'package:my_chat_app/states_management/onboarding/profile_image_cubit.dart';
import 'package:my_chat_app/ui/pages/onboarding/onboarding.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class CompositionRoot {
  static Rethinkdb _rethinkdb;
  static Connection _connection;
  static IUserService _userService;

  static configure() async {
    _rethinkdb = Rethinkdb();
    _connection = await _rethinkdb.connect(host: '127.0.0.1', port: 28015);
    _userService = UserService(_connection, _rethinkdb);
  }

  static Widget composeOnboardingUI() {
    ImageUploader _imageUploader =
        ImageUploader('http://localhost:3000/upload');

    OnboardingCubit onboardingCubit =
        OnboardingCubit(_userService, _imageUploader);
    ProfileImageCubit imageCubit = ProfileImageCubit();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => onboardingCubit),
        BlocProvider(create: (BuildContext context) => imageCubit)
      ],
      child: const Onboarding(),
    );
  }
}
