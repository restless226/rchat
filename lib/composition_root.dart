import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_app/data/datasources/datasource_contract.dart';
import 'package:my_chat_app/data/datasources/sqflite_datasource_impl.dart';
import 'package:my_chat_app/data/factories/db_factory.dart';
import 'package:my_chat_app/data/services/image_uploader.dart';
import 'package:my_chat_app/states_management/home/chats_cubit.dart';
import 'package:my_chat_app/states_management/home/home_cubit.dart';
import 'package:my_chat_app/states_management/message/message_bloc.dart';
import 'package:my_chat_app/states_management/onboarding/onboarding_cubit.dart';
import 'package:my_chat_app/states_management/onboarding/profile_image_cubit.dart';
import 'package:my_chat_app/ui/pages/home/home.dart';
import 'package:my_chat_app/ui/pages/onboarding/onboarding.dart';
import 'package:my_chat_app/viewmodels/chats_view_model.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';
import 'package:sqflite/sqflite.dart';

class CompositionRoot {
  static Rethinkdb _rethinkdb;
  static Connection _connection;
  static IUserService _userService;
  static Database _database;
  static IMessageService _messageService;
  static IDataSource _dataSource;

  static configure() async {
    _rethinkdb = Rethinkdb();
    _connection = await _rethinkdb.connect(host: '127.0.0.1', port: 28015);
    _userService = UserService(_connection, _rethinkdb);
    _database = await LocalDatabaseFactory().createDatabase();
    _messageService = MessageService(_connection, _rethinkdb);
    _dataSource = SqfliteDataSource(_database);
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
        BlocProvider(create: (BuildContext context) => imageCubit),
      ],
      child: const Onboarding(),
    );
  }

  static Widget composeHomeUi() {
    HomeCubit homeCubit = HomeCubit(_userService);
    MessageBloc messageBloc = MessageBloc(_messageService);
    ChatsViewModel chatsViewModel = ChatsViewModel(_dataSource, _userService);
    ChatsCubit chatsCubit = ChatsCubit(chatsViewModel);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => homeCubit),
        BlocProvider(create: (BuildContext context) => messageBloc),
        BlocProvider(create: (BuildContext context) => chatsCubit),
      ],
      child: const Home(),
    );
  }
}
