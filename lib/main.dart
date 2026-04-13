import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/question_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainPage());
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [HomePage(), QuestionPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () {
          // aksi tombol tengah
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      //navbar
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // home
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0 ? Colors.blueAccent : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),

              // survey
              IconButton(
                icon: Icon(
                  Icons.assignment,
                  color: _currentIndex == 1 ? Colors.blueAccent : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),

              // notifikasi
              IconButton(
                icon: Icon(
                  Icons.notification_add,
                  color: _currentIndex == 2 ? Colors.blueAccent : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),


              // profil
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _currentIndex == 3 ? Colors.blueAccent : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
              ),

              // SizedBox(width: 40), // ruang untuk tombol tengah
              // // ICON TAMBAHAN (opsional)
              // Icon(Icons.notifications, color: Colors.grey),
              // Icon(Icons.person, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
