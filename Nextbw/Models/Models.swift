import SwiftUI

// MARK: - User Profile

struct UserProfile: Identifiable {
    let id: UUID
    var name: String
    var role: PharmacyRole
    var avatarEmoji: String
    var xp: Int
    var level: Int
    var streak: Int
    var lastActiveDate: Date
    var completedQuizzes: [UUID]
    var completedVideos: [UUID]
    var badges: [Badge]
    var weeklyXP: [Int] // Sun-Sat
}

enum PharmacyRole: String, CaseIterable {
    case pharmacien = "Pharmacien titulaire"
    case adjoint = "Pharmacien adjoint"
    case preparateur = "Preparateur"
    case apprenti = "Apprenti"
    case etudiant = "Etudiant en pharmacie"
}

// MARK: - Badge

struct Badge: Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let color: Color
    let isUnlocked: (UserProfile) -> Bool

    static let allBadges: [Badge] = [
        Badge(id: "first_quiz", name: "Premier Pas", description: "Terminer votre premier quiz", icon: "star.fill", color: .yellow) { $0.completedQuizzes.count >= 1 },
        Badge(id: "five_quizzes", name: "Studieux", description: "Terminer 5 quiz", icon: "book.fill", color: .blue) { $0.completedQuizzes.count >= 5 },
        Badge(id: "ten_quizzes", name: "Erudit", description: "Terminer 10 quiz", icon: "graduationcap.fill", color: .purple) { $0.completedQuizzes.count >= 10 },
        Badge(id: "first_video", name: "Spectateur", description: "Regarder votre premiere video", icon: "play.circle.fill", color: .red) { $0.completedVideos.count >= 1 },
        Badge(id: "five_videos", name: "Cinephile", description: "Regarder 5 videos", icon: "film.fill", color: .orange) { $0.completedVideos.count >= 5 },
        Badge(id: "streak_3", name: "Regulier", description: "3 jours de suite", icon: "flame.fill", color: .orange) { $0.streak >= 3 },
        Badge(id: "streak_7", name: "Enflamme", description: "7 jours de suite", icon: "flame.fill", color: .red) { $0.streak >= 7 },
        Badge(id: "streak_30", name: "Inarretable", description: "30 jours de suite", icon: "flame.circle.fill", color: .red) { $0.streak >= 30 },
        Badge(id: "level_5", name: "En progression", description: "Atteindre le niveau 5", icon: "arrow.up.circle.fill", color: .green) { $0.level >= 5 },
        Badge(id: "level_10", name: "Confirme", description: "Atteindre le niveau 10", icon: "shield.fill", color: .blue) { $0.level >= 10 },
        Badge(id: "level_20", name: "Maitre", description: "Atteindre le niveau 20", icon: "crown.fill", color: .yellow) { $0.level >= 20 },
        Badge(id: "xp_1000", name: "Millionnaire", description: "Cumuler 1000 XP", icon: "sparkles", color: .yellow) { $0.xp >= 1000 },
    ]
}

// MARK: - Quiz Models

struct Quiz: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let category: QuizCategory
    let difficulty: Difficulty
    let questions: [Question]
    let xpReward: Int
    let estimatedMinutes: Int
    let icon: String
}

enum QuizCategory: String, CaseIterable {
    case medicaments = "Medicaments"
    case conseil = "Conseil"
    case ordonnance = "Ordonnance"
    case phytotherapie = "Phytotherapie"
    case dermo = "Dermo-cosmetique"
    case legislation = "Legislation"
    case urgence = "Urgences"
    case nutrition = "Nutrition"

    var icon: String {
        switch self {
        case .medicaments: return "pills.fill"
        case .conseil: return "bubble.left.and.bubble.right.fill"
        case .ordonnance: return "doc.text.fill"
        case .phytotherapie: return "leaf.fill"
        case .dermo: return "face.smiling.inverse"
        case .legislation: return "building.columns.fill"
        case .urgence: return "cross.case.fill"
        case .nutrition: return "fork.knife"
        }
    }

    var color: Color {
        switch self {
        case .medicaments: return .blue
        case .conseil: return .green
        case .ordonnance: return .purple
        case .phytotherapie: return .mint
        case .dermo: return .pink
        case .legislation: return .orange
        case .urgence: return .red
        case .nutrition: return .teal
        }
    }
}

enum Difficulty: String, CaseIterable {
    case debutant = "Debutant"
    case intermediaire = "Intermediaire"
    case avance = "Avance"
    case expert = "Expert"

    var color: Color {
        switch self {
        case .debutant: return .green
        case .intermediaire: return .orange
        case .avance: return .red
        case .expert: return .purple
        }
    }

    var stars: Int {
        switch self {
        case .debutant: return 1
        case .intermediaire: return 2
        case .avance: return 3
        case .expert: return 4
        }
    }
}

// MARK: - Question Types

struct Question: Identifiable {
    let id: UUID
    let text: String
    let type: QuestionType
    let explanation: String
}

enum QuestionType {
    case multipleChoice(choices: [String], correctIndex: Int)
    case trueFalse(correctAnswer: Bool)
    case imageChoice(choices: [String], correctIndex: Int, imageNames: [String])
    case ordering(items: [String], correctOrder: [Int])
}

// MARK: - Video Models

struct TrainingVideo: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let category: QuizCategory
    let duration: String
    let thumbnailColor: Color
    let isNew: Bool
    let difficulty: Difficulty
}

// MARK: - Leaderboard

struct LeaderboardEntry: Identifiable {
    let id: UUID
    let name: String
    let avatarEmoji: String
    let xp: Int
    let level: Int
    let rank: Rank
    let streak: Int
}

// MARK: - Challenge

struct DailyChallenge: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let xpReward: Int
    let icon: String
    let color: Color
    var isCompleted: Bool
}
