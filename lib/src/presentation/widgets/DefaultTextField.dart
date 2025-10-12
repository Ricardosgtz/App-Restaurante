import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultTextField extends StatefulWidget {
  final String label;
  final String? initialValue;
  final String? errorText;
  final TextInputType? textInputType;
  final IconData icon;
  final Color? color;
  final Function(String text) onChanged;
  final String? Function(String?)? validator;
  final bool obscureText;

  const DefaultTextField({
    Key? key,
    required this.label,
    required this.icon,
    required this.onChanged,
    this.errorText,
    this.initialValue,
    this.validator,
    this.color = const Color(0xFF8B0000),
    this.obscureText = false,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  @override
  _DefaultTextFieldState createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.poppins(
      fontSize: 16,
      color: Colors.black87,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            obscureText: _obscure,
            initialValue: widget.initialValue,
            onChanged: widget.onChanged,
            keyboardType: widget.textInputType,
            validator: widget.validator,
            style: textStyle,
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: GoogleFonts.poppins(
                color: widget.color,
                fontWeight: FontWeight.w500,
              ),
              hintText: "Escribe aquí...",
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              prefixIcon: Icon(widget.icon, color: widget.color),
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 18,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: widget.color!.withOpacity(0.3), width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: widget.color!, width: 1.8),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.red, width: 1.8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.red, width: 1.8),
              ),
            ),
          ),
          if (widget.errorText != null && widget.errorText!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 5),
              child: Text(
                widget.errorText!,
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
