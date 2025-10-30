import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'services/sip_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sipService = SipService();
  runApp(MyApp(sipService: sipService));
}

class MyApp extends StatelessWidget {
  final SipService sipService;
  const MyApp({super.key, required this.sipService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SipService>.value(
      value: sipService,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VOIP App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
