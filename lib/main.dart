import 'package:fluter_intern_tech_master/1/ques_one.dart';
import 'package:fluter_intern_tech_master/2/c1/ui_chat.dart';
import 'package:fluter_intern_tech_master/2/c2/ui_chat.dart';
import 'package:fluter_intern_tech_master/3/native_caller.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Single_Pendulum()),
                );
              },
              child: Container(
                color: Colors.blue,
                child: const Center(
                  child: Text(
                    'Bài 1',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AudioPage1()),
                      );
                    },
                    child: Container(
                      color: Colors.green,
                      child: const Center(
                        child: Text(
                          'Bài 2C1',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AudioPage2()),
                      );
                    },
                    child: Container(
                      color: const Color.fromARGB(255, 175, 76, 76),
                      child: const Center(
                        child: Text(
                          'Bài 2C2',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Quadratic_equation()),
                );
              },
              child: Container(
                color: Colors.orange,
                child: const Center(
                  child: Text(
                    'Bài 3',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
