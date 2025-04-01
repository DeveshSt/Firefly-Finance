import SwiftUI

enum AchievementTier: String, Codable {
    case bronze, silver, gold
    
    var color: Color {
        switch self {
        case .bronze: return Color(red: 0.8, green: 0.5, blue: 0.2)
        case .silver: return Color(red: 0.75, green: 0.75, blue: 0.75)
        case .gold: return Color(red: 1, green: 0.84, blue: 0)
        }
    }
    
    var emoji: String {
        switch self {
        case .bronze: return "🥉"
        case .silver: return "🥈"
        case .gold: return "🥇"
        }
    }
}

struct Achievement: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let category: AchievementCategory
    var progress: Double // 0 to 1
    var currentTier: AchievementTier?
    let tiers: [AchievementTier: Double] // tier and its requirement value
    
    enum AchievementCategory: String, Codable {
        case portfolio = "Portfolio Growth"
        case savings = "Savings Master"
        case dividends = "Dividend Collector"
        case investing = "Investment Pro"
        case quiz = "Quiz Champion"
    }
} 