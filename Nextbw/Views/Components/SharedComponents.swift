import SwiftUI

// MARK: - XP Progress Bar

struct XPProgressBar: View {
    let progress: Double
    let level: Int
    let currentXP: Int
    let nextLevelXP: Int

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Niveau \(level)")
                    .font(.caption)
                    .fontWeight(.bold)
                Spacer()
                Text("\(currentXP) / \(nextLevelXP) XP")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.gray.opacity(0.2))

                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * progress)
                        .animation(.spring(response: 0.6), value: progress)
                }
            }
            .frame(height: 10)
        }
    }
}

// MARK: - Streak Badge

struct StreakBadge: View {
    let streak: Int
    let multiplier: Double

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill")
                .foregroundStyle(streak >= 7 ? .red : .orange)
            Text("\(streak)")
                .fontWeight(.bold)
            if multiplier > 1.0 {
                Text("x\(String(format: "%.2g", multiplier))")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.orange.opacity(0.2))
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }
}

// MARK: - Difficulty Stars

struct DifficultyStars: View {
    let difficulty: Difficulty

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<4) { index in
                Image(systemName: index < difficulty.stars ? "star.fill" : "star")
                    .font(.caption2)
                    .foregroundStyle(index < difficulty.stars ? difficulty.color : .gray.opacity(0.3))
            }
        }
    }
}

// MARK: - Category Chip

struct CategoryChip: View {
    let category: QuizCategory
    var isSelected: Bool = false

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: category.icon)
                .font(.caption2)
            Text(category.rawValue)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(isSelected ? category.color : category.color.opacity(0.15))
        .foregroundStyle(isSelected ? .white : category.color)
        .clipShape(Capsule())
    }
}

// MARK: - Animated Counter

struct AnimatedCounter: View {
    let value: Int
    let font: Font
    let color: Color

    @State private var displayedValue: Int = 0

    var body: some View {
        Text("\(displayedValue)")
            .font(font)
            .fontWeight(.bold)
            .foregroundStyle(color)
            .contentTransition(.numericText())
            .onChange(of: value) { _, newValue in
                withAnimation(.spring(response: 0.5)) {
                    displayedValue = newValue
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.5)) {
                    displayedValue = value
                }
            }
    }
}

// MARK: - Level Up Overlay

struct LevelUpOverlay: View {
    let level: Int
    let rank: Rank
    @Binding var isShowing: Bool

    @State private var scale: CGFloat = 0.3
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }

            VStack(spacing: 20) {
                Text("🎉")
                    .font(.system(size: 60))

                Text("NIVEAU \(level)")
                    .font(.system(size: 40, weight: .black))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Text(rank.icon + " " + rank.rawValue)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)

                Text("Continuez comme ca !")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))

                Button {
                    dismiss()
                } label: {
                    Text("Genial !")
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 40)
            }
            .padding(30)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(40)
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                scale = 1
                opacity = 1
            }
        }
    }

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.2)) {
            scale = 0.3
            opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isShowing = false
        }
    }
}

// MARK: - Badge Unlock Overlay

struct BadgeUnlockOverlay: View {
    let badge: Badge
    @Binding var isShowing: Bool

    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { isShowing = false }

            VStack(spacing: 16) {
                Text("Nouveau badge !")
                    .font(.headline)
                    .foregroundStyle(.white)

                ZStack {
                    Circle()
                        .fill(badge.color.gradient)
                        .frame(width: 100, height: 100)
                        .shadow(color: badge.color.opacity(0.5), radius: 20)

                    Image(systemName: badge.icon)
                        .font(.system(size: 44))
                        .foregroundStyle(.white)
                        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
                }

                Text(badge.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text(badge.description)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))

                Button("Super !") {
                    isShowing = false
                }
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(badge.color.gradient)
                .clipShape(Capsule())
            }
            .padding(30)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(40)
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}
