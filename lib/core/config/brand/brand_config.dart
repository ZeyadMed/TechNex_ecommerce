import 'package:e_commerce/core/style/assets.dart';
import 'package:flutter/material.dart';

class BrandPalette {
  final Color primary;
  final Color secondary;
  final Color scaffoldBackground;
  final Color darkPrimary;

  const BrandPalette({
    required this.primary,
    required this.secondary,
    required this.scaffoldBackground,
    required this.darkPrimary,
  });
}

class BrandAssets {
  final String logoSymbolLight;
  final String logoWordmarkLight;
  final String onboardingPrimaryImage;
  final String onboardingSecondaryImage;

  const BrandAssets({
    required this.logoSymbolLight,
    required this.logoWordmarkLight,
    required this.onboardingPrimaryImage,
    required this.onboardingSecondaryImage,
  });
}

class BrandProfile {
  final String key;
  final String appName;
  final BrandPalette palette;
  final BrandAssets assets;

  const BrandProfile({
    required this.key,
    required this.appName,
    required this.palette,
    required this.assets,
  });
}

class BrandConfig {
  BrandConfig._();

  static const String _brandKeyFromEnv =
      String.fromEnvironment('BRAND_KEY', defaultValue: 'default');

  static BrandProfile get current {
    final profile = _profiles[_brandKeyFromEnv] ?? _profiles['default']!;

    return BrandProfile(
      key: profile.key,
      appName: _stringOverride('APP_NAME') ?? profile.appName,
      palette: BrandPalette(
        primary: _colorOverride('BRAND_PRIMARY', profile.palette.primary),
        secondary: _colorOverride('BRAND_SECONDARY', profile.palette.secondary),
        scaffoldBackground: _colorOverride(
          'BRAND_SCAFFOLD_BG',
          profile.palette.scaffoldBackground,
        ),
        darkPrimary:
            _colorOverride('BRAND_DARK_PRIMARY', profile.palette.darkPrimary),
      ),
      assets: BrandAssets(
        logoSymbolLight: _stringOverride('BRAND_LOGO_SYMBOL') ??
            profile.assets.logoSymbolLight,
        logoWordmarkLight: _stringOverride('BRAND_LOGO_WORDMARK') ??
            profile.assets.logoWordmarkLight,
        onboardingPrimaryImage: _stringOverride('BRAND_ONBOARDING_PRIMARY') ??
            profile.assets.onboardingPrimaryImage,
        onboardingSecondaryImage:
            _stringOverride('BRAND_ONBOARDING_SECONDARY') ??
                profile.assets.onboardingSecondaryImage,
      ),
    );
  }

  static Color _colorOverride(String key, Color fallback) {
    final raw = _stringOverride(key);
    if (raw == null) return fallback;
    return _parseColor(raw) ?? fallback;
  }

  static String? _stringOverride(String key) {
    final value = String.fromEnvironment(key, defaultValue: '');
    if (value.trim().isEmpty) return null;
    return value.trim();
  }

  static Color? _parseColor(String input) {
    var value = input.toUpperCase().replaceAll('#', '');

    if (value.startsWith('0X')) {
      value = value.substring(2);
    }

    if (value.length == 6) {
      value = 'FF$value';
    }

    if (value.length != 8) {
      return null;
    }

    final parsed = int.tryParse(value, radix: 16);
    if (parsed == null) return null;
    return Color(parsed);
  }

  static const Map<String, BrandProfile> _profiles = {
    'default': BrandProfile(
      key: 'default',
      appName: 'Nuqta',
      palette: BrandPalette(
        primary: Color(0xFF1447E6),
        secondary: Color(0xFF0B4C7C),
        scaffoldBackground: Color(0xFFE9F3FF),
        darkPrimary: Color(0xFF64FFDA),
      ),
      assets: BrandAssets(
        logoSymbolLight: Assets.assetsImagesLogoLight,
        logoWordmarkLight: Assets.assetsImagesLogoTextLight,
        onboardingPrimaryImage: Assets.assetsImagesSellandbuy,
        onboardingSecondaryImage: Assets.assetsImagesFastShare,
      ),
    ),
    'techex': BrandProfile(
      key: 'techex',
      appName: 'TechNex E-Commerce',
      palette: BrandPalette(
        primary: Color(0xFF15304E),
        secondary: Color(0xFFEF7923),
        scaffoldBackground: Color(0xFFF2F6FB),
        darkPrimary: Color(0xFF8DB5E2),
      ),
      assets: BrandAssets(
        logoSymbolLight: Assets.assetsImagesLogtaPng,
        logoWordmarkLight: Assets.assetsImagesLogtaTextDark,
        onboardingPrimaryImage: Assets.assetsImagesBuySell,
        onboardingSecondaryImage: Assets.assetsImagesFastShare,
      ),
    ),
  };
}
