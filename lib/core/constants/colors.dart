import 'package:flutter/material.dart';

/// ----------------------
/// BRAND
/// ----------------------
const kGold = Color(0xFFFFD700);
const kOnPrimary = Colors.black; // لون نص الأزرار على الذهبي

/// ----------------------
/// LIGHT PALETTE (مريح + طابع البردي/الرمال)
/// ----------------------
/// خلفيات
const kLightBackground = Color(0xFFECDBCA); // خلفية Scaffold
const kLightSurface    = Color(0xFFFDF8F3); // أسطح (بطاقات/حقول)
const kLightSurfaceAlt = Color(0xFFFEFBF6); // سطح مرتفع/بديل لطيف

/// نصوص
const kLightOnSurface        = Color(0xDD000000); // ~ black87
const kLightOnSurfaceVariant = Color(0x8A000000); // ~ black54
const kLightHint             = Color(0x73000000); // ~ black45

/// حدود/Outline
const kOutlineLight          = Color(0xFFD7CCC8); // بني فاتح دافئ
const kOutlineLightSoft      = Color(0xFFE8DED7); // أفتح سنة للفواصل الخفيفة

/// Chips / States
const kLightChipBg           = Color(0x148D6E63); // بني ترابي شفاف (~8%)
const kGoldSelectedLight     = Color(0x2EFFD700); // ذهبي شفاف (~18%)

/// Input
const kLightInputFill        = kLightSurface;
const kLightInputBorder      = kOutlineLight;
const kLightInputFocusBorder = kGold;

/// AppBar
const kLightAppBarFg         = Color(0xDD000000);

/// Bottom/Navigation
const kGoldDarkened = Color(0xFFE6C200);
const kLightNavBg            = kLightSurfaceAlt;
const kLightNavIndicator     = kGoldSelectedLight;

/// SnackBar/Dialog
const kLightSnackBg          = kLightSurface;
const kLightSnackFg          = kLightOnSurface;
const kLightDialogBg         = kLightSurface;

/// ----------------------
/// DARK PALETTE (بارد ومريح: Slate/Charcoal + ذهبي للعناوين)
/// ----------------------
const kDark         = Color(0xFF0F1316); // خلفية Scaffold
const kDarkSurface  = Color(0xFF151A1F); // أسطح

// نصوص
const kGrey         = Color(0xFFD8DCE0); // أساسي
const kGreyVariant  = Color(0xFFAAB2B9); // ثانوي

// حدود
const kOutlineDark  = Color(0xFF2B343C);

// Chips
const kDarkChipBg       = Color(0x33212A31);
const kGoldSelectedDark = Color(0x33FFD700);

// Input
const kDarkInputFill        = Color(0x1A1E252B);
const kDarkInputBorder      = kOutlineDark;
const kDarkInputFocusBorder = kGold;

/// Card (نفس ستايلك كثوابت)
const kCardFillOverlay     = Color(0x441F1F1F);
const kCardBorderGoldAlpha = Color(0x33FFD700);

/// Error
const kErrorRed = Color(0xFFFF5252);

