import 'package:flutter/material.dart';
import '../data/data_model/user_data.dart';
import 'screens/registration_screen.dart';
import 'screens/home_screen.dart';
import 'screens/user_info.dart';
import 'screens/settings_screen.dart';

final ValueNotifier<bool> isDarkThemeNotifier = ValueNotifier(false);

void main() {
  runApp(DyslexiaApp());
}

class DyslexiaApp extends StatelessWidget {
  const DyslexiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkThemeNotifier,
      builder: (context, isDarkTheme, child) {
        return MaterialApp(
          theme: isDarkTheme
              ? ThemeData.dark().copyWith(
            primaryColor: Colors.purple,
            scaffoldBackgroundColor: Colors.black,
            colorScheme: const ColorScheme.dark(
              primary: Colors.purple,
              secondary: Colors.purpleAccent,
              surface: Colors.black,
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: Colors.white,
            ),
            appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.black,
              selectedItemColor: Colors.purple,
              unselectedItemColor: Colors.white70,
            ),
            cardColor: Colors.black,
            dividerColor: Colors.purple[700],
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              titleLarge: TextStyle(color: Colors.white),
              titleMedium: TextStyle(color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Colors.purple), dialogTheme: DialogThemeData(backgroundColor: Colors.black),
          )
              : ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF1E90FF),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.black54,
            ),
          ),
          home: RegistrationScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final UserData? userData;

  const MainScreen({super.key, this.userData});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _recentFiles = [
    {'name': 'file1.pdf', 'timestamp': DateTime.now().toString()},
    {'name': 'file2.pdf', 'timestamp': DateTime.now().subtract(const Duration(minutes: 5)).toString()},
  ];

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        recentFiles: _recentFiles,
        onFilesDeleted: _onFilesDeleted, // Pass the callback
        onFileUploaded: _onFileUploaded, // Pass the onFileUploaded callback
      ),
      UserInfoScreen(userData: widget.userData),
      SettingsScreen(),
    ];
  }

  void _onFileUploaded(Map<String, dynamic> file) {
    setState(() {
      _recentFiles.insert(0, file);
      if (_recentFiles.length > 5) _recentFiles.removeLast();
      _selectedIndex = 0;
    });
  }

  void _onFilesDeleted(List<int> indicesToDelete) {
    setState(() {
      // Sort indices in descending order to avoid index shifting when removing
      indicesToDelete.sort((a, b) => b.compareTo(a));
      for (int index in indicesToDelete) {
        _recentFiles.removeAt(index);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sight line'),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User Info'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}