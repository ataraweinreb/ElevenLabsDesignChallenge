//
//  VoiceColorPalette.swift
//  ElevenLabs
//
//  Conic / iridescent-style presets inspired by the reference swatches.
//

import SwiftUI
import UIKit

enum VoiceColorPalette: Int, CaseIterable, Identifiable {
    case lavenderSoftPink
    case cyanBrightBlue
    case limeGreen
    case oliveEarth
    case peachBurntOrange
    case tealMintWhite
    case salmonCoral
    case purpleMagenta
    case tealDeepBlueMint
    case brightGreen

    var id: Int { rawValue }

    /// Subset shown in Voice Design combine grid (keeps layout compact).
    static var combineVoicesSelectable: [VoiceColorPalette] {
        allCases.filter { $0 != .tealDeepBlueMint && $0 != .brightGreen }
    }

    /// Stops around the hue wheel for `AngularGradient` / conic fills (metallic pinwheel).
    var conicColors: [Color] {
        switch self {
        case .lavenderSoftPink:
            return [
                Color(red: 0.95, green: 0.82, blue: 0.98),
                Color(red: 0.45, green: 0.28, blue: 0.52),
                Color(red: 1.0, green: 0.72, blue: 0.88),
                Color(red: 0.28, green: 0.14, blue: 0.35),
                Color(red: 0.82, green: 0.68, blue: 0.95),
                Color(red: 0.38, green: 0.22, blue: 0.48),
                Color(red: 0.98, green: 0.78, blue: 0.92),
                Color(red: 0.22, green: 0.12, blue: 0.30)
            ]
        case .cyanBrightBlue:
            return [
                Color(red: 0.55, green: 0.95, blue: 1.0),
                Color(red: 0.02, green: 0.12, blue: 0.38),
                Color(red: 0.25, green: 0.75, blue: 1.0),
                Color(red: 0.0, green: 0.22, blue: 0.45),
                Color(red: 0.75, green: 0.98, blue: 1.0),
                Color(red: 0.04, green: 0.18, blue: 0.42),
                Color(red: 0.35, green: 0.88, blue: 1.0),
                Color(red: 0.02, green: 0.08, blue: 0.22)
            ]
        case .limeGreen:
            return [
                Color(red: 0.65, green: 1.0, blue: 0.35),
                Color(red: 0.05, green: 0.18, blue: 0.06),
                Color(red: 0.45, green: 0.92, blue: 0.22),
                Color(red: 0.10, green: 0.35, blue: 0.12),
                Color(red: 0.78, green: 1.0, blue: 0.48),
                Color(red: 0.02, green: 0.12, blue: 0.04),
                Color(red: 0.55, green: 0.98, blue: 0.30),
                Color(red: 0.08, green: 0.28, blue: 0.10)
            ]
        case .oliveEarth:
            return [
                Color(red: 0.88, green: 0.80, blue: 0.62),
                Color(red: 0.22, green: 0.18, blue: 0.12),
                Color(red: 0.55, green: 0.52, blue: 0.28),
                Color(red: 0.32, green: 0.26, blue: 0.16),
                Color(red: 0.75, green: 0.68, blue: 0.48),
                Color(red: 0.18, green: 0.14, blue: 0.10),
                Color(red: 0.48, green: 0.45, blue: 0.28),
                Color(red: 0.28, green: 0.22, blue: 0.14)
            ]
        case .peachBurntOrange:
            return [
                Color(red: 1.0, green: 0.82, blue: 0.68),
                Color(red: 0.42, green: 0.14, blue: 0.02),
                Color(red: 1.0, green: 0.55, blue: 0.22),
                Color(red: 0.55, green: 0.18, blue: 0.04),
                Color(red: 1.0, green: 0.72, blue: 0.52),
                Color(red: 0.32, green: 0.10, blue: 0.02),
                Color(red: 0.98, green: 0.45, blue: 0.12),
                Color(red: 0.25, green: 0.08, blue: 0.02)
            ]
        case .tealMintWhite:
            return [
                Color(red: 1.0, green: 1.0, blue: 0.98),
                Color(red: 0.0, green: 0.28, blue: 0.30),
                Color(red: 0.45, green: 0.98, blue: 0.85),
                Color(red: 0.02, green: 0.18, blue: 0.22),
                Color(red: 0.75, green: 1.0, blue: 0.95),
                Color(red: 0.0, green: 0.38, blue: 0.36),
                Color(red: 0.55, green: 1.0, blue: 0.88),
                Color(red: 0.04, green: 0.22, blue: 0.24)
            ]
        case .salmonCoral:
            return [
                Color(red: 1.0, green: 0.78, blue: 0.72),
                Color(red: 0.38, green: 0.10, blue: 0.08),
                Color(red: 1.0, green: 0.45, blue: 0.32),
                Color(red: 0.55, green: 0.12, blue: 0.08),
                Color(red: 1.0, green: 0.68, blue: 0.58),
                Color(red: 0.30, green: 0.08, blue: 0.06),
                Color(red: 0.98, green: 0.38, blue: 0.28),
                Color(red: 0.42, green: 0.12, blue: 0.10)
            ]
        case .purpleMagenta:
            return [
                Color(red: 1.0, green: 0.45, blue: 0.95),
                Color(red: 0.12, green: 0.04, blue: 0.22),
                Color(red: 0.65, green: 0.25, blue: 0.95),
                Color(red: 0.28, green: 0.06, blue: 0.42),
                Color(red: 0.95, green: 0.35, blue: 1.0),
                Color(red: 0.08, green: 0.02, blue: 0.18),
                Color(red: 0.75, green: 0.35, blue: 0.98),
                Color(red: 0.18, green: 0.05, blue: 0.32)
            ]
        case .tealDeepBlueMint:
            return [
                Color(red: 0.75, green: 0.98, blue: 0.92),
                Color(red: 0.02, green: 0.10, blue: 0.28),
                Color(red: 0.15, green: 0.55, blue: 0.72),
                Color(red: 0.04, green: 0.18, blue: 0.38),
                Color(red: 0.55, green: 0.88, blue: 0.95),
                Color(red: 0.02, green: 0.22, blue: 0.32),
                Color(red: 0.35, green: 0.75, blue: 0.82),
                Color(red: 0.06, green: 0.12, blue: 0.22)
            ]
        case .brightGreen:
            return [
                Color(red: 0.55, green: 1.0, blue: 0.38),
                Color(red: 0.03, green: 0.14, blue: 0.05),
                Color(red: 0.40, green: 0.92, blue: 0.28),
                Color(red: 0.08, green: 0.32, blue: 0.12),
                Color(red: 0.70, green: 1.0, blue: 0.45),
                Color(red: 0.04, green: 0.20, blue: 0.08),
                Color(red: 0.48, green: 0.95, blue: 0.32),
                Color(red: 0.06, green: 0.25, blue: 0.10)
            ]
        }
    }

    /// Seamless angular gradient (first color repeated at end).
    var angularGradient: AngularGradient {
        let c = conicColors + [conicColors[0]]
        return AngularGradient(
            gradient: Gradient(colors: c),
            center: .center,
            angle: .degrees(0)
        )
    }

    var glowColors: [Color] {
        let c = conicColors
        return [c[0].opacity(0.75), c[min(2, c.count - 1)].opacity(0.55)]
    }

    var sliderWarmthTint: [Color] {
        switch self {
        case .lavenderSoftPink: return [Color(red: 0.45, green: 0.25, blue: 0.5), Color(red: 1.0, green: 0.65, blue: 0.85)]
        case .cyanBrightBlue: return [Color(red: 0.05, green: 0.2, blue: 0.45), Color(red: 0.45, green: 0.85, blue: 1.0)]
        case .limeGreen: return [Color(red: 0.08, green: 0.35, blue: 0.1), Color(red: 0.55, green: 1.0, blue: 0.35)]
        case .oliveEarth: return [Color(red: 0.25, green: 0.2, blue: 0.12), Color(red: 0.85, green: 0.72, blue: 0.48)]
        case .peachBurntOrange: return [Color(red: 0.5, green: 0.15, blue: 0.05), Color(red: 1.0, green: 0.55, blue: 0.28)]
        case .tealMintWhite: return [Color(red: 0.0, green: 0.35, blue: 0.35), Color(red: 0.65, green: 1.0, blue: 0.9)]
        case .salmonCoral: return [Color(red: 0.45, green: 0.1, blue: 0.08), Color(red: 1.0, green: 0.42, blue: 0.32)]
        case .purpleMagenta: return [Color(red: 0.35, green: 0.08, blue: 0.45), Color(red: 1.0, green: 0.4, blue: 0.92)]
        case .tealDeepBlueMint: return [Color(red: 0.02, green: 0.15, blue: 0.35), Color(red: 0.5, green: 0.9, blue: 0.88)]
        case .brightGreen: return [Color(red: 0.06, green: 0.28, blue: 0.1), Color(red: 0.5, green: 0.98, blue: 0.35)]
        }
    }

    var sliderPitchTint: [Color] {
        switch self {
        case .lavenderSoftPink: return [Color(red: 0.3, green: 0.15, blue: 0.4), Color(red: 0.85, green: 0.75, blue: 1.0)]
        case .cyanBrightBlue: return [Color(red: 0.0, green: 0.25, blue: 0.5), Color(red: 0.55, green: 0.95, blue: 1.0)]
        case .limeGreen: return [Color(red: 0.05, green: 0.22, blue: 0.12), Color(red: 0.65, green: 0.95, blue: 0.55)]
        case .oliveEarth: return [Color(red: 0.2, green: 0.18, blue: 0.1), Color(red: 0.7, green: 0.65, blue: 0.42)]
        case .peachBurntOrange: return [Color(red: 0.4, green: 0.12, blue: 0.04), Color(red: 1.0, green: 0.78, blue: 0.55)]
        case .tealMintWhite: return [Color(red: 0.0, green: 0.22, blue: 0.28), Color(red: 0.95, green: 1.0, blue: 0.98)]
        case .salmonCoral: return [Color(red: 0.35, green: 0.08, blue: 0.06), Color(red: 1.0, green: 0.72, blue: 0.62)]
        case .purpleMagenta: return [Color(red: 0.15, green: 0.05, blue: 0.35), Color(red: 0.7, green: 0.55, blue: 1.0)]
        case .tealDeepBlueMint: return [Color(red: 0.02, green: 0.12, blue: 0.32), Color(red: 0.45, green: 0.82, blue: 0.95)]
        case .brightGreen: return [Color(red: 0.04, green: 0.2, blue: 0.08), Color(red: 0.72, green: 1.0, blue: 0.55)]
        }
    }

    var sliderEnergyTint: [Color] {
        switch self {
        case .lavenderSoftPink: return [Color(red: 0.25, green: 0.1, blue: 0.35), Color(red: 0.92, green: 0.5, blue: 0.95)]
        case .cyanBrightBlue: return [Color(red: 0.02, green: 0.1, blue: 0.28), Color(red: 0.35, green: 0.75, blue: 1.0)]
        case .limeGreen: return [Color(red: 0.03, green: 0.15, blue: 0.05), Color(red: 0.75, green: 1.0, blue: 0.3)]
        case .oliveEarth: return [Color(red: 0.15, green: 0.12, blue: 0.08), Color(red: 0.6, green: 0.55, blue: 0.32)]
        case .peachBurntOrange: return [Color(red: 0.3, green: 0.08, blue: 0.02), Color(red: 1.0, green: 0.48, blue: 0.12)]
        case .tealMintWhite: return [Color(red: 0.0, green: 0.28, blue: 0.32), Color(red: 0.55, green: 0.95, blue: 0.82)]
        case .salmonCoral: return [Color(red: 0.32, green: 0.06, blue: 0.05), Color(red: 1.0, green: 0.35, blue: 0.25)]
        case .purpleMagenta: return [Color(red: 0.1, green: 0.02, blue: 0.22), Color(red: 0.85, green: 0.3, blue: 1.0)]
        case .tealDeepBlueMint: return [Color(red: 0.02, green: 0.08, blue: 0.22), Color(red: 0.25, green: 0.65, blue: 0.78)]
        case .brightGreen: return [Color(red: 0.04, green: 0.18, blue: 0.06), Color(red: 0.6, green: 0.98, blue: 0.38)]
        }
    }

    var shortLabel: String {
        switch self {
        case .lavenderSoftPink: return "Lavender"
        case .cyanBrightBlue: return "Cyan"
        case .limeGreen: return "Lime"
        case .oliveEarth: return "Olive"
        case .peachBurntOrange: return "Peach"
        case .tealMintWhite: return "Teal"
        case .salmonCoral: return "Coral"
        case .purpleMagenta: return "Violet"
        case .tealDeepBlueMint: return "Ocean"
        case .brightGreen: return "Green"
        }
    }

    /// Display name under the voice circle in **Combine Voices**.
    var voiceName: String {
        switch self {
        case .lavenderSoftPink: return "Lilac"
        case .cyanBrightBlue: return "Azure"
        case .limeGreen: return "Jade"
        case .oliveEarth: return "Sable"
        case .peachBurntOrange: return "Copper"
        case .tealMintWhite: return "Meridian"
        case .salmonCoral: return "Coral"
        case .purpleMagenta: return "Velvet"
        case .tealDeepBlueMint: return "Abyss"
        case .brightGreen: return "Zest"
        }
    }
}

// MARK: - Color mixing (ombre across voices)

private extension Color {
    /// Averages sRGB components; skips colors that do not resolve to RGB.
    static func averageRGB(_ colors: [Color]) -> Color {
        guard let first = colors.first else { return .white }
        if colors.count == 1 { return first }
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        var n: CGFloat = 0
        for c in colors {
            let u = UIColor(c)
            var R: CGFloat = 0
            var G: CGFloat = 0
            var B: CGFloat = 0
            var A: CGFloat = 0
            guard u.getRed(&R, green: &G, blue: &B, alpha: &A) else { continue }
            r += R
            g += G
            b += B
            a += A
            n += 1
        }
        guard n > 0 else { return first }
        return Color(
            red: Double(r / n),
            green: Double(g / n),
            blue: Double(b / n),
            opacity: Double(a / n)
        )
    }

    static func averagePairs(_ pairs: [[Color]]) -> [Color] {
        guard !pairs.isEmpty else { return [Color.white.opacity(0.4), Color.white] }
        let lows = pairs.map { $0[0] }
        let highs = pairs.map { $0[1] }
        return [averageRGB(lows), averageRGB(highs)]
    }
}

/// Blended appearance when multiple library voices are combined (ombre on the blob).
struct VoiceColorBlend: Equatable {
    var voices: Set<VoiceColorPalette>

    private var sortedVoices: [VoiceColorPalette] {
        Array(voices).sorted { $0.rawValue < $1.rawValue }
    }

    /// Merged conic stops: one voice stays native; multiple voices **interleave** stops so each
    /// palette owns clear slices of the wheel (readable ombre instead of a single muddy mix).
    var conicColors: [Color] {
        let v = sortedVoices
        guard !v.isEmpty else { return VoiceColorPalette.purpleMagenta.conicColors }
        if v.count == 1 { return v[0].conicColors }

        let stopCount = v[0].conicColors.count
        var merged: [Color] = []
        merged.reserveCapacity(stopCount * v.count)
        for i in 0 ..< stopCount {
            for voice in v {
                let colors = voice.conicColors
                merged.append(colors[i % colors.count])
            }
        }
        return merged
    }

    var glowColors: [Color] {
        let v = sortedVoices
        guard !v.isEmpty else { return VoiceColorPalette.purpleMagenta.glowColors }
        if v.count == 1 { return v[0].glowColors }

        let c = conicColors
        let hi = c[0]
        let mid = c[c.count / 2]
        return [hi.opacity(0.85), mid.opacity(0.62)]
    }

    var angularGradient: AngularGradient {
        let c = conicColors + [conicColors[0]]
        return AngularGradient(
            gradient: Gradient(colors: c),
            center: .center,
            angle: .degrees(0)
        )
    }

    var sliderWarmthTint: [Color] {
        Color.averagePairs(sortedVoices.map(\.sliderWarmthTint))
    }

    var sliderPitchTint: [Color] {
        Color.averagePairs(sortedVoices.map(\.sliderPitchTint))
    }

    var sliderEnergyTint: [Color] {
        Color.averagePairs(sortedVoices.map(\.sliderEnergyTint))
    }
}

extension Color {
    /// Warmth control for the voice blob: **0** shifts cooler (more blue), **1** warmer (amber),
    /// **0.5** leaves sRGB unchanged.
    func warmthAdjusted(_ warmth: Double) -> Color {
        let t = CGFloat(min(1, max(0, warmth)))
        let u = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        guard u.getRed(&r, green: &g, blue: &b, alpha: &a) else { return self }
        let k = (t - 0.5) * 0.62
        let nr = min(1, max(0, r + k * 0.92))
        let ng = min(1, max(0, g + k * 0.2))
        let nb = min(1, max(0, b - k * 1.02))
        return Color(red: Double(nr), green: Double(ng), blue: Double(nb), opacity: Double(a))
    }
}
