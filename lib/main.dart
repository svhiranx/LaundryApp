import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:laundryappv2/Models/auth.dart';
import 'package:laundryappv2/Models/cart.dart';
import 'package:laundryappv2/Models/orders.dart';
import 'package:laundryappv2/Models/plans.dart';
import 'package:laundryappv2/Models/subscriptions.dart';
import 'package:laundryappv2/Models/product.dart';
import 'package:laundryappv2/Screens/first_screen_route.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true);
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

final InitializationSettings initializationSettings =
    const InitializationSettings(android: initializationSettingsAndroid);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.messageId);
}

showNotification(RemoteMessage message) async {
  Map<String, dynamic> data = message.data;
  print(data);
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'channel',
    'Chat messages',
    channelDescription: 'Chat messages will be received here',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
    color: Colors.green,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  FlutterLocalNotificationsPlugin().show(
    45452,
    "Spinners Alert !!!!",
    data['message'].toString(),
    platformChannelSpecifics,
    payload: 'data',
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  print('splash');
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(
        'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      showNotification(message);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),

        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(null),
          update: (context, auth, previousOrders) => Orders(auth),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(null),
          update: (context, auth, previousOrders) => Products(auth),
        ),
        ChangeNotifierProxyProvider<Auth, SubscriptionData>(
          create: (context) => SubscriptionData(null),
          update: (context, auth, previousOrders) => SubscriptionData(auth),
        ),
        ChangeNotifierProvider(create: (context) => Plan()),
        ChangeNotifierProxyProvider<SubscriptionData, Cart>(
          create: (context) => Cart(null),
          update: (context, subdata, previousOrders) => Cart(subdata),
        ),

        //  ChangeNotifierProvider(create: (context) => Cart(null)),
        ChangeNotifierProvider(create: (context) => ImageHandler())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Lato',
          textTheme: const TextTheme(
            headline1: TextStyle(
                //for Tab text
                fontFamily: 'Lato',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            headline2: TextStyle(
                // modal sheet headline
                fontFamily: 'Lato',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            bodyText1: TextStyle(
                //for News entry
                fontFamily: 'Lato',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black),
            headline5: TextStyle(
              //for Related news Entry
              fontFamily: 'Lato',
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            subtitle1: TextStyle(
                // more.. /add comment
                fontFamily: 'Lato',
                fontSize: 14,
                color: Color.fromRGBO(153, 153, 153, 1)),
            subtitle2: TextStyle(
                fontFamily: 'Lato',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(104, 113, 132, 1)),
          ),
          primarySwatch: Colors.blue,
        ),
        navigatorKey: navigatorKey,
        home: const FirstScreenRoute(),
      ),
    );
  }
}
