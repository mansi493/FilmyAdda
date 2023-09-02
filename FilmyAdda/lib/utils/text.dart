import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModifiedText extends StatelessWidget {
  final String? text; // Nullable
  final Color? color; // Nullable
  final double? size; // Nullable

  const ModifiedText({Key? key, this.text, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text ?? '',
        style: GoogleFonts.roboto(color: Colors.white, fontSize: size ?? 14.0));
  }
}
