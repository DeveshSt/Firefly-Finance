import SwiftUI

struct QuizView: View {
    @Binding var currentView: String
    @AppStorage("unlockedQuizzes") private var unlockedQuizzes: Int = 1
    @State private var bestScores: [String: Int] = [:]
    
    private let quizCategories = [
        QuizCategory(title: "Beginner", color: .cyan, quizzes: [
            QuizItem(title: "Introduction to Budgeting", isImplemented: true, bestScore: nil),
            QuizItem(title: "Introduction to Financial Math", isImplemented: true, bestScore: nil),
            QuizItem(title: "Introduction to Investing", isImplemented: true, bestScore: nil),
            QuizItem(title: "Introduction to Business Communication", isImplemented: true, bestScore: nil),
            QuizItem(title: "Introduction to Credit Principles", isImplemented: true, bestScore: nil)
        ]),
        QuizCategory(title: "Intermediate", color: .orange, quizzes: [
            QuizItem(title: "Intermediate Budgeting", isImplemented: true, bestScore: nil),
            QuizItem(title: "Intermediate Financial Math", isImplemented: true, bestScore: nil),
            QuizItem(title: "Intermediate Investing", isImplemented: true, bestScore: nil),
            QuizItem(title: "Intermediate Business Communication", isImplemented: true, bestScore: nil),
            QuizItem(title: "Intermediate Credit Principles", isImplemented: true, bestScore: nil)
        ]),
        QuizCategory(title: "Advanced", color: .red, quizzes: [
            QuizItem(title: "Advanced Budgeting", isImplemented: true, bestScore: nil),
            QuizItem(title: "Advanced Financial Math", isImplemented: true, bestScore: nil),
            QuizItem(title: "Advanced Investing", isImplemented: true, bestScore: nil),
            QuizItem(title: "Advanced Business Communication", isImplemented: true, bestScore: nil),
            QuizItem(title: "Advanced Credit Principles", isImplemented: true, bestScore: nil)
        ])
    ]

    private var totalScore: Int {
        bestScores.values.reduce(0, +)
    }
    
    private var maxPossibleScore: Int {
        // Count only implemented quizzes * 4 points per quiz
        quizCategories.flatMap { $0.quizzes }.filter { $0.isImplemented }.count * 4
    }

    var body: some View {
        ZStack {
            // Background gradient with stars
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.15),
                    Color(red: 0.15, green: 0.15, blue: 0.2)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // Star effect
            GeometryReader { geometry in
                ForEach(0..<100, id: \.self) { _ in
                    Circle()
                        .fill(Color.white)
                        .frame(width: .random(in: 1.5...3), height: .random(in: 1.5...3))
                        .position(
                            x: .random(in: 0...geometry.size.width),
                            y: .random(in: 0...geometry.size.height)
                        )
                        .opacity(.random(in: 0.3...0.7))
                }
            }
            .opacity(0.7)
            
        ScrollView {
                VStack(spacing: 24) {
                    Text("Quizzes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    // Progress Overview
                    HStack(spacing: 16) {
                        ProgressCard(
                            title: "Total Score",
                            value: "\(totalScore)/\(maxPossibleScore)",
                            icon: "star.fill",
                            color: .cyan
                        )
                        
                        ProgressCard(
                            title: "Completion Rate",
                            value: "\(Int((Double(totalScore) / Double(maxPossibleScore)) * 100))%",
                            icon: "chart.line.uptrend.xyaxis",
                            color: .green
                        )
                    }
                    .padding(.horizontal)
                    
                    // Quiz Categories
                    ForEach(quizCategories.indices, id: \.self) { index in
                        QuizCategoryView(
                            category: quizCategories[index],
                            startQuiz: { currentView = "QuizQuestionView" }
                        )
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            // Load scores when view appears
            if let scores: [String: Int] = UserDefaults.standard.getCodable(forKey: "quizBestScores") {
                bestScores = scores
            }
        }
    }
}

struct QuizItem: Identifiable {
    let id = UUID()
    let title: String
    let isImplemented: Bool
    var bestScore: Int?
}

struct QuizCategory: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
    let quizzes: [QuizItem]
}

struct QuizItemView: View {
    let quiz: QuizItem
    let color: Color
    let action: () -> Void
    @State private var bestScore: Int = 0
    @State private var isUnlocked: Bool = false
    @AppStorage("quizBestScores") private var scoresData: Data = Data()
    
    private func loadScore() {
        if let scores = try? JSONDecoder().decode([String: Int].self, from: scoresData) {
            // Cap the best score at 4
            bestScore = min(scores[quiz.title] ?? 0, 4)
            
            if quiz.title.hasPrefix("Intermediate") {
                let introQuizTitle = "Introduction to" + quiz.title.dropFirst("Intermediate".count)
                let introScore = min(scores[introQuizTitle] ?? 0, 4)  // Cap intro score at 4
                isUnlocked = introScore >= 3
            } else if quiz.title.hasPrefix("Advanced") {
                let intermediateQuizTitle = "Intermediate" + quiz.title.dropFirst("Advanced".count)
                let intermediateScore = min(scores[intermediateQuizTitle] ?? 0, 4)  // Cap intermediate score at 4
                isUnlocked = intermediateScore >= 3
            } else {
                isUnlocked = true // All intro quizzes are unlocked by default
            }
        }
    }
    
    private func getScoreColor(_ score: Int) -> Color {
        switch score {
        case 4: return .green
        case 3: return .cyan
        case 0: return .gray
        default: return .red
        }
    }
    
    var body: some View {
        Button(action: (quiz.isImplemented && isUnlocked) ? action : {}) {
            HStack {
                Text(quiz.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor((quiz.isImplemented && isUnlocked) ? .white : .gray)
                
                Spacer()
                
                if quiz.isImplemented {
                    if isUnlocked {
                        HStack(spacing: 8) {
                            Text("\(bestScore)/4")  // Always show best score out of 4
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(getScoreColor(bestScore))
                            Image(systemName: "chevron.right")
                                .foregroundColor(color)
                        }
                    } else {
                        HStack(spacing: 4) {
                            Image(systemName: "lock.fill")
                            Text("Complete Intro Quiz")
                        }
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.2))
                        .foregroundColor(.orange)
                        .cornerRadius(8)
                    }
                } else {
                    Text("Coming Soon")
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.2))
                        .foregroundColor(.orange)
                        .cornerRadius(8)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.18, green: 0.18, blue: 0.24))
                    .shadow(color: color.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(quiz.isImplemented ? color.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .disabled(!quiz.isImplemented || !isUnlocked)
        .onAppear(perform: loadScore)
        .onChange(of: scoresData) { _ in
            loadScore()
        }
    }
}

struct QuizCategoryView: View {
    let category: QuizCategory
    let startQuiz: () -> Void
    @State private var bestScores: [String: Int] = [:]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(category.title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(category.quizzes) { quiz in
                    QuizItemView(
                        quiz: quiz,
                        color: category.color,
                        action: {
                            UserDefaults.standard.set(quiz.title, forKey: "currentQuiz")
                            startQuiz()
                        }
                    )
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            // Load scores when view appears
            if let scores: [String: Int] = UserDefaults.standard.getCodable(forKey: "quizBestScores") {
                bestScores = scores
            }
        }
    }
}

struct ProgressCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            }
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
                .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                        .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(currentView: .constant("Quiz"))
    }
}
