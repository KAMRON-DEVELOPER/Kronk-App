import 'package:flutter/material.dart';
import 'package:kronk/widgets/my_theme.dart';

class CustomToggle extends StatefulWidget {
  final MyTheme activeTheme;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const CustomToggle({super.key, required this.activeTheme, required this.isEnabled, required this.onChanged});

  @override
  CustomToggleState createState() => CustomToggleState();
}

class CustomToggleState extends State<CustomToggle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.isEnabled),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: widget.isEnabled ? widget.activeTheme.text2 : widget.activeTheme.text2.withAlpha(64),
        ),
        alignment: widget.isEnabled ? Alignment.centerRight : Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 20,
          height: 20,
          decoration: BoxDecoration(color: widget.activeTheme.foreground1, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
