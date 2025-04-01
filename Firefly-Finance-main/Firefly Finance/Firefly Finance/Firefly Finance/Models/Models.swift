// Add to your existing Models.swift file

// Add this to your existing enums
enum AchievementType: String, Codable {
    case investment
    case savings
    case quiz
    case portfolio
}

// Add this struct to your existing models
struct Achievement: Identifiable, Codable {
    let id: UUID = UUID()
    let type: AchievementType
    let title: String
    let description: String
    var isUnlocked: Bool
    let dateUnlocked: Date?
}

// Update your UserAccount struct
struct UserAccount: Codable {
    // ... existing properties ...
    var achievements: [Achievement] = [
        Achievement(
            type: .investment,
            title: "First Investment",
            description: "Make your first stock purchase",
            isUnlocked: false,
            dateUnlocked: nil
        ),
        Achievement(
            type: .investment,
            title: "Dividend Collector",
            description: "Own shares in all dividend-paying stocks",
            isUnlocked: false,
            dateUnlocked: nil
        ),
        Achievement(
            type: .savings,
            title: "Savings Master",
            description: "Accumulate $5,000 in your savings account",
            isUnlocked: false,
            dateUnlocked: nil
        ),
        Achievement(
            type: .quiz,
            title: "Financial Scholar",
            description: "Complete all quizzes with perfect scores",
            isUnlocked: false,
            dateUnlocked: nil
        ),
        Achievement(
            type: .portfolio,
            title: "Diversification Pro",
            description: "Own shares in all available stocks",
            isUnlocked: false,
            dateUnlocked: nil
        )
    ]
    
    // Add this method to your UserAccount struct
    mutating func checkAndUpdateAchievements() {
        // Check First Investment
        if !achievements[0].isUnlocked && !investments.isEmpty {
            achievements[0].isUnlocked = true
            achievements[0].dateUnlocked = Date()
        }
        
        // Check Dividend Collector
        let dividendStocks = stocks.filter { $0.dividendYield != nil }
        let ownedDividendStocks = investments.filter { investment in
            dividendStocks.contains { $0.id == investment.stockId }
        }
        if !achievements[1].isUnlocked && ownedDividendStocks.count == dividendStocks.count {
            achievements[1].isUnlocked = true
            achievements[1].dateUnlocked = Date()
        }
        
        // Check Savings Master
        let totalSavings = savingsAccounts.reduce(0) { $0 + $1.balance }
        if !achievements[2].isUnlocked && totalSavings >= 5000 {
            achievements[2].isUnlocked = true
            achievements[2].dateUnlocked = Date()
        }
        
        // Check Diversification Pro
        let uniqueStocksOwned = Set(investments.compactMap { $0.stockId })
        if !achievements[4].isUnlocked && uniqueStocksOwned.count == stocks.count {
            achievements[4].isUnlocked = true
            achievements[4].dateUnlocked = Date()
        }
    }
} 