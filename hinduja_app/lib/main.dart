import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hinduja_app/app/bindings/initial_binding.dart';
import 'package:hinduja_app/app/modules/auth/views/auth_view.dart';
import 'package:hinduja_app/app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HindujaApp());
}

class HindujaApp extends StatelessWidget {
  const HindujaApp({super.key});

  @override
  Widget build(BuildContext context) {
  
    return GetMaterialApp(
      initialBinding: InitialBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      title: "Hinduja App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      //home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _tapCount = 0;
  void updateTapCount(){
    setState(() {
      _tapCount+=1;
    });
    if (_tapCount == 3){
        _tapCount = 0;
       Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  AuthView()),
        );
    }
  }

  

  @override
  void initState() {
    super.initState();
    
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void vibrateOtherPhone() {
    // Placeholder for vibration functionality
    print("Vibration triggered on the other device.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}




