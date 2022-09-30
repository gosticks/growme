import 'package:flutter/material.dart';

const MaterialColor green = MaterialColor(0xFF273825, {
  50: Color(0xFFE5E7E5),
  100: Color(0xFFBEC3BE),
  200: Color(0xFF939C92),
  300: Color(0xFF687466),
  400: Color(0xFF475646),
  500: Color(0xFF273825),
  600: Color(0xFF233221),
  700: Color(0xFF1D2B1B),
  800: Color(0xFF172416),
  900: Color(0xFF0E170D),
});

const MaterialColor sand = MaterialColor(_sandPrimaryValue, <int, Color>{
  50: Color(0xFFFCFBF9),
  100: Color(0xFFF7F4F1),
  200: Color(0xFFF2EDE7),
  300: Color(0xFFEDE6DD),
  400: Color(0xFFE9E0D6),
  500: Color(_sandPrimaryValue),
  600: Color(0xFFE2D7CA),
  700: Color(0xFFDED2C3),
  800: Color(0xFFDACDBD),
  900: Color(0xFFD3C4B2),
});
const int _sandPrimaryValue = 0xFFE5DBCF;

const MaterialColor burnedEarth =
    MaterialColor(_burnedearthPrimaryValue, <int, Color>{
  50: Color(0xFFF7EDEA),
  100: Color(0xFFEAD3CA),
  200: Color(0xFFDDB6A7),
  300: Color(0xFFCF9883),
  400: Color(0xFFC48269),
  500: Color(_burnedearthPrimaryValue),
  600: Color(0xFFB36447),
  700: Color(0xFFAB593D),
  800: Color(0xFFA34F35),
  900: Color(0xFF943D25),
});
const int _burnedearthPrimaryValue = 0xFFBA6C4E;

const MaterialColor burnedearthAccent =
    MaterialColor(_burnedearthAccentValue, <int, Color>{
  100: Color(0xFFFFDBD3),
  200: Color(_burnedearthAccentValue),
  400: Color(0xFFFF8A6D),
  700: Color(0xFFFF7553),
});
const int _burnedearthAccentValue = 0xFFFFB2A0;
