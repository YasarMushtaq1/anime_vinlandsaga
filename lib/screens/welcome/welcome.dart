import 'package:flutter/material.dart';
import '../../widgets/botton_navigation.dart';

void main() {
  runApp(const WelcomePage());
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/welcome.jpg',
            fit: BoxFit.cover,
          ),
          // Welcome Message and Explore Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome To \n Vinland Saga \n ',
                  style: TextStyle(
                    fontSize: 36,
                    color: Color.fromARGB(255, 255, 193, 106),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Bottom()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 211, 113, 0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Explore ',
                    style: TextStyle(
                        fontSize: 18, color: Color.fromARGB(255, 255, 219, 77)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
