import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <== Import this
import 'package:kods/login/provider/auth_provider.dart';
import 'package:kods/utils/theme.dart';
import 'package:provider/provider.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters; // <== Add this line

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.inputFormatters, // <== Add this line
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword && !authProvider.isPasswordVisible,
          validator: validator,
          inputFormatters: inputFormatters, // <== Add this line
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              prefixIcon,
              color: AppTheme.textSecondary,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: authProvider.togglePasswordVisibility,
                    icon: Icon(
                      authProvider.isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppTheme.textSecondary,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}
