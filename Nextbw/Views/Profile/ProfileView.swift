import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var engine: GameEngine
    @State private var showBadgeDetail: Badge? = nil

    var unlockedBadges: [Badge] {
        engine.currentUser.badges
    }

    var lockedBadges: [Badge] {
        Badge.allBadges.filter { badge in
            !engine.currentUser.badges.contains(where: { $0.id == badge.id })
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile card
                    profileCard

                    // Stats
                    statsGrid

                    // Rank progression
                    rankProgression

                    // Badges
                    badgesSection

                    // Settings
                    settingsSection
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationTitle("Profil")
        }
    }

    // MARK: - Profile Card

    var profileCard: some View {
        VStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [engine.currentRank.color, engine.currentRank.color.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 90, height: 90)

                Text(engine.currentUser.avatarEmoji)
                    .font(.system(size: 44))
            }

            VStack(spacing: 4) {
                Text(engine.currentUser.name)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(engine.currentUser.role.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack {
                    Text(engine.currentRank.icon)
                    Text(engine.currentRank.rawValue)
                        .fontWeight(.semibold)
                        .foregroundStyle(engine.currentRank.color)
                }
                .font(.subheadline)
            }

            // XP bar
            XPProgressBar(
                progress: engine.xpProgress,
                level: engine.currentUser.level,
                currentXP: engine.currentUser.xp,
                nextLevelXP: engine.xpForNextLevel
            )
            .padding(.horizontal)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    // MARK: - Stats Grid

    var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatCard(title: "Quiz", value: "\(engine.currentUser.completedQuizzes.count)", icon: "checkmark.circle.fill", color: .blue)
            StatCard(title: "Videos", value: "\(engine.currentUser.completedVideos.count)", icon: "play.circle.fill", color: .red)
            StatCard(title: "Serie", value: "\(engine.currentUser.streak)j", icon: "flame.fill", color: .orange)
            StatCard(title: "XP Total", value: "\(engine.currentUser.xp)", icon: "star.fill", color: .yellow)
            StatCard(title: "Badges", value: "\(unlockedBadges.count)", icon: "shield.fill", color: .purple)
            StatCard(title: "Niveau", value: "\(engine.currentUser.level)", icon: "arrow.up.circle.fill", color: .green)
        }
    }

    // MARK: - Rank Progression

    var rankProgression: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Progression des rangs")
                .font(.headline)

            ForEach(Rank.allCases, id: \.self) { rank in
                HStack(spacing: 12) {
                    Text(rank.icon)
                        .font(.title2)
                        .frame(width: 36)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(rank.rawValue)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(isRankUnlocked(rank) ? .primary : .secondary)

                        Text("Niveau \(rank.minLevel)+")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    if rank == engine.currentRank {
                        Text("ACTUEL")
                            .font(.caption2)
                            .fontWeight(.black)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(rank.color)
                            .clipShape(Capsule())
                    } else if isRankUnlocked(rank) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(.gray)
                    }
                }
                .padding(10)
                .background(rank == engine.currentRank ? rank.color.opacity(0.1) : .clear)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }

    // MARK: - Badges

    var badgesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Badges")
                    .font(.headline)
                Spacer()
                Text("\(unlockedBadges.count)/\(Badge.allBadges.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // Unlocked
            if !unlockedBadges.isEmpty {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(unlockedBadges, id: \.id) { badge in
                        BadgeIcon(badge: badge, isLocked: false)
                    }
                }
            }

            // Locked
            if !lockedBadges.isEmpty {
                Text("A debloquer")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(lockedBadges, id: \.id) { badge in
                        BadgeIcon(badge: badge, isLocked: true)
                    }
                }
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }

    // MARK: - Settings

    var settingsSection: some View {
        VStack(spacing: 0) {
            settingRow(icon: "bell.fill", title: "Notifications", color: .red)
            Divider().padding(.leading, 52)
            settingRow(icon: "moon.fill", title: "Mode sombre", color: .indigo)
            Divider().padding(.leading, 52)
            settingRow(icon: "globe", title: "Langue", color: .blue)
            Divider().padding(.leading, 52)
            settingRow(icon: "questionmark.circle.fill", title: "Aide", color: .green)
            Divider().padding(.leading, 52)
            settingRow(icon: "info.circle.fill", title: "A propos", color: .gray)
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }

    func settingRow(icon: String, title: String, color: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 28)
            Text(title)
                .font(.subheadline)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    func isRankUnlocked(_ rank: Rank) -> Bool {
        engine.currentUser.level >= rank.minLevel
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(color)

            Text(value)
                .font(.headline)
                .fontWeight(.bold)

            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Badge Icon

struct BadgeIcon: View {
    let badge: Badge
    let isLocked: Bool

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(isLocked ? .gray.opacity(0.2) : badge.color.gradient)
                    .frame(width: 50, height: 50)

                if isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.gray)
                } else {
                    Image(systemName: badge.icon)
                        .foregroundStyle(.white)
                }
            }

            Text(badge.name)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundStyle(isLocked ? .secondary : .primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileView()
        .environmentObject(GameEngine.shared)
}
