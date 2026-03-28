import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var engine: GameEngine
    @Environment(\.dismiss) var dismiss
    @State private var selectedPeriod = 0

    let periods = ["Semaine", "Mois", "Tout"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Period selector
                Picker("Periode", selection: $selectedPeriod) {
                    ForEach(0..<periods.count, id: \.self) { index in
                        Text(periods[index]).tag(index)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                // Top 3 podium
                podiumView
                    .padding(.bottom, 20)

                // Rest of leaderboard
                List {
                    ForEach(Array(SampleData.leaderboard.dropFirst(3).enumerated()), id: \.element.id) { index, entry in
                        leaderboardRow(entry: entry, position: index + 4)
                    }

                    // Current user
                    Section {
                        leaderboardRow(
                            entry: LeaderboardEntry(
                                id: UUID(),
                                name: engine.currentUser.name + " (vous)",
                                avatarEmoji: engine.currentUser.avatarEmoji,
                                xp: engine.currentUser.xp,
                                level: engine.currentUser.level,
                                rank: engine.currentRank,
                                streak: engine.currentUser.streak
                            ),
                            position: SampleData.leaderboard.count + 1
                        )
                    } header: {
                        Text("Votre position")
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Classement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fermer") { dismiss() }
                }
            }
        }
    }

    // MARK: - Podium

    var podiumView: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if SampleData.leaderboard.count >= 3 {
                // 2nd place
                podiumItem(entry: SampleData.leaderboard[1], position: 2, height: 70)

                // 1st place
                podiumItem(entry: SampleData.leaderboard[0], position: 1, height: 90)

                // 3rd place
                podiumItem(entry: SampleData.leaderboard[2], position: 3, height: 55)
            }
        }
        .padding(.horizontal)
    }

    func podiumItem(entry: LeaderboardEntry, position: Int, height: CGFloat) -> some View {
        VStack(spacing: 6) {
            Text(entry.avatarEmoji)
                .font(.system(size: position == 1 ? 40 : 32))

            Text(entry.name)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(1)

            Text("\(entry.xp) XP")
                .font(.caption2)
                .foregroundStyle(.orange)
                .fontWeight(.bold)

            // Podium block
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(podiumColor(position).gradient)

                Text(podiumEmoji(position))
                    .font(.title2)
            }
            .frame(height: height)
        }
        .frame(maxWidth: .infinity)
    }

    func leaderboardRow(entry: LeaderboardEntry, position: Int) -> some View {
        HStack(spacing: 12) {
            Text("#\(position)")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .frame(width: 32)

            Text(entry.avatarEmoji)
                .font(.title3)

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                HStack(spacing: 6) {
                    Text("Niv. \(entry.level)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    if entry.streak > 0 {
                        HStack(spacing: 2) {
                            Image(systemName: "flame.fill")
                                .font(.caption2)
                                .foregroundStyle(.orange)
                            Text("\(entry.streak)")
                                .font(.caption2)
                                .foregroundStyle(.orange)
                        }
                    }
                }
            }

            Spacer()

            Text("\(entry.xp) XP")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.orange)
        }
        .padding(.vertical, 4)
    }

    func podiumColor(_ position: Int) -> Color {
        switch position {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return .gray
        }
    }

    func podiumEmoji(_ position: Int) -> String {
        switch position {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return ""
        }
    }
}

#Preview {
    LeaderboardView()
        .environmentObject(GameEngine.shared)
}
