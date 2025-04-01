import SwiftUI

class QuizScoreManager {
    @AppStorage("quizBestScores") private static var bestScores: [String: Int] = [:]
    
    static func getBestScore(for quizId: String) -> Int {
        return bestScores[quizId] ?? 0
    }
    
    static func updateScore(for quizId: String, score: Int) {
        if score > (bestScores[quizId] ?? 0) {
            bestScores[quizId] = score
        }
    }
} 