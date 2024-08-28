import 'package:flutter/material.dart';
import 'package:tripsage/screens/sign_in_page.dart';
import 'package:tripsage/screens/onboarding_page.dart';
import 'package:tripsage/screens/google_bottom_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tripsage App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/signin',
      routes: {
        '/signin': (context) => const SignInPage(),
        '/onboarding': (context) => const OnboardingPage(),
        // '/home'와 같은 페이지는 온보딩 후 사용자의 데이터를 전달받아 호출됩니다.
      },
    );
  }
}
