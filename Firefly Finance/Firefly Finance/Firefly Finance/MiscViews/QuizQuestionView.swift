import SwiftUI

struct Question {
    let text: String
    let answers: [String]
    let correctAnswer: Int
    let explanation: String
}

private let introductionToBudgetingQuestions = [
    Question(
        text: "What is the primary purpose of a budget?",
        answers: [
            "To track and plan spending",
            "To make you feel guilty about spending",
            "To prevent all spending",
            "To impress others"
        ],
        correctAnswer: 0,
        explanation: "A budget is a financial planning tool that helps you track income and expenses, allowing you to make informed decisions about your money."
    ),
    Question(
        text: "Which of these is a fixed expense?",
        answers: [
            "Groceries",
            "Monthly rent",
            "Entertainment",
            "Shopping"
        ],
        correctAnswer: 1,
        explanation: "Fixed expenses, like rent, remain the same each month, making them easier to plan for in your budget."
    ),
    Question(
        text: "What is the 50/30/20 budgeting rule?",
        answers: [
            "Save 50%, spend 30%, invest 20%",
            "50% needs, 30% wants, 20% savings",
            "50% food, 30% rent, 20% other",
            "Spend 50%, save 30%, donate 20%"
        ],
        correctAnswer: 1,
        explanation: "The 50/30/20 rule suggests spending 50% on needs, 30% on wants, and 20% on savings and debt repayment."
    ),
    Question(
        text: "Why is emergency savings important?",
        answers: [
            "To buy luxury items",
            "To invest in stocks",
            "To handle unexpected expenses",
            "To impress friends"
        ],
        correctAnswer: 2,
        explanation: "Emergency savings provide financial security by helping you handle unexpected expenses without going into debt."
    )
]

private let introductionToFinancialMathQuestions = [
    Question(
        text: "What is compound interest?",
        answers: [
            "Interest only on the principal",
            "Interest on both principal and accumulated interest",
            "A fixed interest rate",
            "Simple interest"
        ],
        correctAnswer: 1,
        explanation: "Compound interest is interest earned on both the initial principal and previously accumulated interest, leading to exponential growth."
    ),
    Question(
        text: "If you save $100 monthly for a year with no interest, how much will you have?",
        answers: [
            "$1000",
            "$1100",
            "$1200",
            "$1500"
        ],
        correctAnswer: 2,
        explanation: "$100 saved monthly for 12 months equals $1,200 total savings (100 × 12 = 1,200)."
    ),
    Question(
        text: "What is the Rule of 72?",
        answers: [
            "A tax calculation rule",
            "A way to calculate loan payments",
            "A way to estimate investment doubling time",
            "A banking regulation"
        ],
        correctAnswer: 2,
        explanation: "The Rule of 72 helps estimate how long it will take for an investment to double by dividing 72 by the annual interest rate."
    ),
    Question(
        text: "What is APR?",
        answers: [
            "Annual Percentage Rate",
            "Approved Payment Rate",
            "Average Payment Return",
            "Annual Payment Return"
        ],
        correctAnswer: 0,
        explanation: "APR (Annual Percentage Rate) represents the yearly cost of borrowing, including fees and interest."
    )
]

private let introductionToInvestingQuestions = [
    Question(
        text: "What is diversification?",
        answers: [
            "Investing all money in one stock",
            "Spreading investments across different assets",
            "Only investing in bonds",
            "Keeping all money in savings"
        ],
        correctAnswer: 1,
        explanation: "Diversification means spreading investments across different assets to reduce risk."
    ),
    Question(
        text: "What is a dividend?",
        answers: [
            "A type of stock",
            "A company payment to shareholders",
            "A type of bond",
            "An investment loss"
        ],
        correctAnswer: 1,
        explanation: "A dividend is a payment made by a company to its shareholders, usually from profits."
    ),
    Question(
        text: "What is a stock?",
        answers: [
            "A type of loan",
            "A ownership share in a company",
            "A government bond",
            "A savings account"
        ],
        correctAnswer: 1,
        explanation: "A stock represents ownership in a company and a claim on part of its assets and earnings."
    ),
    Question(
        text: "What is an ETF?",
        answers: [
            "Electronic Trading Fund",
            "Exchange-Traded Fund",
            "Extra Tax Fee",
            "Extended Time Finance"
        ],
        correctAnswer: 1,
        explanation: "An ETF (Exchange-Traded Fund) is a type of investment fund traded on stock exchanges, much like stocks."
    )
]

private let introductionToBusinessCommunicationQuestions = [
    Question(
        text: "What is the best way to start a professional email?",
        answers: [
            "Hey!",
            "Dear Sir/Madam,",
            "Hi [Name],",
            "Yo,"
        ],
        correctAnswer: 2,
        explanation: "Using 'Hi [Name],' is professional yet personable, showing respect while maintaining a friendly tone."
    ),
    Question(
        text: "When reviewing business documents, you should:",
        answers: [
            "Skim quickly",
            "Read thoroughly and take notes",
            "Only look at headlines",
            "Ask someone else to do it"
        ],
        correctAnswer: 1,
        explanation: "Reading thoroughly and taking notes ensures comprehension and allows for effective feedback or response."
    ),
    Question(
        text: "What is active listening?",
        answers: [
            "Interrupting with questions",
            "Thinking about your response",
            "Focusing fully on the speaker",
            "Taking phone calls while listening"
        ],
        correctAnswer: 2,
        explanation: "Active listening involves giving full attention to the speaker and engaging with their message."
    ),
    Question(
        text: "How should you handle a disagreement with a colleague?",
        answers: [
            "Ignore them",
            "Discuss privately and professionally",
            "Complain to others",
            "Send an angry email"
        ],
        correctAnswer: 1,
        explanation: "Professional, private discussion allows for resolution while maintaining workplace relationships."
    )
]

private let introductionToCreditPrinciplesQuestions = [
    Question(
        text: "What is a credit score?",
        answers: [
            "Your bank balance",
            "A measure of creditworthiness",
            "Your annual income",
            "Your debt amount"
        ],
        correctAnswer: 1,
        explanation: "A credit score is a numerical measure of your creditworthiness based on your credit history."
    ),
    Question(
        text: "What is credit utilization?",
        answers: [
            "Total credit available",
            "Percentage of credit used",
            "Credit card rewards",
            "Credit limit"
        ],
        correctAnswer: 1,
        explanation: "Credit utilization is the percentage of your available credit that you're currently using."
    ),
    Question(
        text: "What happens if you miss a credit card payment?",
        answers: [
            "Nothing",
            "Lower credit score and fees",
            "Card is cancelled",
            "Interest rate decreases"
        ],
        correctAnswer: 1,
        explanation: "Missing payments can result in late fees and negative impacts on your credit score."
    ),
    Question(
        text: "What's a good practice for building credit?",
        answers: [
            "Never use credit",
            "Max out credit cards",
            "Pay bills on time",
            "Close old accounts"
        ],
        correctAnswer: 2,
        explanation: "Consistently paying bills on time is one of the best ways to build and maintain good credit."
    )
]

// Add intermediate level questions
private let intermediateBudgetingQuestions = [
    Question(
        text: "What is zero-based budgeting?",
        answers: [
            "Having zero savings",
            "Spending all income",
            "Assigning every dollar a purpose",
            "Having no budget"
        ],
        correctAnswer: 2,
        explanation: "Zero-based budgeting means assigning a purpose to every dollar of income, whether for spending, saving, or investing."
    ),
    // Add 3 more intermediate budgeting questions...
]

private let intermediateFinancialMathQuestions = [
    Question(
        text: "How do you calculate the future value of an investment with compound interest?",
        answers: [
            "Principal × (1 + rate)^time",
            "Principal + (rate × time)",
            "Principal × rate × time",
            "Principal ÷ (1 + rate)^time"
        ],
        correctAnswer: 0,
        explanation: "Future Value = Principal × (1 + interest rate)^time. This formula accounts for interest earning interest over time."
    ),
    Question(
        text: "What is the effective annual rate (EAR) used for?",
        answers: [
            "To calculate simple interest",
            "To compare investments with different compounding periods",
            "To determine loan amounts",
            "To calculate tax rates"
        ],
        correctAnswer: 1,
        explanation: "EAR helps compare investments that compound at different frequencies by converting them to an annual basis."
    ),
    Question(
        text: "If an investment doubles every 6 years, what is its approximate annual return?",
        answers: [
            "6%",
            "8%",
            "12%",
            "24%"
        ],
        correctAnswer: 2,
        explanation: "Using the Rule of 72: 72 ÷ years to double = annual return rate. 72 ÷ 6 = 12%"
    ),
    Question(
        text: "What is the present value of $1,000 received in 2 years with a 5% discount rate?",
        answers: [
            "$1,100",
            "$907.03",
            "$952.38",
            "$850.25"
        ],
        correctAnswer: 2,
        explanation: "Present Value = Future Value ÷ (1 + rate)^time. $1,000 ÷ (1.05)² = $952.38"
    )
]

private let intermediateInvestingQuestions = [
    Question(
        text: "What is the price-to-earnings (P/E) ratio used for?",
        answers: [
            "Measuring company debt",
            "Valuing company stock",
            "Calculating dividends",
            "Determining market cap"
        ],
        correctAnswer: 1,
        explanation: "P/E ratio helps investors assess if a stock is overvalued or undervalued by comparing price to earnings."
    ),
    Question(
        text: "What is market capitalization?",
        answers: [
            "Total company debt",
            "Annual revenue",
            "Total value of shares",
            "Profit margin"
        ],
        correctAnswer: 2,
        explanation: "Market capitalization is the total value of a company's outstanding shares, calculated by multiplying share price by number of shares."
    ),
    Question(
        text: "What is beta in investing?",
        answers: [
            "Company profit",
            "Measure of volatility",
            "Stock price",
            "Dividend yield"
        ],
        correctAnswer: 1,
        explanation: "Beta measures a stock's volatility compared to the overall market. A beta of 1 means it moves in line with the market."
    ),
    Question(
        text: "What is dollar-cost averaging?",
        answers: [
            "Buying at lowest price",
            "Regular investment schedule",
            "Selling at highest price",
            "One-time investment"
        ],
        correctAnswer: 1,
        explanation: "Dollar-cost averaging is investing fixed amounts at regular intervals, regardless of market conditions."
    )
]

private let intermediateBusinessCommunicationQuestions = [
    Question(
        text: "What is the STAR method in business communication?",
        answers: [
            "Simple, Terse, Accurate, Rapid",
            "Situation, Task, Action, Result",
            "Strategic, Tactical, Analytical, Responsive",
            "System, Technical, Adaptive, Reactive"
        ],
        correctAnswer: 1,
        explanation: "STAR (Situation, Task, Action, Result) is a structured method for communicating experiences and achievements effectively."
    ),
    Question(
        text: "What is the purpose of a stakeholder analysis?",
        answers: [
            "Calculate profits",
            "Identify affected parties",
            "Set stock prices",
            "Plan marketing"
        ],
        correctAnswer: 1,
        explanation: "Stakeholder analysis helps identify and understand all parties affected by a business decision or project."
    ),
    Question(
        text: "What is the best practice for handling confidential information?",
        answers: [
            "Share with trusted colleagues",
            "Follow security protocols",
            "Keep personal copies",
            "Use public email"
        ],
        correctAnswer: 1,
        explanation: "Always follow established security protocols and only share confidential information on a need-to-know basis."
    ),
    Question(
        text: "What is the purpose of an executive summary?",
        answers: [
            "Technical details",
            "Brief overview",
            "Full analysis",
            "Legal requirements"
        ],
        correctAnswer: 1,
        explanation: "An executive summary provides a concise overview of key points for busy readers to quickly understand the main message."
    )
]

private let intermediateCreditPrinciplesQuestions = [
    Question(
        text: "What factors most heavily influence your credit score?",
        answers: [
            "Income and employment",
            "Payment history and utilization",
            "Age and location",
            "Education and assets"
        ],
        correctAnswer: 1,
        explanation: "Payment history (35%) and credit utilization (30%) are the two most important factors in calculating your FICO score."
    ),
    Question(
        text: "What is a good credit utilization ratio?",
        answers: [
            "Below 30%",
            "50%",
            "70%",
            "100%"
        ],
        correctAnswer: 0,
        explanation: "Keeping credit utilization below 30% is generally recommended for maintaining a good credit score."
    ),
    Question(
        text: "What is a secured credit card?",
        answers: [
            "A card with high limits",
            "A card backed by a deposit",
            "A card with no interest",
            "A card with rewards"
        ],
        correctAnswer: 1,
        explanation: "A secured credit card requires a security deposit, which typically becomes your credit limit."
    ),
    Question(
        text: "How long do negative items stay on your credit report?",
        answers: [
            "1 year",
            "7 years",
            "10 years",
            "Forever"
        ],
        correctAnswer: 1,
        explanation: "Most negative items stay on your credit report for 7 years, while bankruptcies can remain for 10 years."
    )
]

// Continue adding the remaining intermediate and advanced question arrays...
// Follow the same pattern for:
// - intermediateFinancialMathQuestions
// - intermediateInvestingQuestions
// - intermediateBusinessCommunicationQuestions
// - intermediateCreditPrinciplesQuestions

private let advancedBudgetingQuestions = [
    Question(
        text: "What is the debt avalanche method?",
        answers: [
            "Paying highest interest first",
            "Paying smallest balances first",
            "Paying all debts equally",
            "Ignoring debt completely"
        ],
        correctAnswer: 0,
        explanation: "The debt avalanche method focuses on paying off debts with the highest interest rates first while maintaining minimum payments on others."
    ),
    Question(
        text: "What is lifestyle inflation?",
        answers: [
            "Rising prices",
            "Increased spending with income",
            "Market inflation",
            "Cost of living increase"
        ],
        correctAnswer: 1,
        explanation: "Lifestyle inflation occurs when spending increases as income grows, preventing savings growth despite higher earnings."
    ),
    Question(
        text: "What is a sinking fund?",
        answers: [
            "Emergency savings",
            "Regular savings for specific goal",
            "Retirement account",
            "Investment loss"
        ],
        correctAnswer: 1,
        explanation: "A sinking fund is money regularly set aside for a specific future expense, helping avoid debt for planned purchases."
    ),
    Question(
        text: "What is opportunity cost in budgeting?",
        answers: [
            "Direct expenses",
            "Value of alternatives foregone",
            "Interest payments",
            "Budget deficit"
        ],
        correctAnswer: 1,
        explanation: "Opportunity cost represents the value of alternatives you give up when making a financial decision."
    )
]

private let advancedFinancialMathQuestions = [
    Question(
        text: "What is the internal rate of return (IRR)?",
        answers: [
            "Average return rate",
            "Rate making NPV zero",
            "Minimum return rate",
            "Maximum return rate"
        ],
        correctAnswer: 1,
        explanation: "IRR is the discount rate that makes the net present value (NPV) of all cash flows equal to zero."
    ),
    Question(
        text: "How is duration used in bond investing?",
        answers: [
            "Time until maturity",
            "Price sensitivity to rates",
            "Interest payment schedule",
            "Bond rating"
        ],
        correctAnswer: 1,
        explanation: "Duration measures a bond's price sensitivity to interest rate changes, helping assess risk."
    ),
    Question(
        text: "What is the Sharpe ratio used for?",
        answers: [
            "Measuring profit",
            "Risk-adjusted return",
            "Market timing",
            "Asset allocation"
        ],
        correctAnswer: 1,
        explanation: "The Sharpe ratio measures risk-adjusted return by comparing excess returns to standard deviation."
    ),
    Question(
        text: "What is Monte Carlo simulation in financial planning?",
        answers: [
            "Gambling strategy",
            "Random scenario analysis",
            "Investment guarantee",
            "Tax calculation"
        ],
        correctAnswer: 1,
        explanation: "Monte Carlo simulation tests financial plans against many random scenarios to assess probability of success."
    )
]

private let advancedInvestingQuestions = [
    Question(
        text: "What is a derivative?",
        answers: [
            "Direct stock ownership",
            "Contract deriving value from asset",
            "Mutual fund",
            "Bank account"
        ],
        correctAnswer: 1,
        explanation: "A derivative is a financial contract whose value is derived from the performance of an underlying asset."
    ),
    Question(
        text: "What is arbitrage?",
        answers: [
            "Long-term investing",
            "Price difference exploitation",
            "Market timing",
            "Dollar cost averaging"
        ],
        correctAnswer: 1,
        explanation: "Arbitrage is profiting from price differences of the same asset in different markets."
    ),
    Question(
        text: "What is short selling?",
        answers: [
            "Quick stock sale",
            "Borrowing to sell high, buy low",
            "Small investment",
            "Partial stock sale"
        ],
        correctAnswer: 1,
        explanation: "Short selling involves borrowing shares to sell, hoping to buy them back at a lower price."
    ),
    Question(
        text: "What is a hedge fund?",
        answers: [
            "Safe investment",
            "Alternative investment pool",
            "Government bond",
            "Stock market index"
        ],
        correctAnswer: 1,
        explanation: "A hedge fund is an actively managed investment pool using various strategies to generate returns."
    )
]

private let advancedBusinessCommunicationQuestions = [
    Question(
        text: "What is change management communication?",
        answers: [
            "Regular updates",
            "Strategic organizational change",
            "Email management",
            "Social media updates"
        ],
        correctAnswer: 1,
        explanation: "Change management communication involves strategically communicating organizational changes to minimize resistance and ensure success."
    ),
    Question(
        text: "What is the purpose of a communication audit?",
        answers: [
            "Check grammar",
            "Evaluate effectiveness",
            "Count messages",
            "Track time"
        ],
        correctAnswer: 1,
        explanation: "A communication audit evaluates the effectiveness of organizational communication strategies and channels."
    ),
    Question(
        text: "What is strategic ambiguity?",
        answers: [
            "Poor communication",
            "Intentional vagueness",
            "Miscommunication",
            "Technical language"
        ],
        correctAnswer: 1,
        explanation: "Strategic ambiguity is deliberately using vague language to maintain flexibility or manage sensitive information."
    ),
    Question(
        text: "What is organizational storytelling?",
        answers: [
            "Fiction writing",
            "Narrative communication",
            "Casual conversation",
            "Meeting minutes"
        ],
        correctAnswer: 1,
        explanation: "Organizational storytelling uses narratives to communicate values, culture, and strategic messages effectively."
    )
]

private let advancedCreditPrinciplesQuestions = [
    Question(
        text: "What is a credit default swap (CDS)?",
        answers: [
            "Credit card exchange",
            "Insurance against default",
            "Score improvement",
            "Loan transfer"
        ],
        correctAnswer: 1,
        explanation: "A CDS is a financial derivative that acts as insurance against credit risk."
    ),
    Question(
        text: "What is debt-to-income ratio (DTI)?",
        answers: [
            "Credit score",
            "Monthly debt vs. income",
            "Loan interest rate",
            "Credit limit"
        ],
        correctAnswer: 1,
        explanation: "DTI compares monthly debt payments to monthly income, helping lenders assess borrowing capacity."
    ),
    Question(
        text: "What is a credit freeze?",
        answers: [
            "Account closure",
            "New credit prevention",
            "Payment pause",
            "Score lock"
        ],
        correctAnswer: 1,
        explanation: "A credit freeze prevents new credit accounts from being opened in your name, helping prevent identity theft."
    ),
    Question(
        text: "What is tradeline seasoning?",
        answers: [
            "Credit mix",
            "Account age requirement",
            "Payment history",
            "Credit limit"
        ],
        correctAnswer: 1,
        explanation: "Tradeline seasoning refers to the minimum time an account must be open to be considered valid for credit purposes."
    )
]

struct QuizQuestionView: View {
    @Binding var currentView: String
    @Binding var quizScore: Int
    
    // Get the current quiz title from UserDefaults
    private var quizTitle: String {
        UserDefaults.standard.string(forKey: "currentQuiz") ?? "Introduction to Budgeting"
    }
    
    // Helper function to get questions
    private func getQuestionsForQuiz(_ title: String) -> [Question] {
        switch title {
        case "Introduction to Budgeting":
            return introductionToBudgetingQuestions
        case "Introduction to Financial Math":
            return introductionToFinancialMathQuestions
        case "Introduction to Investing":
            return introductionToInvestingQuestions
        case "Introduction to Business Communication":
            return introductionToBusinessCommunicationQuestions
        case "Introduction to Credit Principles":
            return introductionToCreditPrinciplesQuestions
        case "Intermediate Budgeting":
            return intermediateBudgetingQuestions
        case "Intermediate Financial Math":
            return intermediateFinancialMathQuestions
        case "Intermediate Investing":
            return intermediateInvestingQuestions
        case "Intermediate Business Communication":
            return intermediateBusinessCommunicationQuestions
        case "Intermediate Credit Principles":
            return intermediateCreditPrinciplesQuestions
        case "Advanced Budgeting":
            return advancedBudgetingQuestions
        case "Advanced Financial Math":
            return advancedFinancialMathQuestions
        case "Advanced Investing":
            return advancedInvestingQuestions
        case "Advanced Business Communication":
            return advancedBusinessCommunicationQuestions
        case "Advanced Credit Principles":
            return advancedCreditPrinciplesQuestions
        default:
            return introductionToBudgetingQuestions
        }
    }
    
    // Get questions for the current quiz
    private var questions: [Question] {
        getQuestionsForQuiz(quizTitle)
    }

    var body: some View {
        if questions.isEmpty {
            Text("No questions available")
                .foregroundColor(.white)
        } else {
            QuizContentView(
                questions: questions,
                currentView: $currentView,
                quizScore: $quizScore,
                quizTitle: quizTitle
            )
        }
    }
}

// Break out the main content into a separate view
struct QuizContentView: View {
    let questions: [Question]
    @Binding var currentView: String
    @Binding var quizScore: Int
    let quizTitle: String
    
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswerIndex: Int?
    @State private var showingExplanation = false
    @State private var animateProgress = false
    
    var body: some View {
        ZStack {
            // Background
            backgroundGradient
            
            VStack(spacing: 20) {
                QuizHeader(
                    currentQuestionIndex: currentQuestionIndex,
                    questionsCount: questions.count,
                    quizScore: quizScore,
                    onExit: { currentView = "Quiz" }
                )
                
                ScrollView {
                    VStack(spacing: 24) {
                        QuestionCard(question: questions[currentQuestionIndex])
                        
                        AnswerOptionsView(
                            answers: questions[currentQuestionIndex].answers,
                            selectedIndex: $selectedAnswerIndex,
                            showingExplanation: showingExplanation,
                            correctAnswer: questions[currentQuestionIndex].correctAnswer
                        )
                        
                        if showingExplanation {
                            ExplanationCard(explanation: questions[currentQuestionIndex].explanation)
                        }
                    }
                }
                
                ActionButton(
                    showingExplanation: showingExplanation,
                    isLastQuestion: currentQuestionIndex == questions.count - 1,
                    isAnswerSelected: selectedAnswerIndex != nil,
                    onAction: showingExplanation ? nextQuestion : submitAnswer
                )
                .padding(.bottom)
            }
        }
        .onAppear {
            withAnimation(.spring().delay(0.3)) {
                animateProgress = true
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.1, green: 0.1, blue: 0.15),
                Color(red: 0.15, green: 0.15, blue: 0.2)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }

    private func submitAnswer() {
        if let selected = selectedAnswerIndex {
            showingExplanation = true
            if selected == questions[currentQuestionIndex].correctAnswer {
                quizScore += 1
            }
        }
    }

    private func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswerIndex = nil
            showingExplanation = false
        } else {
            currentView = "QuizResultView"
        }
    }
}

// Header component
struct QuizHeader: View {
    let currentQuestionIndex: Int
    let questionsCount: Int
    let quizScore: Int
    let onExit: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onExit) {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.gray)
                    .padding()
            }
            
            Spacer()
            
            ProgressPills(current: currentQuestionIndex, total: questionsCount)
            
            Spacer()
            
            Text("\(quizScore)/\(questionsCount)")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.cyan)
                .padding()
        }
    }
}

// Progress Pills component
struct ProgressPills: View {
    let current: Int
    let total: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index == current ? Color.cyan : Color.white.opacity(0.2))
                    .frame(width: 24, height: 4)
                    .animation(.spring(), value: current)
            }
        }
    }
}

// Question Card component
struct QuestionCard: View {
    let question: Question
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text(question.text)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(red: 0.18, green: 0.18, blue: 0.24))
                .shadow(color: Color.cyan.opacity(0.15), radius: 10, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

// Answer Options View
struct AnswerOptionsView: View {
    let answers: [String]
    @Binding var selectedIndex: Int?
    let showingExplanation: Bool
    let correctAnswer: Int
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<4) { index in
                AnswerButton(
                    text: answers[index],
                    isSelected: selectedIndex == index,
                    isCorrect: showingExplanation ? index == correctAnswer : nil,
                    action: {
                        withAnimation(.spring()) {
                            selectedIndex = index
                        }
                    }
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal)
    }
}

// Explanation Card
struct ExplanationCard: View {
    let explanation: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("Explanation")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Text(explanation)
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                .shadow(color: .black.opacity(0.2), radius: 10)
        )
        .padding(.horizontal)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

// Action Button
struct ActionButton: View {
    let showingExplanation: Bool
    let isLastQuestion: Bool
    let isAnswerSelected: Bool
    let onAction: () -> Void
    
    var body: some View {
        Button(action: onAction) {
            Text(showingExplanation ? 
                 (isLastQuestion ? "See Results" : "Next Question") :
                 "Check Answer")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isAnswerSelected ? Color.cyan : Color.gray)
                )
                .padding(.horizontal)
        }
        .disabled(!isAnswerSelected)
    }
}

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(getTextColor())
                    .padding(.trailing)
                
                Spacer()
                
                if let isCorrect = isCorrect {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                        .foregroundColor(isCorrect ? .green : .red)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.18, green: 0.18, blue: 0.24))
                    .shadow(color: getBorderColor().opacity(0.15), radius: 5, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(getBorderColor(), lineWidth: 2)
            )
        }
        .disabled(isCorrect != nil)
        .animation(.spring(), value: isSelected)
        .animation(.spring(), value: isCorrect)
    }
    
    private func getTextColor() -> Color {
        if isCorrect == true {
            return .green
        } else if isCorrect == false {
            return .red
        } else if isSelected {
            return .white
        }
        return .white.opacity(0.9)
    }
    
    private func getBorderColor() -> Color {
        if isCorrect == true {
            return .green
        } else if isCorrect == false {
            return .red
        } else if isSelected {
            return .orange
        }
        return Color.gray.opacity(0.3)
    }
}

struct QuizQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        // Set a default quiz title for the preview
        UserDefaults.standard.set("Introduction to Budgeting", forKey: "currentQuiz")
        
        return QuizQuestionView(
            currentView: .constant("QuizQuestionView"),
            quizScore: .constant(0)
        )
    }
}
