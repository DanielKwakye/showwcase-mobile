import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:github_colour/github_colour.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:showwcase_v3/app/app.dart';
import 'package:showwcase_v3/core/utils/constants.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_attachment_model.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_connection_model.dart';
import 'package:showwcase_v3/features/chat/data/models/chat_message_model.dart';
import 'package:showwcase_v3/features/users/data/models/user_model.dart';
import 'package:showwcase_v3/firebase_options.dart';

import 'core/utils/injector.dart' as di;

Future<void> main() async {

  // Ensure all dependencies are initialized
  WidgetsFlutterBinding.ensureInitialized();
  //only portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await GitHubColour.getInstance();

  // so that the status bar will show on IOS
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.top,
    SystemUiOverlay.bottom,
  ]);

  // Initialize Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver(analytics: analytics);

  // All dependence injections
  // dependencies are registered lazily to boost app performance
  await di.init();

  await Hive.initFlutter();
  Hive.registerAdapter(ChatConnectionModelAdapter());
  Hive.registerAdapter(ChatMessageModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ChatAttachmentModelAdapter());
  await Hive.openBox<ChatMessageModel>(kChatMessages);
  await Hive.openBox<ChatConnectionModel>(kChatConnections);

  //Remove this method to stop OneSignal Debugging
  //Remove this method to stop OneSignal Debugging
  // OneSignal.Debug.setLogLevel(OSLogLevel.info);
  OneSignal.initialize(kOneSignalAppId);

  // get current theme mode
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  // Bloc.observer = AppBlocObserver();



  await SentryFlutter.init(
        (options) {
      options.dsn = ''; //kDebugMode ? '' : kSentryDNS; //! Log errors only in release mode

      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp( App(savedThemeMode:  savedThemeMode)),
  );



}


