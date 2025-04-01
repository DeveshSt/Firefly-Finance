struct SavingsAccountInfo: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
}

struct SavingsAccountInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var currentView: String
    
    let features = [
        SavingsAccountInfo(
            title: "High Interest Rate",
            description: "Earn a competitive 5% Annual Percentage Yield (APY) on your savings, significantly higher than traditional savings accounts.",
            icon: "percent",
            color: .green
        ),
        SavingsAccountInfo(
            title: "Compound Interest",
            description: "Interest is compounded daily and paid monthly, helping your money grow faster through the power of compound returns.",
            icon: "chart.line.uptrend.xyaxis.circle",
            color: .blue
        ),
        SavingsAccountInfo(
            title: "Flexible Access",
            description: "Easily deposit or withdraw funds at any time with no minimum balance requirements or maintenance fees.",
            icon: "arrow.left.arrow.right",
            color: .orange
        ),
        SavingsAccountInfo(
            title: "Safe & Secure",
            description: "Your savings are protected and guaranteed to grow at the stated interest rate, providing a stable foundation for your financial future.",
            icon: "lock.shield",
            color: .purple
        )
    ]
    
    var body: some View {
        ZStack {
            // Background gradient with static stars
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.15),
                    Color(red: 0.15, green: 0.15, blue: 0.2)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Static star effect
            GeometryReader { geometry in
                ForEach(0..<150, id: \.self) { index in
                    let position = getStarPosition(index: index, size: geometry.size)
                    Circle()
                        .fill(Color.white)
                        .frame(width: getStarSize(index: index), height: getStarSize(index: index))
                        .position(x: position.x, y: position.y)
                        .opacity(getStarOpacity(index: index))
                }
            }
            .ignoresSafeArea()
            .opacity(0.7)
            
            // Main Content
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("High Yield Savings")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                // Overview Card
                SavingsOverviewCard()
                    .padding(.horizontal)
                
                // Features List
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(features) { feature in
                            FeatureCard(feature: feature)
                        }
                        
                        // Calculator Card
                        CalculatorCard()
                    }
                    .padding()
                }
                .background(Color.clear)
            }
        }
        .navigationBarHidden(true)
    }
    
    // Helper functions for static stars
    private func getStarPosition(index: Int, size: CGSize) -> CGPoint {
        let x = CGFloat(((index * 13) % Int(size.width)))
        let y = CGFloat(((index * 17) % Int(size.height)))
        return CGPoint(x: x, y: y)
    }
    
    private func getStarSize(index: Int) -> CGFloat {
        let sizes = [1.5, 2.0, 2.5, 3.0]
        return sizes[index % sizes.count]
    }
    
    private func getStarOpacity(index: Int) -> Double {
        let opacities = [0.3, 0.4, 0.5, 0.6, 0.7]
        return opacities[index % opacities.count]
    }
}

struct SavingsOverviewCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Account Overview")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 20) {
                SavingsStat(
                    title: "APY",
                    value: "5.00%",
                    icon: "percent",
                    color: .green
                )
                
                SavingsStat(
                    title: "Compounding",
                    value: "Daily",
                    icon: "clock",
                    color: .blue
                )
                
                SavingsStat(
                    title: "Payout",
                    value: "Monthly",
                    icon: "calendar",
                    color: .orange
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct SavingsStat: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .foregroundColor(.gray)
            }
            .font(.system(size: 14))
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}

struct FeatureCard: View {
    let feature: SavingsAccountInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(feature.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: feature.icon)
                        .font(.system(size: 24))
                        .foregroundColor(feature.color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(feature.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(feature.description)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(feature.color.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: feature.color.opacity(0.1), radius: 10)
        )
    }
}

struct CalculatorCard: View {
    @State private var initialAmount: String = ""
    @State private var months: String = ""
    @State private var futureValue: Double = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Growth Calculator")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                TextField("Initial Amount", text: $initialAmount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.white)
                
                TextField("Number of Months", text: $months)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.white)
                
                Button(action: calculateGrowth) {
                    Text("Calculate")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                if futureValue > 0 {
                    Text("Future Value: $\(String(format: "%.2f", futureValue))")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.blue.opacity(0.1), radius: 10)
        )
    }
    
    private func calculateGrowth() {
        guard let principal = Double(initialAmount),
              let numberOfMonths = Double(months) else {
            return
        }
        
        let monthlyRate = 0.05 / 12 // 5% APY converted to monthly
        futureValue = principal * pow(1 + monthlyRate, numberOfMonths)
    }
}

struct SavingsAccountInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsAccountInfoView(currentView: .constant("SavingsInfo"))
    }
} 