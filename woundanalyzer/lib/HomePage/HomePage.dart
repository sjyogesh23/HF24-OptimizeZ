import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:woundanalyzer/HomePage/AccountDetailspage.dart';
import 'package:woundanalyzer/HomePage/Components/Appbar.dart';
import 'package:woundanalyzer/HomePage/Components/Bottomnavabar.dart';
import 'package:woundanalyzer/const.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Define selectedIndex here

  final List<Widget> _screens = [HomeScreen(), AccountDetailsPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update _selectedIndex when tab is tapped
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _screens[selectedIndex],
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      // Handle the selected image here
      // For example, you can display the selected image in a new widget
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectedImageScreen(imagePath: image.path),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverPersistentHeader(
            delegate: SliverSearchAppBar(),
            pinned: true,
          ),
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      //   _pickImage(context, ImageSource.camera);

                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text('Open Gallery'),
                                onTap: () {
                                  _pickImage(context, ImageSource.gallery);
                                  // Close the bottom sheet after selection
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('Open Camera'),
                                onTap: () {
                                  _pickImage(context, ImageSource.camera);
                                  //   Navigator.pop(
                                  //       context); // Close the bottom sheet after selection
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[200],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 48,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to Select Image',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // AnimatedTextKit for displaying animated text
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectedImageScreen extends StatelessWidget {
  final String imagePath;

  const SelectedImageScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Image'),
      ),
      body: Center(
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
