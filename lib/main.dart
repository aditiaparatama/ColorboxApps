import 'dart:async';

import 'package:colorbox/app/widgets/my_input_theme.dart';
import 'package:colorbox/constance.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  debugPrint("setup notification");
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // print('User granted permission');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showFlutterNotification(message);
    });
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    // print('User granted provisional permission');
  } else {
    // print('User declined or has not accepted permission');
  }
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'launch_background',
        ),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    // Elsewhere in your code
    // FirebaseCrashlytics.instance.crash();

    final Smartlook smartlook = Smartlook.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      await setupFlutterNotifications();
    }

    // smartlook.start();
    // smartlook.preferences
    //     .setProjectKey('b22baee998480e0a1de9e82a5f6dce2ae61ce762');

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Colorbox",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        theme: ThemeData(
          primarySwatch: primaryWhite,
          fontFamily: "Inter",
          backgroundColor: Colors.grey.shade200,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          inputDecorationTheme: MyInputTheme().theme(),
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.blue.shade300,
            cursorColor: Colors.blue.shade300,
            selectionHandleColor: Colors.blue.shade300,
          ),
        ),
      ),
    );
  },
      ((error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack)));
}
