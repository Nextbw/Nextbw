import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var engine: GameEngine
    @State private var showLeaderboard = false
    @State private var dailyChallenges = SampleData.dailyChallenges

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome header
                    welcomeHeader

                    // XP & Level
                    levelCard

                    // Daily Challenges
                    dailyChallengesSection

                    // Weekly Activity
                    weeklyActivityCard

                    // Quick Actions
                    quickActionsGrid

                    // Leaderboard preview
                    leaderboardPreview
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationTitle("Accueil")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    StreakBadge(streak: engine.currentUser.streak, multiplier: engine.streakMultiplier)
                }
            }
            .sheet(isPresented: $showLeaderboard) {
                LeaderboardView()
                    .environmentObject(engine)
            }
            .onAppear {
                engine.updateStreak()
            }
        }
    }

    // MARK: - Welcome Header

    var welcomeHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(greeting)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(engine.currentUser.name)
                    .font(.title)
                    .fontWeight(.bold)
            }

            Spacer()

            // Rank badge
            VStack(spacing: 2) {
                Text(engine.currentRank.icon)
                    .font(.system(size: 36))
                Text(engine.currentRank.rawValue)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(engine.currentRank.color)
            }
            .padding(12)
            .background(engine.currentRank.color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.top, 8)
    }

    // MARK: - Level Card

    var levelCard: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Niveau \(engine.currentUser.level)")
                        .font(.title2)
                        .fontWeight(.black)
                    Text("\(engine.currentUser.xp) XP total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("+\(engine.todayXP) XP")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                    Text("aujourd'hui")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            XPProgressBar(
                progress: engine.xpProgress,
                level: engine.currentUser.level,
                currentXP: engine.currentUser.xp,
                nextLevelXP: engine.xpForNextLevel
            )
        }
        .padding()
        .background(
            LinearGradient(
                colors: [.blue.opacity(0.08), .purple.opacity(0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.blue.opacity(0.2), lineWidth: 1)
        )
    }

    // MARK: - Daily Challenges

    var dailyChallengesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Defis du jour")
                    .font(.headline)
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)

                Spacer()

                Text("\(dailyChallenges.filter(\.isCompleted).count)/\(dailyChallenges.count)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }

            ForEach(dailyChallenges) { challenge in
                HStack(spacing: 12) {
                    Image(systemName: challenge.icon)
                        .font(.title3)
                        .foregroundStyle(challenge.isCompleted ? .green : challenge.color)
                        .frame(width: 36)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(challenge.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .strikethrough(challenge.isCompleted)
                        Text(challenge.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    if challenge.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Text("+\(challenge.xpReward) XP")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                    }
                }
                .padding(12)
                .background(challenge.isCompleted ? .green.opacity(0.05) : .clear)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }

    // MARK: - Weekly Activity

    var weeklyActivityCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Activite de la semaine")
                .font(.headline)

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<7) { index in
                    VStack(spacing: 4) {
                        // Bar
                        let xp = engine.currentUser.weeklyXP[index]
                        let maxXP = max(engine.currentUser.weeklyXP.max() ?? 1, 1)
                        let height = max(CGFloat(xp) / CGFloat(maxXP) * 60, 4)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(index == dayOfWeek ? Color.blue.gradient : Color.blue.opacity(0.3).gradient)
                            .frame(height: height)
                            .animation(.spring, value: xp)

                        // Day label
                        Text(dayLabel(index))
                            .font(.caption2)
                            .foregroundStyle(index == dayOfWeek ? .primary : .secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 80)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }

    // MARK: - Quick Actions

    var quickActionsGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Formation rapide")
                .font(.headline)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                QuickActionCard(
                    title: "Quiz aleatoire",
                    icon: "dice.fill",
                    color: .blue,
                    subtitle: "5 min"
                )

                QuickActionCard(
                    title: "Speed Quiz",
                    icon: "bolt.fill",
                    color: .orange,
                    subtitle: "60 sec"
                )

                QuickActionCard(
                    title: "Video du jour",
                    icon: "play.circle.fill",
                    color: .red,
                    subtitle: "10 min"
                )

                QuickActionCard(
                    title: "Memory",
                    icon: "brain.head.profile",
                    color: .teal,
                    subtitle: "5 min"
                )
            }
        }
    }

    // MARK: - Leaderboard Preview

    var leaderboardPreview: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Classement")
                    .font(.headline)
                Image(systemName: "trophy.fill")
                    .foregroundStyle(.yellow)

                Spacer()

                Button("Voir tout") {
                    showLeaderboard = true
                }
                .font(.caption)
                .foregroundStyle(.blue)
            }

            ForEach(Array(SampleData.leaderboard.prefix(3).enumerated()), id: \.element.id) { index, entry in
                HStack(spacing: 12) {
                    // Position
                    Text(positionEmoji(index))
                        .font(.title2)

                    Text(entry.avatarEmoji)
                        .font(.title2)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("Niv. \(entry.level) - \(entry.rank.rawValue)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text("\(entry.xp) XP")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }

    // MARK: - Helpers

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Bonjour" }
        if hour < 18 { return "Bon apres-midi" }
        return "Bonsoir"
    }

    var dayOfWeek: Int {
        Calendar.current.component(.weekday, from: Date()) - 1
    }

    func dayLabel(_ index: Int) -> String {
        ["D", "L", "M", "M", "J", "V", "S"][index]
    }

    func positionEmoji(_ index: Int) -> String {
        ["🥇", "🥈", "🥉"][index]
    }
}

// MARK: - Quick Action Card

struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    let subtitle: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            Text(subtitle)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    DashboardView()
        .environmentObject(GameEngine.shared)
}
