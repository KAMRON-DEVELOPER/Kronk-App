import 'package:flutter/material.dart';
import 'package:kronk/widgets/navbar.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Education Screen'),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(),
    );
  }
}
