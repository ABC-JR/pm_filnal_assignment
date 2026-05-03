
import 'package:first_video/core/theme/theme.dart';
import 'package:first_video/features/auth/presentation/pages/sign_in_pages.dart';

import 'package:first_video/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:first_video/features/home/data/model/spam_response.dart';
import 'package:first_video/features/home/domain/chat.dart';
import 'package:first_video/features/home/domain/model/responce_msg.dart';
import 'package:first_video/features/home/presentation/pages/homepage.dart';


import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';



void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox('songsBox');
  final container = ProviderContainer();
  final notifier = container.read(authViewmodelProvider.notifier);
  await notifier.initSharedPreferences();
  final usermdeo = await notifier.getcurrenuser();

  Hive.registerAdapter(SpamResponseAdapter());
  Hive.registerAdapter(ResponceMsgAdapter());
  Hive.registerAdapter(ChatAdapter());

  await Hive.openBox<ResponceMsg>('chatBox');
  await Hive.openBox<Chat>('chats');

  print(usermdeo);
  
  runApp(
    UncontrolledProviderScope(
      child: const MyApp(),
      container: container,
    )
  );
}


class MyApp extends ConsumerWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current_user = ref.watch(authViewmodelProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: AppTheme.darkthemode,
      home: current_user == null ? const SignInPages() : const Homepage(),
    );
  }
}