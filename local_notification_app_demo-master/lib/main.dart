import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Utilisez ce key pour la navigation
      title: 'Flutter Notifications',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Local Notifications'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Show notifications'),
          onPressed: () {
            notificationService.showNotification(
                title: 'Sample title',
                body: 'It works!',
                payLoad: 'Data with payload');
          },
        ),
      ),
    );
  }
}

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_logo');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: handleNotificationClick);
    print("Notifications initialized"); // Log pour le débogage
  }

  void handleNotificationClick(NotificationResponse notificationResponse) {
    print(
        "Notification clicked: ${notificationResponse.payload}"); // Log pour le débogage
    navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => NotificationPage(data: notificationResponse.payload)));
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, playSound: true));
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    print(
        "Showing notification with payload: $payLoad"); // Log pour le débogage
    return notificationsPlugin
        .show(id, title, body, await notificationDetails(), payload: payLoad);
  }
}

class NotificationPage extends StatelessWidget {
  final String? data;

  const NotificationPage({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hello $data"),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Accepter"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Rejeter"),
            )
          ],
        ),
      ),
    );
  }
}
