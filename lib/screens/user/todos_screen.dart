import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kronk/widgets/my_theme.dart';
import 'package:kronk/widgets/navbar.dart';

import '../../riverpod/theme_notifier_provider.dart';

class TodosScreen extends ConsumerStatefulWidget {
  const TodosScreen({super.key});

  @override
  ConsumerState<TodosScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<TodosScreen> {
  @override
  Widget build(BuildContext context) {
    final MyTheme currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      backgroundColor: currentTheme.background1,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Todos Screen', style: TextStyle(color: currentTheme.text3, fontSize: 36)),
          ],
        ),
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
