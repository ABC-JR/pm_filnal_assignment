
import 'package:flutter/material.dart';

String rgbToHex(Color color){
  return '${color.red.toRadixString(16).padLeft(2 , '0')}${color.green.toRadixString(16).padLeft(2 , '0')}${color.blue.toRadixString(16).padLeft(2 , '0')}';
}

/// Converts a hex color code string to a Color
/// 
/// Returns the parsed color if valid, or a default grey color if invalid.
/// Valid formats: "FFD6A8" or "0xFFD6A8"
Color hextoColor(String hexcode) {
  try {
    // Clean up the hex code - remove '0x' prefix if present
    String cleanHex = hexcode.replaceFirst(RegExp(r'^0x'), '').toUpperCase();
    
    // Validate: must be 6 or 8 characters of hex digits (0-9, A-F only)
    if (!RegExp(r'^[0-9A-F]{6}([0-9A-F]{2})?$').hasMatch(cleanHex)) {
      print('⚠️ Invalid hex color code: $hexcode - using fallback grey color');
      return Colors.purpleAccent.shade100;
    }
    
    // Pad to 8 characters if needed (add full opacity FF)
    if (cleanHex.length == 6) {
      cleanHex = 'FF$cleanHex';
    }
    
    return Color(int.parse('0x$cleanHex'));
  } catch (e) {
    print('❌ Error parsing hex color "$hexcode": $e');
    return Colors.grey.shade500;
  }
}


