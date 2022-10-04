import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/tasks_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

final navKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navKey,
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
          backgroundColor: Colors.red,
          splash: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        'lib/assets/to-do.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'MyTodos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 60),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          nextScreen: TasksScreen(),
          splashIconSize: 200,
          splashTransition: SplashTransition.slideTransition,
          duration: 3000,
        )

        //TasksScreen()

        );
  }
}
