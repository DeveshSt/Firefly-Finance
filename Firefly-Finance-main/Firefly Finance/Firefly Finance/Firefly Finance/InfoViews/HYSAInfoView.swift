import SwiftUI

struct HYSAInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    struct HYSAFeature: Identifiable {
        let id = UUID()
        let title: String
        let points: [String]
        let icon: String
        let color: Color
    }
    
    let features = [
        HYSAFeature(
            title: "Key Benefits",
            points: [
                "Higher interest rates than traditional savings",
                "FDIC insurance protection",
                "Easy access to funds",
                "No maintenance fees"
            ],
            icon: "star.fill",
            color: .green
        ),
        HYSAFeature(
            title: "Account Details",
            points: [
                "5% Annual Percentage Yield (APY)",
                "Daily interest compounding",
                "Monthly interest payments",
                "No minimum balance required"
            ],
            icon: "percent",
            color: .blue
        ),
        HYSAFeature(
            title: "Important Considerations",
            points: [
                "Variable interest rates based on market",
                "Monthly withdrawal limits may apply",
                "Online account management",
                "Secure banking platform"
            ],
            icon: "exclamationmark.shield.fill",
            color: .orange
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
                // Custom Header with Close Button
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
                
                // Scrollable Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Description Card
                        Text("Maximize your savings with our competitive interest rates and flexible account features.")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        
                        // Feature Cards
                        ForEach(features) { feature in
                            FeatureCard(feature: feature)
                        }
                        
                        // Calculator Card
                        CalculatorCard()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
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

struct FeatureCard: View {
    let feature: HYSAInfoView.HYSAFeature
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                // Icon Circle
                ZStack {
                    Circle()
                        .fill(feature.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: feature.icon)
                        .font(.system(size: 24))
                        .foregroundColor(feature.color)
                }
                
                Text(feature.title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(feature.points, id: \.self) { point in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(feature.color)
                            .font(.system(size: 16))
                        
                        Text(point)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.leading, 8)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(feature.color.opacity(0.3), lineWidth: 1)
                )
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
                    .padding()
                    .background(Color(red: 0.2, green: 0.2, blue: 0.25))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .placeholder(when: initialAmount.isEmpty) {
                        Text("Initial Amount")
                            .foregroundColor(.white.opacity(0.7))
                    }
                
                TextField("Number of Months", text: $months)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color(red: 0.2, green: 0.2, blue: 0.25))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .placeholder(when: months.isEmpty) {
                        Text("Number of Months")
                            .foregroundColor(.white.opacity(0.7))
                    }
                
                Button(action: calculateGrowth) {
                    Text("Calculate Growth")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cyan)
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
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                )
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

// Add this extension for the custom placeholder
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct HYSAInfoView_Previews: PreviewProvider {
    static var previews: some View {
        HYSAInfoView()
    }
}
