import SwiftUI

// MARK: - Gamification Engine

class GameEngine: ObservableObject {
    static let shared = GameEngine()

    @Published var currentUser: UserProfile
    @Published var dailyStreak: Int = 0
    @Published var todayXP: Int = 0
    @Published var showLevelUp: Bool = false
    @Published var newBadge: Badge? = nil

    private let calendar = Calendar.current

    init() {
        self.currentUser = UserProfile(
            id: UUID(),
            name: "Pharmacien",
            role: .pharmacien,
            avatarEmoji: "💊",
            xp: 0,
            level: 1,
            streak: 0,
            lastActiveDate: Date(),
            completedQuizzes: [],
            completedVideos: [],
            badges: [],
            weeklyXP: [0, 0, 0, 0, 0, 0, 0]
        )
    }

    // MARK: - XP & Leveling

    var xpForCurrentLevel: Int {
        xpRequired(for: currentUser.level)
    }

    var xpForNextLevel: Int {
        xpRequired(for: currentUser.level + 1)
    }

    var xpProgress: Double {
        let currentLevelXP = xpForCurrentLevel
        let nextLevelXP = xpForNextLevel
        let progress = Double(currentUser.xp - currentLevelXP) / Double(nextLevelXP - currentLevelXP)
        return min(max(progress, 0), 1)
    }

    func xpRequired(for level: Int) -> Int {
        // Exponential curve: each level needs more XP
        Int(100 * pow(1.5, Double(level - 1)))
    }

    func awardXP(_ amount: Int, reason: String) {
        let multiplier = streakMultiplier
        let totalXP = Int(Double(amount) * multiplier)
        currentUser.xp += totalXP
        todayXP += totalXP

        // Update weekly XP
        let weekday = calendar.component(.weekday, from: Date()) - 1
        if weekday >= 0 && weekday < 7 {
            currentUser.weeklyXP[weekday] += totalXP
        }

        // Check level up
        while currentUser.xp >= xpForNextLevel {
            currentUser.level += 1
            showLevelUp = true
            checkBadges()
        }

        checkBadges()
    }

    // MARK: - Streaks

    var streakMultiplier: Double {
        switch currentUser.streak {
        case 0...2: return 1.0
        case 3...6: return 1.25
        case 7...13: return 1.5
        case 14...29: return 1.75
        default: return 2.0
        }
    }

    func updateStreak() {
        let today = calendar.startOfDay(for: Date())
        let lastActive = calendar.startOfDay(for: currentUser.lastActiveDate)
        let daysDifference = calendar.dateComponents([.day], from: lastActive, to: today).day ?? 0

        if daysDifference == 1 {
            currentUser.streak += 1
        } else if daysDifference > 1 {
            currentUser.streak = 1
        }
        // daysDifference == 0: same day, keep streak
        currentUser.lastActiveDate = Date()
        dailyStreak = currentUser.streak
    }

    // MARK: - Badges

    func checkBadges() {
        let allBadges = Badge.allBadges
        for badge in allBadges {
            if !currentUser.badges.contains(where: { $0.id == badge.id }) {
                if badge.isUnlocked(by: currentUser) {
                    currentUser.badges.append(badge)
                    newBadge = badge
                }
            }
        }
    }

    // MARK: - Quiz Completion

    func completeQuiz(_ quizId: UUID, score: Int, totalQuestions: Int) {
        let percentage = Double(score) / Double(totalQuestions)
        let baseXP: Int
        switch percentage {
        case 0.9...1.0: baseXP = 100
        case 0.7..<0.9: baseXP = 70
        case 0.5..<0.7: baseXP = 40
        default: baseXP = 20
        }
        awardXP(baseXP, reason: "Quiz termine")

        if !currentUser.completedQuizzes.contains(quizId) {
            currentUser.completedQuizzes.append(quizId)
            awardXP(50, reason: "Nouveau quiz complete")
        }
    }

    // MARK: - Video Completion

    func completeVideo(_ videoId: UUID) {
        if !currentUser.completedVideos.contains(videoId) {
            currentUser.completedVideos.append(videoId)
            awardXP(30, reason: "Video regardee")
        }
    }

    // MARK: - Rank

    var currentRank: Rank {
        switch currentUser.level {
        case 1...3: return .stagiaire
        case 4...7: return .preparateur
        case 8...12: return .adjoint
        case 13...18: return .titulaire
        case 19...25: return .expert
        default: return .maitre
        }
    }
}

// MARK: - Rank Enum

enum Rank: String, CaseIterable {
    case stagiaire = "Stagiaire"
    case preparateur = "Preparateur"
    case adjoint = "Adjoint"
    case titulaire = "Titulaire"
    case expert = "Expert"
    case maitre = "Maitre Pharmacien"

    var icon: String {
        switch self {
        case .stagiaire: return "🌱"
        case .preparateur: return "⚗️"
        case .adjoint: return "💊"
        case .titulaire: return "🏥"
        case .expert: return "⭐"
        case .maitre: return "👑"
        }
    }

    var color: Color {
        switch self {
        case .stagiaire: return .green
        case .preparateur: return .blue
        case .adjoint: return .purple
        case .titulaire: return .orange
        case .expert: return .red
        case .maitre: return .yellow
        }
    }

    var minLevel: Int {
        switch self {
        case .stagiaire: return 1
        case .preparateur: return 4
        case .adjoint: return 8
        case .titulaire: return 13
        case .expert: return 19
        case .maitre: return 26
        }
    }
}
