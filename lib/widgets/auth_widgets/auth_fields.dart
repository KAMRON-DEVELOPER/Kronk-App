import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kronk/widgets/my_theme.dart';

class AuthInputFieldWidget extends StatefulWidget {
  final MyTheme currentTheme;
  final String fieldName;
  final TextEditingController controller;
  final String? errorText;
  final void Function(String) onChanged;
  final double buttonHeight;

  const AuthInputFieldWidget({
    super.key,
    required this.currentTheme,
    required this.fieldName,
    required this.controller,
    required this.errorText,
    required this.onChanged,
    required this.buttonHeight,
  });

  @override
  State<AuthInputFieldWidget> createState() => _AuthInputFieldWidgetState();
}

class _AuthInputFieldWidgetState extends State<AuthInputFieldWidget> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.fieldName == 'password' && !isPasswordVisible,
      style: TextStyle(color: widget.currentTheme.text2),
      cursorColor: widget.currentTheme.text2,
      onChanged: widget.onChanged,
      autofillHints: [widget.fieldName == 'username' ? AutofillHints.username : (widget.fieldName == 'email' ? AutofillHints.email : AutofillHints.password)],
      decoration: InputDecoration(
        hintText: widget.fieldName,
        hintStyle: TextStyle(color: widget.currentTheme.text2.withAlpha(128)),
        errorText: widget.errorText,
        errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
        constraints: BoxConstraints(maxHeight: widget.buttonHeight + (widget.errorText != null ? 20 : 0), minHeight: widget.buttonHeight + (widget.errorText != null ? 20 : 0)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.currentTheme.text2.withAlpha(128)), borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.currentTheme.text2), borderRadius: BorderRadius.circular(12)),
        errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.circular(widget.buttonHeight / 2)),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent.withAlpha(128)), borderRadius: BorderRadius.circular(12)),
        suffixIcon: widget.fieldName == 'password'
            ? IconButton(
                icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: widget.currentTheme.text2.withAlpha(128)),
                onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
              )
            : null, // Show eye icon only for password field
      ),
    );
  }
}

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
