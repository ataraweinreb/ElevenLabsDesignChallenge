//
//  VoiceDesignView.swift
//  ElevenLabs
//

import Combine
import SwiftUI

// MARK: - Voice design screen

struct VoiceDesignView: View {
    @State private var verticalAxis: CGFloat = 0
    @State private var horizontalAxis: CGFloat = 0
    @State private var refinement: CGFloat = 1
    @State private var warmth: Double = 0.72
    @State private var pitch: Double = 0.58
    @State private var energy: Double = 0.64
    @State private var slidersTrayOpen = false
    @State private var isHoldingPreview = false
    @State private var pulsePhase: CGFloat = 0
    /// Library voices blended into the main blob (tap circles to add/remove; at least one stays on).
    @State private var blendedVoices: Set<VoiceColorPalette> = [.purpleMagenta]

    /// Top-of-scroll anchor minY in `voiceDesignScroll` space (drives collapsing nav + blur).
    @State private var scrollAnchorMinY: CGFloat = 0

    private let blobDiameter: CGFloat = 280

    /// Global canvas (#111111).
    private let appBackground = Color(red: 17 / 255, green: 17 / 255, blue: 17 / 255)

    /// Raised surfaces — sliders card, etc. (#222222).
    private let secondaryBackground = Color(red: 34 / 255, green: 34 / 255, blue: 34 / 255)

    private let voiceDesignTrayTopCornerRadius: CGFloat = 28

    private let navCollapseThreshold: CGFloat = 72

    /// 0 = expanded / ethereal chrome, 1 = compact / strong blur (scroll content under header).
    private var navCollapseProgress: CGFloat {
        let scrolled = max(0, -scrollAnchorMinY)
        return min(1, scrolled / navCollapseThreshold)
    }

    private func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        let x = min(1, max(0, t))
        return a + (b - a) * x
    }

    /// Expanded tray height so its top clears “Combine voices” (blob stays mostly visible above).
    private func trayExpandedHeight(containerHeight: CGFloat, safeAreaTop: CGFloat) -> CGFloat {
        let navChrome: CGFloat = 66
        let blobPadTop: CGFloat = 10
        let blobBlock: CGFloat = blobDiameter + 48
        let combinePadTop: CGFloat = 14
        let overlapPastCombineHeader: CGFloat = 52

        let combineSectionTopY =
            safeAreaTop + navChrome + 1 + blobPadTop + blobBlock + combinePadTop

        let target = containerHeight - combineSectionTopY + overlapPastCombineHeader
        return min(max(target, containerHeight * 0.52), containerHeight * 0.93)
    }

    private var voiceBlend: VoiceColorBlend {
        VoiceColorBlend(voices: blendedVoices)
    }

    private var warmthAdjustedConicColors: [Color] {
        voiceBlend.conicColors.map { $0.warmthAdjusted(warmth) }
    }

    private var warmthAdjustedGlowColors: [Color] {
        voiceBlend.glowColors.map { $0.warmthAdjusted(warmth) }
    }

    private var warmthAdjustedSliderTint: [Color] {
        voiceBlend.sliderWarmthTint.map { $0.warmthAdjusted(warmth) }
    }

    var body: some View {
        ZStack {
            appBackground.ignoresSafeArea()

            GeometryReader { geo in
                ZStack(alignment: .bottom) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            scrollTrackAnchor

                            blobVisualizerSection
                                .padding(.horizontal, 16)
                                .padding(.top, 10)

                            combineVoicesSection
                                .padding(.top, 14)
                                .padding(.bottom, 20)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .coordinateSpace(name: "voiceDesignScroll")
                    .scrollBounceBehavior(.basedOnSize)
                    .onPreferenceChange(VoiceDesignScrollAnchorKey.self) { scrollAnchorMinY = $0 }
                    .safeAreaInset(edge: .top, spacing: 0) {
                        collapsingNavigationChrome
                    }
                    .frame(width: geo.size.width, height: geo.size.height)

                    slidersTrayChrome(
                        totalHeight: geo.size.height,
                        safeAreaTop: geo.safeAreaInsets.top
                    )
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .preferredColorScheme(.dark)
        .onReceive(Timer.publish(every: 1 / 30, on: .main, in: .common).autoconnect()) { _ in
            pulsePhase += 0.04
        }
    }

    // MARK: Navigation (pinned — compacts on scroll)

    private var scrollTrackAnchor: some View {
        GeometryReader { geo in
            Color.clear.preference(
                key: VoiceDesignScrollAnchorKey.self,
                value: geo.frame(in: .named("voiceDesignScroll")).minY
            )
        }
        .frame(height: 1)
    }

    private var collapsingNavigationChrome: some View {
        let p = navCollapseProgress

        return VStack(spacing: 0) {
            HStack(alignment: .center, spacing: lerp(14, 10, p)) {
                Text("Voice Studio")
                    .font(.system(size: lerp(30, 16.5, p), weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color.white,
                                Color.white.opacity(lerp(0.88, 0.78, p))
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .tracking(lerp(0.12, 0.06, p))
                    .lineLimit(1)
                    .minimumScaleFactor(0.55)
                    .frame(maxWidth: .infinity, alignment: .leading)
                profileNavButton(collapseProgress: p)
            }
            .padding(.horizontal, lerp(18, 14, p))
            .padding(.top, lerp(10, 4, p))
            .padding(.bottom, lerp(8, 5, p))
        }
        .animation(.spring(response: 0.32, dampingFraction: 0.86), value: navCollapseProgress)
    }

    private func circleNavButton(icon: String, collapseProgress p: CGFloat) -> some View {
        let size = lerp(44, 34, p)
        let iconSz = lerp(15, 12.5, p)
        let shadowR = lerp(10, 5, p)
        return Button(action: {}) {
            Image(systemName: icon)
                .font(.system(size: iconSz, weight: .semibold))
                .foregroundStyle(.white.opacity(lerp(0.95, 0.92, p)))
                .frame(width: size, height: size)
                .background {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Circle()
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(lerp(0.22, 0.14, p)),
                                            Color.white.opacity(lerp(0.06, 0.04, p))
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: Color.black.opacity(Double(lerp(0.45, 0.28, p))), radius: shadowR, y: lerp(5, 3, p))
                }
        }
        .buttonStyle(.plain)
    }

    /// Circular profile control with concentric rings.
    private func profileNavButton(collapseProgress p: CGFloat) -> some View {
        let size = lerp(46, 36, p)
        let shadowR = lerp(10, 5, p)
        let iconSz = lerp(17, 13.5, p)
        let outerBezel: CGFloat = max(2, size * 0.085)
        let midRingD = size * 0.88
        let innerFillD = size * 0.62

        return Button(action: {}) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(lerp(0.14, 0.11, p)), lineWidth: outerBezel)
                    .frame(width: size, height: size)

                Circle()
                    .stroke(Color.white.opacity(0.07), lineWidth: 1)
                    .frame(width: midRingD, height: midRingD)

                Circle()
                    .fill(Color(red: 0.07, green: 0.07, blue: 0.075))
                    .frame(width: innerFillD, height: innerFillD)

                Image(systemName: "person.fill")
                    .font(.system(size: iconSz, weight: .medium))
                    .foregroundStyle(Color.white.opacity(lerp(0.42, 0.38, p)))
            }
            .frame(width: size, height: size)
            .shadow(color: Color.black.opacity(Double(lerp(0.42, 0.28, p))), radius: shadowR, y: lerp(5, 3, p))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Profile")
    }

    // MARK: Blob (scrolls under the collapsing glass nav)

    private var blobVisualizerSection: some View {
        VoiceBlobInteractive(
            conicColors: warmthAdjustedConicColors,
            glowColors: warmthAdjustedGlowColors,
            diameter: blobDiameter,
            verticalAxis: $verticalAxis,
            horizontalAxis: $horizontalAxis,
            refinement: $refinement,
            warmth: warmth,
            pitch: pitch,
            energy: energy,
            isHoldingPreview: $isHoldingPreview,
            pulsePhase: pulsePhase
        )
        .frame(width: blobDiameter + 48, height: blobDiameter + 48)
    }

    // MARK: Combine Voices (grid)

    private var combineVoicesSection: some View {
        paletteStrip
    }

    private var paletteStrip: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Combine voices")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.97),
                            Color.white.opacity(0.82)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .tracking(0.35)
                .padding(.horizontal, 20)

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 82), alignment: .top)],
                spacing: 26
            ) {
                ForEach(VoiceColorPalette.combineVoicesSelectable) { item in
                    combineVoiceChip(item)
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func combineVoiceChip(_ item: VoiceColorPalette) -> some View {
        Button {
            withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                if blendedVoices.contains(item) {
                    if blendedVoices.count > 1 {
                        blendedVoices.remove(item)
                    }
                } else {
                    blendedVoices.insert(item)
                }
            }
        } label: {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.35))
                        .frame(width: 62, height: 62)
                        .blur(radius: 10)

                    Circle()
                        .fill(item.angularGradient)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Circle()
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(blendedVoices.contains(item) ? 0.35 : 0.14),
                                            Color.white.opacity(0.05)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: blendedVoices.contains(item) ? 1.25 : 0.75
                                )
                        )
                        .shadow(color: item.conicColors[0].opacity(0.42), radius: 14, y: 5)
                        .shadow(color: Color.black.opacity(0.45), radius: 8, y: 4)

                    if blendedVoices.contains(item) {
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.98),
                                        Color.white.opacity(0.72)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2.5
                            )
                            .frame(width: 70, height: 70)
                            .shadow(color: Color.white.opacity(0.28), radius: 8, y: 0)
                    }
                }
                .frame(height: 74)

                Text(item.voiceName)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .tracking(0.12)
                    .foregroundStyle(
                        blendedVoices.contains(item)
                            ? Color.white.opacity(0.88)
                            : Color.white.opacity(0.52)
                    )
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            blendedVoices.contains(item)
                ? "\(item.voiceName), blended into voice"
                : "\(item.voiceName), add to voice blend"
        )
    }

    // MARK: Sliders tray (bottom sheet toggle)

    private func slidersTrayChrome(totalHeight: CGFloat, safeAreaTop: CGFloat) -> some View {
        let trayShape = UnevenRoundedRectangle(
            topLeadingRadius: voiceDesignTrayTopCornerRadius,
            bottomLeadingRadius: 0,
            bottomTrailingRadius: 0,
            topTrailingRadius: voiceDesignTrayTopCornerRadius,
            style: .continuous
        )

        return VStack(spacing: 0) {
            if slidersTrayOpen {
                slidersCard
                    .transition(.move(edge: .bottom).combined(with: .opacity))

                Spacer(minLength: 40)
            }

            HStack(alignment: .center, spacing: 12) {
                Button {
                    withAnimation(.spring(response: 0.38, dampingFraction: 0.88)) {
                        slidersTrayOpen.toggle()
                    }
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.95))
                        .frame(width: 54, height: 54)
                        .background {
                            Circle()
                                .fill(secondaryBackground)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                )
                        }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(slidersTrayOpen ? "Hide voice controls" : "Show voice controls")

                Button(action: {}) {
                    Text("Generate voice")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(
                            Capsule(style: .continuous)
                                .fill(Color(red: 0.93, green: 0.93, blue: 0.94))
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Generate voice")
            }
            .padding(.horizontal, 20)
            .padding(.top, slidersTrayOpen ? 8 : 0)
        }
        .padding(.top, 14)
        .padding(.bottom, 18)
        .frame(maxWidth: .infinity)
        .frame(
            maxHeight: slidersTrayOpen
                ? trayExpandedHeight(containerHeight: totalHeight, safeAreaTop: safeAreaTop)
                : nil,
            alignment: .bottom
        )
        .background {
            trayShape
                .fill(appBackground)
                .ignoresSafeArea(edges: .bottom)
        }
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.white.opacity(0.07))
                .frame(height: 1)
                .padding(.horizontal, 24)
        }
        .clipShape(trayShape)
        .shadow(color: Color.black.opacity(0.4), radius: 24, y: -10)
    }

    private var slidersCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            VoiceSliderRow(
                title: "Warmth",
                leadingLabel: "Cool",
                trailingLabel: "Warm",
                value: $warmth,
                tint: warmthAdjustedSliderTint
            )
            VoiceSliderRow(
                title: "Pitch",
                leadingLabel: "Low",
                trailingLabel: "High",
                value: $pitch,
                tint: voiceBlend.sliderPitchTint
            )
            VoiceSliderRow(
                title: "Energy",
                leadingLabel: "Calm",
                trailingLabel: "Intense",
                value: $energy,
                tint: voiceBlend.sliderEnergyTint
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 6)
        .padding(.bottom, 4)
    }
}

// MARK: - Interactive blob

private struct VoiceBlobInteractive: View {
    var conicColors: [Color]
    var glowColors: [Color]
    let diameter: CGFloat
    @Binding var verticalAxis: CGFloat
    @Binding var horizontalAxis: CGFloat
    @Binding var refinement: CGFloat
    var warmth: Double
    var pitch: Double
    var energy: Double
    @Binding var isHoldingPreview: Bool
    var pulsePhase: CGFloat

    @GestureState private var dragSession: CGSize = .zero
    @GestureState private var pinchSession: CGFloat = 1

    var body: some View {
        ZStack {
            VoiceBlobShape(
                conicColors: conicColors,
                glowColors: glowColors,
                diameter: diameter,
                verticalAxis: verticalAxis + (dragSession.height / diameter),
                horizontalAxis: horizontalAxis + (dragSession.width / diameter),
                refinement: refinement * pinchSession,
                warmth: warmth,
                pitch: pitch,
                energy: energy,
                pulsePhase: pulsePhase,
                glowBoost: isHoldingPreview ? 1.35 : 1
            )
            .scaleEffect(isHoldingPreview ? 1.04 : 1)
            .animation(.easeInOut(duration: 0.35), value: isHoldingPreview)

            if isHoldingPreview {
                Text("Previewing…")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial, in: Capsule())
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .contentShape(Rectangle())
        .gesture(dragGesture)
        .simultaneousGesture(magnificationGesture)
        .simultaneousGesture(longPressGesture)
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($dragSession) { value, state, _ in
                state = value.translation
            }
            .onEnded { value in
                let nx = horizontalAxis + value.translation.width / diameter
                let ny = verticalAxis - value.translation.height / diameter
                horizontalAxis = max(-1, min(1, nx))
                verticalAxis = max(-1, min(1, ny))
            }
    }

    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .updating($pinchSession) { value, state, _ in
                state = value
            }
            .onEnded { value in
                refinement = max(0.65, min(1.45, refinement * value))
            }
    }

    private var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: 0.45)
            .onEnded { _ in
                withAnimation(.spring(response: 0.32, dampingFraction: 0.78)) {
                    isHoldingPreview = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation {
                        isHoldingPreview = false
                    }
                }
            }
    }
}

// MARK: - Blob drawing (shared)

private struct VoiceBlobShape: View {
    var conicColors: [Color]
    var glowColors: [Color]
    let diameter: CGFloat
    var verticalAxis: CGFloat
    var horizontalAxis: CGFloat
    var refinement: CGFloat
    var warmth: Double
    var pitch: Double
    var energy: Double
    var pulsePhase: CGFloat
    var glowBoost: CGFloat = 1

    private var conicGradient: Gradient {
        guard let first = conicColors.first else {
            return Gradient(colors: [.purple, .pink])
        }
        let c = conicColors + [first]
        return Gradient(colors: c)
    }

    private var glowStroke: LinearGradient {
        let g = glowColors
        guard !g.isEmpty else {
            return LinearGradient(colors: [.purple.opacity(0.5), .blue.opacity(0.35)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        let hi = g[0].opacity(0.65 * Double(glowBoost))
        let lo = g[min(1, g.count - 1)].opacity(0.4 * Double(glowBoost))
        return LinearGradient(colors: [hi, lo], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var body: some View {
        blobCanvas
            .frame(width: diameter, height: diameter)
            .blur(radius: 0.5)
            .overlay {
                Circle()
                    .stroke(glowStroke, lineWidth: 1.5)
                    .blur(radius: 6)
                    .frame(width: diameter * 0.92, height: diameter * 0.92)
            }
            .allowsHitTesting(false)
    }

    private var blobCanvas: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let r = min(size.width, size.height) / 2 * 0.88
            let warmthF = CGFloat(warmth)
            let pitchF = CGFloat(pitch)
            let energyF = CGFloat(energy)
            let layers = 14
            let gx = center.x + horizontalAxis * r * 0.14
            let gy = center.y - verticalAxis * r * 0.12
            let grad = conicGradient
            let pinchCenter = CGPoint(x: gx, y: gy)

            for i in 0 ..< layers {
                let t = CGFloat(i) / CGFloat(layers - 1)
                // Pitch drives ripple density (high = tight ripples) and silhouette stretch.
                let rippleFreq = 2.0 + pitchF * 11.5 + refinement * 2.4 + energyF * 1.5 + warmthF * 0.35
                let wobbleMag = 0.078 * refinement * (1 + 0.38 * abs(horizontalAxis)) * (0.36 + pitchF * 0.88)
                let wobble = wobbleMag * sin(pulsePhase + t * 6)
                let bulge = 0.04 * verticalAxis * cos(t * .pi * 2)
                let overtoneMag = pitchF * 0.052 * refinement
                let lateralStretch = 1.04 - pitchF * 0.075
                let verticalStretch = 0.96 + pitchF * 0.095
                let phase = pulsePhase * 0.5 + CGFloat(i) * 0.09 + pitchF * .pi * 0.35
                let path = blobPath(
                    center: center,
                    baseRadius: r * (0.55 + 0.45 * t),
                    wobble: wobble + bulge,
                    frequency: rippleFreq,
                    phase: phase,
                    horizontalPull: horizontalAxis * 0.12,
                    overtone: overtoneMag,
                    lateralStretch: lateralStretch,
                    verticalStretch: verticalStretch
                )
                let spin = Angle.degrees(Double(pulsePhase * 38) + Double(i) * 11 + Double(warmthF) * 18)
                context.opacity = 0.07 + Double(t) * 0.11
                context.blendMode = .screen
                context.fill(path, with: .conicGradient(grad, center: pinchCenter, angle: spin))
            }
            context.blendMode = .normal
            context.opacity = 1
        }
    }

    private func blobPath(
        center: CGPoint,
        baseRadius: CGFloat,
        wobble: CGFloat,
        frequency: CGFloat,
        phase: CGFloat,
        horizontalPull: CGFloat,
        overtone: CGFloat,
        lateralStretch: CGFloat,
        verticalStretch: CGFloat
    ) -> Path {
        var path = Path()
        let steps = 72
        for i in 0 ... steps {
            let a = CGFloat(i) / CGFloat(steps) * .pi * 2
            let fundamental = wobble * sin(a * frequency + phase)
            let doubleHarmonic = overtone * sin(a * frequency * 2 + phase * 1.12 + 0.35)
            let mod = 1 + fundamental + horizontalPull * cos(a) + doubleHarmonic
            let rr = baseRadius * mod
            let pt = CGPoint(
                x: center.x + cos(a) * rr * lateralStretch,
                y: center.y + sin(a) * rr * verticalStretch
            )
            if i == 0 { path.move(to: pt) } else { path.addLine(to: pt) }
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Gradient slider row

private struct VoiceSliderRow: View {
    let title: String
    let leadingLabel: String
    let trailingLabel: String
    @Binding var value: Double
    let tint: [Color]

    private let trackHeight: CGFloat = 36

    /// Nearly square ends (reference-style bar), continuous corners for polish.
    private let trackCornerRadius: CGFloat = 7

    private var trackShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: trackCornerRadius, style: .continuous)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack {
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                Spacer()
                Text("\(Int(value * 100))%")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.55))
                    .monospacedDigit()
            }

            GeometryReader { geo in
                let w = geo.size.width
                let rawFill = w * CGFloat(value)
                let fillWidth = value <= 0 ? 0 : max(rawFill, min(20, w * 0.065))

                ZStack {
                    trackShape
                        .fill(Color.white.opacity(0.055))

                    Rectangle()
                        .fill(
                            LinearGradient(colors: tint, startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: fillWidth, height: trackHeight)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack {
                        Text(leadingLabel)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                        Spacer()
                        Text(trailingLabel)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(Color.white.opacity(0.82))
                    .shadow(color: Color.black.opacity(0.55), radius: 4, x: 0, y: 1)
                    .padding(.horizontal, 14)
                }
                .frame(height: trackHeight)
                .clipShape(trackShape)
                .overlay {
                    trackShape.stroke(Color.white.opacity(0.07), lineWidth: 1)
                }
                .contentShape(trackShape)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { g in
                            value = max(0, min(1, Double(g.location.x / w)))
                        }
                )
            }
            .frame(height: trackHeight)
        }
    }
}

private enum VoiceDesignScrollAnchorKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    VoiceDesignView()
}
