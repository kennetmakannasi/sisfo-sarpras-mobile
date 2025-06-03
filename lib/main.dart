import 'package:flutter/material.dart';
import 'app_router.dart';
import 'services/api_service.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.loadToken(); // <- ini penting
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // ⬅️ background putih untuk semua halaman
      ),
    );
  }
}
