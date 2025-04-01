import SwiftUI

extension UserDefaults {
    func setCodable<T: Codable>(_ value: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func getCodable<T: Codable>(forKey key: String) -> T? {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode(T.self, from: data) {
            return decoded
        }
        return nil
    }
}

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var rotation: Double
    var color: Color
}

struct CircularProgressView: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        Circle()
            .trim(from: 0, to: progress)
            .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
            .foregroundColor(color)
            .rotationEffect(.degrees(-90))
            .animation(.easeInOut(duration: 1.0), value: progress)
    }
}

struct QuizResultView: View {
    @Binding var currentView: String
    let score: Int
    let totalQuestions: Int = 4
    let didPass: Bool
    @AppStorage("unlockedQuizzes") private var unlockedQuizzes: Int = 1
    @State private var bestScores: [String: Int] = [:]
    
    @State private var confetti: [ConfettiPiece] = []
    @State private var showingAnimation = false
    @State private var rotationAmount: Double = 0
    
    // Get the current quiz title
    private var quizId: String {
        UserDefaults.standard.string(forKey: "currentQuiz") ?? "Introduction to Budgeting"
    }
    
    // Ensure score doesn't exceed 4
    private var cappedScore: Int {
        min(score, 4)
    }
    
    // Get the previous best score for this specific quiz
    private var previousBestScore: Int {
        if let scores: [String: Int] = UserDefaults.standard.getCodable(forKey: "quizBestScores") {
            return min(scores[quizId] ?? 0, 4)  // Cap at 4
        }
        return 0
    }
    
    var scorePercentage: Double {
        Double(score) / Double(totalQuestions)
    }
    
    var isNewBestScore: Bool {
        return score > previousBestScore
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
            
            // Confetti
            ForEach(confetti) { piece in
                Circle()
                    .fill(piece.color)
                    .frame(width: 8, height: 8)
                    .position(x: piece.x, y: piece.y)
                    .rotationEffect(.degrees(piece.rotation))
            }
            
            VStack(spacing: 32) {
                // Result Icon with circular progress
                ZStack {
                    if didPass {
                        Circle()
                            .fill(Color.cyan.opacity(0.1))
                            .frame(width: 140, height: 140)
                        
                        CircularProgressView(
                            progress: scorePercentage,
                            color: scorePercentage == 1.0 ? .yellow : .cyan
                        )
                        .frame(width: 120, height: 120)
                        
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 40))
                            .foregroundColor(scorePercentage == 1.0 ? .yellow : .cyan)
                            .rotationEffect(.degrees(rotationAmount))
                    } else {
                        // Existing failure state
                        Circle()
                            .fill(Color.red.opacity(0.1))
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .fill(Color.red.opacity(0.2))
                            .frame(width: 90, height: 90)
                        
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                    }
                }
                .padding(.top, 40)
                
                // Result Text
                VStack(spacing: 16) {
                    Text(didPass ? "Congratulations!" : "Keep Learning!")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(didPass ? "You've mastered this topic!" : "You need a score of 3/4 to pass")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                // Score Display
                VStack(spacing: 16) {
                    // Current Score
                    VStack(spacing: 8) {
                        Text("Current Score")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        
                        Text("\(cappedScore)/4")
                            .font(.system(size: 48, weight: .bold))
                .foregroundColor(didPass ? .cyan : .red)
                    }
                    
                    // Only show best score if it's higher than current score
                    if previousBestScore > cappedScore {
                        VStack(spacing: 8) {
                            Text("Best Score")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Text("\(previousBestScore)/4")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(red: 0.15, green: 0.15, blue: 0.2))
                        .shadow(color: (didPass ? Color.cyan : Color.red).opacity(0.1), radius: 10, x: 0, y: 4)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke((didPass ? Color.cyan : Color.red).opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal)
                
                // Performance Message
                Text(getPerformanceMessage())
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

            Spacer()
            
                // Action Buttons
                VStack(spacing: 16) {
                    Button(action: { currentView = "Quiz" }) {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("Back to Quizzes")
                        }
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.cyan)
                        )
                    }
                    
                    if !didPass {
                        Button(action: { currentView = "QuizQuestionView" }) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Try Again")
                            }
                            .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.red.opacity(0.2))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            // Load existing scores
            if let scores: [String: Int] = UserDefaults.standard.getCodable(forKey: "quizBestScores") {
                var updatedScores = scores
                // Only update if current score is better than previous best (and cap at 4)
                if cappedScore > (scores[quizId] ?? 0) {
                    updatedScores[quizId] = cappedScore
                    UserDefaults.standard.setCodable(updatedScores, forKey: "quizBestScores")
                }
            } else {
                // First score for this quiz
                let newScores = [quizId: cappedScore]
                UserDefaults.standard.setCodable(newScores, forKey: "quizBestScores")
            }
            
            // Debug print to check what's being saved
            print("Quiz ID:", quizId)
            print("Current Score:", cappedScore)
            print("Best Score:", previousBestScore)
            
            if didPass {
                // Start animations
                withAnimation(.easeInOut(duration: 0.5)) {
                    showingAnimation = true
                }
                
                // Rotate trophy if perfect score
                if scorePercentage == 1.0 {
                    withAnimation(
                        .easeInOut(duration: 0.5)
                        .repeatCount(3, autoreverses: true)
                    ) {
                        rotationAmount = 360
                    }
                }
                
                // Create confetti
                createConfetti()
            }
        }
    }
    
    private func getPerformanceMessage() -> String {
        if didPass {
            return "Great job! You've demonstrated a solid understanding of budgeting fundamentals. Keep up the excellent work!"
        } else {
            return "Don't worry! Learning takes time. Review the material and try again when you're ready."
        }
    }
    
    private func createConfetti() {
        let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange]
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        for _ in 0..<100 {
            let piece = ConfettiPiece(
                x: .random(in: 0...width),
                y: -20,
                rotation: .random(in: 0...360),
                color: colors.randomElement()!
            )
            confetti.append(piece)
            
            // Animate each piece
            withAnimation(
                .easeOut(duration: .random(in: 1...3))
                .delay(.random(in: 0...1))
            ) {
                let index = confetti.count - 1
                confetti[index].y = height + 20
                confetti[index].rotation += .random(in: 180...720)
            }
        }
        
        // Remove confetti after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            confetti.removeAll()
        }
    }
}

struct QuizResultView_Previews: PreviewProvider {
    static var previews: some View {
        QuizResultView(
            currentView: .constant("Quiz"),
            score: 3,
            didPass: true
        )
    }
}
