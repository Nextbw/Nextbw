import SwiftUI

struct GamesHubView: View {
    @EnvironmentObject var engine: GameEngine
    @State private var showSpeedQuiz = false
    @State private var showMemoryGame = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Apprenez en jouant !")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("Gagnez des XP et montez en niveau")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top)

                    // Speed Quiz
                    GameCard(
                        title: "Speed Quiz",
                        subtitle: "60 secondes pour repondre a un max de questions",
                        icon: "bolt.fill",
                        gradient: [.orange, .red],
                        xpRange: "25 - 200 XP",
                        tag: "POPULAIRE"
                    )
                    .onTapGesture { showSpeedQuiz = true }

                    // Memory Game
                    GameCard(
                        title: "Memory Pharma",
                        subtitle: "Associez les medicaments a leurs molecules",
                        icon: "brain.head.profile",
                        gradient: [.teal, .blue],
                        xpRange: "50 - 150 XP",
                        tag: "NOUVEAU"
                    )
                    .onTapGesture { showMemoryGame = true }

                    // Coming soon games
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Bientot disponible")
                            .font(.headline)
                            .padding(.horizontal)

                        ComingSoonCard(
                            title: "Cas Clinique",
                            subtitle: "Resolvez des cas patients interactifs",
                            icon: "stethoscope",
                            color: .purple
                        )

                        ComingSoonCard(
                            title: "Ordonnance Express",
                            subtitle: "Analysez des ordonnances contre la montre",
                            icon: "doc.text.magnifyingglass",
                            color: .indigo
                        )

                        ComingSoonCard(
                            title: "Duel Pharma",
                            subtitle: "Defiez vos collegues en temps reel",
                            icon: "person.2.fill",
                            color: .red
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationTitle("Jeux")
            .fullScreenCover(isPresented: $showSpeedQuiz) {
                SpeedQuizView()
                    .environmentObject(engine)
            }
            .fullScreenCover(isPresented: $showMemoryGame) {
                MemoryGameView()
                    .environmentObject(engine)
            }
        }
    }
}

// MARK: - Game Card

struct GameCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: [Color]
    let xpRange: String
    let tag: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Top colored section
            ZStack {
                LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)

                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(tag)
                            .font(.caption2)
                            .fontWeight(.black)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.white.opacity(0.3))
                            .clipShape(Capsule())

                        Text(title)
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundStyle(.white)

                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.85))
                    }

                    Spacer()

                    Image(systemName: icon)
                        .font(.system(size: 50))
                        .foregroundStyle(.white.opacity(0.3))
                }
                .padding(20)
            }
            .frame(height: 140)

            // Bottom info
            HStack {
                Label(xpRange, systemImage: "star.fill")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.orange)

                Spacer()

                HStack(spacing: 4) {
                    Text("Jouer")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Image(systemName: "play.fill")
                        .font(.caption)
                }
                .foregroundStyle(gradient[0])
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: gradient[0].opacity(0.3), radius: 10, y: 5)
    }
}

// MARK: - Coming Soon

struct ComingSoonCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("Bientot")
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.gray.opacity(0.15))
                .clipShape(Capsule())
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 3)
    }
}

#Preview {
    GamesHubView()
        .environmentObject(GameEngine.shared)
}
