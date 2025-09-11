// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "Numerologie.Du.Tarot.De.Marseille.Bressani.Dev",
    platforms: [
        .macOS(.v12),
        .iOS(.v18),
    ],
    products: [
        .library(
            name: "Numerologie.Du.Tarot.De.Marseille.Bressani.Dev",
            targets: ["Numerologie.Du.Tarot.De.Marseille.Bressani.Dev"]
        ),
    ],
    targets: [
        .target(
            name: "Numerologie.Du.Tarot.De.Marseille.Bressani.Dev",
            dependencies: [],
            resources: [.process("Resources")],
            linkerSettings: [
                // SystemConfiguration pour toutes les plateformes
                .linkedFramework("SystemConfiguration", .when(platforms: [.macOS, .iOS])),

                // Rust lib pour macOS uniquement
                .linkedLibrary("theme_numerologie_docx", .when(platforms: [.macOS])),
                .unsafeFlags(["-LSources/Numerologie.Du.Tarot.De.Marseille.Bressani.Dev/theme_numerologie_docx_rust/macos"], .when(platforms: [.macOS])),

                // Rust lib pour iOS uniquement (device + simulator)
                .linkedLibrary("theme_numerologie_docx", .when(platforms: [.iOS])),
                .unsafeFlags([
                    "-LSources/Numerologie.Du.Tarot.De.Marseille.Bressani.Dev/theme_numerologie_docx_rust/ios-arm64",
                    "-LSources/Numerologie.Du.Tarot.De.Marseille.Bressani.Dev/theme_numerologie_docx_rust/ios-arm64-simulator"
                ], .when(platforms: [.iOS]))
            ]
        ),
        .executableTarget(
            name: "Exec",
            dependencies: ["Numerologie.Du.Tarot.De.Marseille.Bressani.Dev"],
        )
    ]
)
