import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/history_page.dart';


class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, __) => LoginPage()),
      GoRoute(path: '/home', builder: (_, __) => HomePage()),
      GoRoute(path: '/history', builder: (_, __) => HistoryPage()),
    ],
  );
}
