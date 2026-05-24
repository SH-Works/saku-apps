plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.saku_apps"
    compileSdk = flutter.compileSdkVersion
    // Pinned to the highest version any plugin requires (path_provider_android)
    // instead of `flutter.ndkVersion` to avoid the AGP "NDK version mismatch" error.
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.saku_apps"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // -------------------------------------------------------------------------
    // Saku product flavors
    //
    //   make run-dev / launch.json "Saku · Development …"  →  development
    //   make run-prod / launch.json "Saku · Production …"  →  production
    //
    // Each flavor:
    //   - has its own application ID so dev and prod can co-exist on a device
    //   - injects an "appName" manifest placeholder used by AndroidManifest.xml
    // -------------------------------------------------------------------------
    flavorDimensions += "env"
    productFlavors {
        create("development") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            manifestPlaceholders["appName"] = "Saku Dev"
        }
        create("production") {
            dimension = "env"
            manifestPlaceholders["appName"] = "Saku"
        }
    }
}

flutter {
    source = "../.."
}
