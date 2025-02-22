import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kronk/widgets/my_theme.dart';

class CodeInputWidget extends StatefulWidget {
  final MyTheme currentTheme;
  final double buttonHeight;
  final void Function(String) onCodeEntered;

  const CodeInputWidget({super.key, required this.onCodeEntered, required this.buttonHeight, required this.currentTheme});

  @override
  State<CodeInputWidget> createState() => _CodeInputWidgetState();
}

class _CodeInputWidgetState extends State<CodeInputWidget> {
  final List<TextEditingController> _controllers = List.generate(4, (int index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (int index) => FocusNode());

  @override
  void dispose() {
    for (TextEditingController controller in _controllers) {
      controller.dispose();
    }
    for (FocusNode focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _handleCodeChange() {
    String code = _controllers.map((TextEditingController controller) => controller.text.trim()).join();

    if (code.length == 4) {
      widget.onCodeEntered(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    double fieldSize = widget.buttonHeight;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        4,
        (int index) => SizedBox(
          width: fieldSize,
          height: fieldSize,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            maxLength: 1,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(fontSize: 28, color: widget.currentTheme.text3),
            showCursor: false,
            onChanged: (String value) {
              if (value.isNotEmpty) {
                if (index < 3) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  _focusNodes[index].unfocus();
                }
              } else if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }

              _handleCodeChange();
            },
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.symmetric(vertical: (fieldSize - 40) / 2),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.currentTheme.text3.withAlpha(128)),
                borderRadius: BorderRadius.circular(fieldSize / 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.currentTheme.text3, width: 2),
                borderRadius: BorderRadius.circular(fieldSize / 2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
