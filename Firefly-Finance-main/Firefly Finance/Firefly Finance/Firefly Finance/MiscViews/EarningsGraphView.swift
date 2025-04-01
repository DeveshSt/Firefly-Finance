import SwiftUI
import Charts

struct DataPoint: Equatable {
    let year: Int
    let value: Double
    
    static func == (lhs: DataPoint, rhs: DataPoint) -> Bool {
        return lhs.year == rhs.year && lhs.value == rhs.value
    }
}

struct EarningsGraphView: View {
    let earningsOverTime: [(year: Int, value: Double)]
    @Binding var userAccount: UserAccount
    @Binding var currentYear: Double
    let onNavigateHome: () -> Void
    
    @State private var selectedTimeRange: TimeRange = .all
    @State private var selectedPoint: DataPoint?
    @State private var isDragging = false
    
    enum TimeRange: String, CaseIterable {
        case day = "1D"
        case week = "1W"
        case month = "1M"
        case threeMonths = "3M"
        case year = "1Y"
        case all = "All"
    }
    
    private var filteredData: [DataPoint] {
        let data = switch selectedTimeRange {
        case .day:
            Array(earningsOverTime.suffix(2))
        case .week:
            Array(earningsOverTime.suffix(7))
        case .month:
            Array(earningsOverTime.suffix(30))
        case .threeMonths:
            Array(earningsOverTime.suffix(90))
        case .year:
            Array(earningsOverTime.suffix(365))
        case .all:
            earningsOverTime
        }
        return data.map { DataPoint(year: $0.year, value: $0.value) }
    }
    
    private var totalChange: Double {
        guard let first = filteredData.first?.value,
              let last = filteredData.last?.value else { return 0 }
        return last - first
    }
    
    private var percentageChange: Double {
        guard let first = filteredData.first?.value,
              let last = filteredData.last?.value,
              first != 0 else { return 0 }
        return ((last - first) / first) * 100
    }
    
    private var graphColor: Color {
        totalChange >= 0 ? .green : .red
    }
    
    private var graphMinValue: Double {
        filteredData.min(by: { $0.value < $1.value })?.value ?? 0
    }
    
    private var graphMaxValue: Double {
        filteredData.max(by: { $0.value < $1.value })?.value ?? 0
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
            
            // Enhanced star effect with different sizes
            StarryBackground()
            
            VStack(spacing: 0) {
                // Stats Cards
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        StatCard(
                            title: "Portfolio Value",
                            value: formatCurrency(userAccount.netAccountValue),
                            change: totalChange,
                            color: graphColor
                        )
                        
                        StatCard(
                            title: "Cash Balance",
                            value: formatCurrency(userAccount.cashBalance),
                            change: nil,
                            color: .cyan
                        )
                        
                        StatCard(
                            title: "Total Return",
                            value: "\(String(format: "%.1f", percentageChange))%",
                            change: totalChange,
                            color: graphColor
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                
                // Main Graph Section
                VStack(alignment: .leading, spacing: 8) {
                    // Current Value Display
                    Text(formatCurrency(selectedPoint?.value ?? filteredData.last?.value ?? 0))
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .animation(.none, value: selectedPoint)
                    
                    // Change Display
                    HStack(spacing: 8) {
                        Text(totalChange >= 0 ? "+" : "")
                            + Text(formatCurrency(totalChange))
                            + Text(" (\(String(format: "%.2f", abs(percentageChange)))%)")
                        
                        Image(systemName: totalChange >= 0 ? "arrow.up.right" : "arrow.down.right")
                    }
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(graphColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Graph
                GeometryReader { geometry in
                    Chart {
                        ForEach(filteredData, id: \.year) { point in
                            LineMark(
                                x: .value("Year", point.year),
                                y: .value("Value", point.value)
                            )
                            .interpolationMethod(.cardinal)
                            .foregroundStyle(graphColor.gradient)
                            
                            AreaMark(
                                x: .value("Year", point.year),
                                y: .value("Value", point.value)
                            )
                            .interpolationMethod(.cardinal)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        graphColor.opacity(0.3),
                                        graphColor.opacity(0.1),
                                        graphColor.opacity(0.05)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        }
                        
                        if let selected = selectedPoint {
                            RuleMark(
                                x: .value("Selected", selected.year)
                            )
                            .foregroundStyle(Color.white.opacity(0.3))
                            
                            PointMark(
                                x: .value("Selected Year", selected.year),
                                y: .value("Selected Value", selected.value)
                            )
                            .foregroundStyle(Color.white)
                            .symbolSize(100)
                        }
                    }
                    .chartXAxis {
                        AxisMarks(position: .bottom) { value in
                            AxisGridLine()
                                .foregroundStyle(Color.gray.opacity(0.3))
                            AxisValueLabel()
                                .foregroundStyle(Color.gray)
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading) { value in
                            AxisGridLine()
                                .foregroundStyle(Color.gray.opacity(0.3))
                            AxisValueLabel()
                                .foregroundStyle(Color.gray)
                        }
                    }
                    .chartYScale(domain: graphMinValue * 0.95...graphMaxValue * 1.05)
                    .chartOverlay { proxy in
                        GeometryReader { geometry in
                            Rectangle()
                                .fill(.clear)
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            let x = value.location.x
                                            guard let year = proxy.value(atX: x, as: Int.self) else { return }
                                            
                                            if let point = filteredData.first(where: { $0.year == year }) {
                                                withAnimation(.easeInOut(duration: 0.15)) {
                                                    selectedPoint = point
                                                }
                                                isDragging = true
                                            }
                                        }
                                        .onEnded { _ in
                                            isDragging = false
                                            withAnimation(.easeInOut(duration: 0.15)) {
                                                selectedPoint = nil
                                            }
                                        }
                                )
                        }
                    }
                }
                .frame(height: 300)
                .padding()
                
                // Time range selector with glowing effect
                HStack {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTimeRange = range
                            }
                        }) {
                            Text(range.rawValue)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(selectedTimeRange == range ? .white : .gray)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(
                                    Group {
                                        if selectedTimeRange == range {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color(red: 0.2, green: 0.2, blue: 0.25))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(graphColor.opacity(0.5), lineWidth: 1)
                                                )
                                                .shadow(color: graphColor.opacity(0.3), radius: 5)
                                        }
                                    }
                                )
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}

// New Components
struct StarryBackground: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<150, id: \.self) { _ in
                Circle()
                    .fill(Color.white)
                    .frame(width: .random(in: 1...4), height: .random(in: 1...4))
                    .position(
                        x: .random(in: 0...geometry.size.width),
                        y: .random(in: 0...geometry.size.height)
                    )
                    .opacity(.random(in: 0.3...0.7))
                    .animation(
                        Animation.easeInOut(duration: .random(in: 1...3))
                            .repeatForever(autoreverses: true),
                        value: UUID()
                    )
            }
        }
        .opacity(0.7)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let change: Double?
    let color: Color
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            if let change = change {
                Text((change >= 0 ? "+" : "") + formatCurrency(change))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(color)
            }
        }
        .padding()
        .frame(width: 160)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: color.opacity(0.1), radius: 10)
        )
    }
}
