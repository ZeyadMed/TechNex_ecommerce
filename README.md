# e_commerce (White-Label Ready)

This project is prepared to be sold to multiple clients with different:

- app name
- primary/secondary colors
- logo and onboarding images

All branding is centralized in:

- `lib/core/config/brand/brand_config.dart`

## Brand Profiles

Two profiles are included by default:

- `default`
- `techex`

You can add any new client by inserting a new profile in `_profiles`.

## Run For A Specific Client

Use `BRAND_KEY`:

```bash
flutter run --dart-define=BRAND_KEY=default
flutter run --dart-define=BRAND_KEY=techex
```

## Override Per Build (No Code Change)

You can override brand values directly at build time:

```bash
flutter run \
	--dart-define=BRAND_KEY=default \
	--dart-define=APP_NAME="Client Store" \
	--dart-define=BRAND_PRIMARY=#1A73E8 \
	--dart-define=BRAND_SECONDARY=#0B4C7C \
	--dart-define=BRAND_SCAFFOLD_BG=#F5F9FF \
	--dart-define=BRAND_LOGO_SYMBOL=assets/images/logo_light.png \
	--dart-define=BRAND_LOGO_WORDMARK=assets/images/logo_text_light.png \
	--dart-define=BRAND_ONBOARDING_PRIMARY=assets/images/sellandbuy.png \
	--dart-define=BRAND_ONBOARDING_SECONDARY=assets/images/fastShare.png
```

Supported color formats:

- `#RRGGBB`
- `#AARRGGBB`
- `0xAARRGGBB`

## Where Branding Is Applied

- Material app title
- theme primary/secondary/scaffold colors
- splash logo symbol and wordmark
- onboarding main images
