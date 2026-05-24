# =============================================================================
# Saku — Personal Finance Tracker — Makefile
# =============================================================================

FLUTTER ?= flutter
DART    ?= dart

# -----------------------------------------------------------------------------
# Setup / housekeeping
# -----------------------------------------------------------------------------
.PHONY: help
help:
	@echo "Saku — common commands"
	@echo ""
	@echo "Setup:"
	@echo "  make get               flutter pub get"
	@echo "  make clean             flutter clean"
	@echo "  make gen               build_runner build (delete-conflicting)"
	@echo "  make watch             build_runner watch"
	@echo ""
	@echo "Run:"
	@echo "  make run-dev           run development flavor"
	@echo "  make run-prod          run production flavor"
	@echo ""
	@echo "Build APK:"
	@echo "  make apk-dev           build dev APK   (debug-friendly, smaller)"
	@echo "  make apk-prod          build prod APK  (release, split-per-abi)"
	@echo "  make appbundle-prod    build prod AAB  (Play Store upload)"
	@echo ""
	@echo "iOS:"
	@echo "  make ios-dev           build dev iOS (no codesign)"
	@echo "  make ios-prod          build prod iOS (release)"
	@echo ""
	@echo "Quality:"
	@echo "  make analyze           flutter analyze"
	@echo "  make format            dart format ."
	@echo "  make test              flutter test"

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------
.PHONY: get clean gen watch
get:
	$(FLUTTER) pub get

clean:
	$(FLUTTER) clean
	$(FLUTTER) pub get

gen:
	$(DART) run build_runner build --delete-conflicting-outputs

watch:
	$(DART) run build_runner watch --delete-conflicting-outputs

# -----------------------------------------------------------------------------
# Run
# -----------------------------------------------------------------------------
.PHONY: run-dev run-prod
run-dev:
	$(FLUTTER) run \
	    -t lib/main_development.dart \
	    --flavor development \
	    --dart-define=FLAVOR=development

run-prod:
	$(FLUTTER) run \
	    -t lib/main_production.dart \
	    --flavor production \
	    --dart-define=FLAVOR=production \
	    --release

# -----------------------------------------------------------------------------
# Android APK / AAB
# -----------------------------------------------------------------------------
.PHONY: apk-dev apk-prod appbundle-prod
apk-dev:
	$(FLUTTER) build apk \
	    -t lib/main_development.dart \
	    --flavor development \
	    --dart-define=FLAVOR=development \
	    --debug

apk-prod:
	$(FLUTTER) build apk \
	    -t lib/main_production.dart \
	    --flavor production \
	    --dart-define=FLAVOR=production \
	    --release \
	    --split-per-abi

appbundle-prod:
	$(FLUTTER) build appbundle \
	    -t lib/main_production.dart \
	    --flavor production \
	    --dart-define=FLAVOR=production \
	    --release

# -----------------------------------------------------------------------------
# iOS
# -----------------------------------------------------------------------------
.PHONY: ios-dev ios-prod
ios-dev:
	$(FLUTTER) build ios \
	    -t lib/main_development.dart \
	    --flavor development \
	    --dart-define=FLAVOR=development \
	    --debug \
	    --no-codesign

ios-prod:
	$(FLUTTER) build ios \
	    -t lib/main_production.dart \
	    --flavor production \
	    --dart-define=FLAVOR=production \
	    --release

# -----------------------------------------------------------------------------
# Quality
# -----------------------------------------------------------------------------
.PHONY: analyze format test
analyze:
	$(FLUTTER) analyze

format:
	$(DART) format .

test:
	$(FLUTTER) test
