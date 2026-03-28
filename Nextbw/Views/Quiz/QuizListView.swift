import SwiftUI

struct QuizListView: View {
    @EnvironmentObject var engine: GameEngine
    @State private var selectedCategory: QuizCategory? = nil
    @State private var selectedQuiz: Quiz? = nil

    var filteredQuizzes: [Quiz] {
        if let category = selectedCategory {
            return SampleData.quizzes.filter { $0.category == category }
        }
        return SampleData.quizzes
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Category filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            Button {
                                withAnimation { selectedCategory = nil }
                            } label: {
                                Text("Tous")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(selectedCategory == nil ? .blue : .blue.opacity(0.15))
                                    .foregroundStyle(selectedCategory == nil ? .white : .blue)
                                    .clipShape(Capsule())
                            }

                            ForEach(QuizCategory.allCases, id: \.self) { category in
                                Button {
                                    withAnimation {
                                        selectedCategory = selectedCategory == category ? nil : category
                                    }
                                } label: {
                                    CategoryChip(category: category, isSelected: selectedCategory == category)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Quiz cards
                    LazyVStack(spacing: 12) {
                        ForEach(filteredQuizzes) { quiz in
                            QuizCard(quiz: quiz, isCompleted: engine.currentUser.completedQuizzes.contains(quiz.id))
                                .onTapGesture {
                                    selectedQuiz = quiz
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Quiz")
            .fullScreenCover(item: $selectedQuiz) { quiz in
                QuizPlayView(quiz: quiz)
                    .environmentObject(engine)
            }
        }
    }
}

// MARK: - Quiz Card

struct QuizCard: View {
    let quiz: Quiz
    let isCompleted: Bool

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(quiz.category.color.gradient)
                    .frame(width: 56, height: 56)

                Image(systemName: quiz.icon)
                    .font(.title2)
                    .foregroundStyle(.white)
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(quiz.title)
                        .font(.headline)
                    if isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.caption)
                    }
                }

                Text(quiz.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                HStack(spacing: 12) {
                    DifficultyStars(difficulty: quiz.difficulty)

                    Label("\(quiz.estimatedMinutes) min", systemImage: "clock")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    Label("+\(quiz.xpReward) XP", systemImage: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

#Preview {
    QuizListView()
        .environmentObject(GameEngine.shared)
}
