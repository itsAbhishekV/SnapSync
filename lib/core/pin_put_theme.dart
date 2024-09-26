import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

final defaultPinPutTheme = PinTheme(
  width: 44.0,
  height: 44.0,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(32.0),
    color: Colors.white30,
    border: Border.all(
      color: Colors.grey.shade600,
      width: 2.0,
    ),
  ),
  textStyle: const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16.0,
  ),
  padding: const EdgeInsets.all(10.0),
  margin: const EdgeInsets.symmetric(
    horizontal: 2.0,
  ),
);

final focusedPinPutTheme = PinTheme(
  width: 44.0,
  height: 44.0,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(32.0),
    color: Colors.white,
    border: Border.all(
      color: Colors.deepPurple,
      width: 2.0,
    ),
  ),
  textStyle: const TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16.0,
  ),
  padding: const EdgeInsets.all(10.0),
  margin: const EdgeInsets.symmetric(
    horizontal: 2.0,
  ),
);
