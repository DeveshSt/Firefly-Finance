import SwiftUI

enum Language: String {
    case english = "en"
    case spanish = "es"
}

class LanguageManager: ObservableObject {
    @Published var currentLanguage: Language = .english
    
    static let shared = LanguageManager()
    
    func getString(_ key: LocalizedStringKey) -> String {
        switch currentLanguage {
        case .english:
            return englishStrings[key] ?? String(describing: key)
        case .spanish:
            return spanishStrings[key] ?? String(describing: key)
        }
    }
}

// All app strings
enum LocalizedStringKey: String {
    // Home View
    case portfolio = "portfolio"
    case totalBalance = "totalBalance"
    case assetDistribution = "assetDistribution"
    case stocks = "stocks"
    case bonds = "bonds"
    case cash = "cash"
    case crypto = "crypto"
    case recentTransactions = "recentTransactions"
    
    // Quiz Related
    case introToBudgeting = "introToBudgeting"
    case introToFinancialMath = "introToFinancialMath"
    case introToInvesting = "introToInvesting"
    case introToBusinessCommunication = "introToBusinessCommunication"
    case introToCreditPrinciples = "introToCreditPrinciples"
    // Add all other quiz titles and questions...
    
    // Chatbot
    case chatbotWelcome = "chatbotWelcome"
    case typeMessage = "typeMessage"
    case send = "send"
    
    // Settings
    case language = "language"
    // Add all other strings used in the app...
}

let englishStrings: [LocalizedStringKey: String] = [
    .portfolio: "Portfolio",
    .totalBalance: "Total Balance",
    .assetDistribution: "Asset Distribution",
    .stocks: "Stocks",
    .bonds: "Bonds",
    .cash: "Cash",
    .crypto: "Crypto",
    .recentTransactions: "Recent Transactions",
    .introToBudgeting: "Introduction to Budgeting",
    .introToFinancialMath: "Introduction to Financial Math",
    .introToInvesting: "Introduction to Investing",
    .introToBusinessCommunication: "Introduction to Business Communication",
    .introToCreditPrinciples: "Introduction to Credit Principles",
    .chatbotWelcome: "Hello! How can I help you today?",
    .typeMessage: "Type a message...",
    .send: "Send",
    .language: "Language"
    // Add all English strings...
]

let spanishStrings: [LocalizedStringKey: String] = [
    .portfolio: "Portafolio",
    .totalBalance: "Balance Total",
    .assetDistribution: "Distribución de Activos",
    .stocks: "Acciones",
    .bonds: "Bonos",
    .cash: "Efectivo",
    .crypto: "Cripto",
    .recentTransactions: "Transacciones Recientes",
    .introToBudgeting: "Introducción al Presupuesto",
    .introToFinancialMath: "Introducción a las Matemáticas Financieras",
    .introToInvesting: "Introducción a la Inversión",
    .introToBusinessCommunication: "Introducción a la Comunicación Empresarial",
    .introToCreditPrinciples: "Introducción a los Principios de Crédito",
    .chatbotWelcome: "¡Hola! ¿Cómo puedo ayudarte hoy?",
    .typeMessage: "Escribe un mensaje...",
    .send: "Enviar",
    .language: "Idioma"
    // Add all Spanish strings...
] 