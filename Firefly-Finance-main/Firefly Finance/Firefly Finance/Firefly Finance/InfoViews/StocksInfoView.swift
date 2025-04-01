import SwiftUI

// Move StockInfo outside the view struct
struct StockInfo: Identifiable {
    let id = UUID()
    let name: String
    let ticker: String
    let description: String
    let riskLevel: String
    let returnPotential: String
    let dividendYield: String?
    let color: Color
}

struct StocksInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var currentView: String
    
    let stocks = [
        StockInfo(
            name: "CyberMosaic Systems",
            ticker: "CMSY",
            description: "A cutting-edge tech company specializing in AI and blockchain solutions. High potential returns but with significant market volatility. Focuses on growth rather than dividends.",
            riskLevel: "High",
            returnPotential: "5-15%",
            dividendYield: nil,
            color: .cyan
        ),
        StockInfo(
            name: "Prickler Holdings",
            ticker: "PHGS",
            description: "Established financial services corporation known for stable growth and reliable dividend payments. Lower risk with consistent returns.",
            riskLevel: "Low",
            returnPotential: "3-7%",
            dividendYield: "4%",
            color: .green
        ),
        StockInfo(
            name: "Pinemoore Finance",
            ticker: "PIMF",
            description: "Innovative fintech company disrupting traditional banking. Balanced approach combining moderate growth potential with modest dividend payments.",
            riskLevel: "Medium",
            returnPotential: "4-10%",
            dividendYield: "2%",
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
                // Header
                HStack {
                    Text("Available Stocks")
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
                
                // Market Overview Card
                MarketOverviewCard()
                    .padding(.horizontal)
                
                // Stocks List
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(stocks) { stock in
                            StockCard(stock: stock)
                        }
                    }
                    .padding()
                }
                .background(Color.clear)
            }
        }
        .navigationBarHidden(true)
    }
    
    // Helper functions for static star positions
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

struct MarketOverviewCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Market Overview")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 20) {
                MarketStat(
                    title: "Risk Levels",
                    value: "Low-High",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .blue
                )
                
                MarketStat(
                    title: "Returns",
                    value: "3-15%",
                    icon: "percent",
                    color: .green
                )
                
                MarketStat(
                    title: "Dividends",
                    value: "0-4%",
                    icon: "dollarsign.circle",
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

struct MarketStat: View {
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

struct StockCard: View {
    let stock: StockInfo
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Stock Header
            Button(action: { withAnimation(.spring()) { isExpanded.toggle() }}) {
                HStack(spacing: 16) {
                    // Ticker Circle
                    ZStack {
                        Circle()
                            .fill(stock.color.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Text(stock.ticker)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(stock.color)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(stock.name)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Risk: \(stock.riskLevel)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
            }
            .padding()
            
            // Expanded Details
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    // Description
                    Text(stock.description)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    // Stats Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                    ], spacing: 16) {
                        StockStat(
                            title: "Return Potential",
                            value: stock.returnPotential,
                            icon: "chart.line.uptrend.xyaxis",
                            color: .green
                        )
                        
                        if let dividend = stock.dividendYield {
                            StockStat(
                                title: "Dividend Yield",
                                value: dividend,
                                icon: "dollarsign.circle",
                                color: .orange
                            )
                        }
                        
                        StockStat(
                            title: "Risk Level",
                            value: stock.riskLevel,
                            icon: "exclamationmark.triangle",
                            color: stock.color
                        )
                    }
                    .padding()
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(stock.color.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: stock.color.opacity(0.1), radius: 10)
        )
    }
}

struct StockStat: View {
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(red: 0.1, green: 0.1, blue: 0.13))
        )
    }
}

struct StocksInfoView_Previews: PreviewProvider {
    static var previews: some View {
        StocksInfoView(currentView: .constant("StocksInfo"))
    }
}
