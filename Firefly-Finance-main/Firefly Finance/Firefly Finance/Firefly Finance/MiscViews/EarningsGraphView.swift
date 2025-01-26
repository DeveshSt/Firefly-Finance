import SwiftUI
import Charts

struct EarningsGraphView: View {
    let earningsOverTime: [(year: Int, value: Double)]
    @Binding var userAccount: UserAccount
    @Binding var currentYear: Double
    let onNavigateHome: () -> Void

    var body: some View {
        VStack {
            HStack {
                Button(action: { onNavigateHome() }) {
                    Text("Home")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Spacer()
            }
            .padding()
            .background(Color.black)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Total Net Worth")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("$\(earningsOverTime.last?.value ?? 0, specifier: "%.2f")")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    Text("Years Simulated: \(Int(currentYear))")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                
                Spacer()
            }

            if earningsOverTime.isEmpty {
                Text("No data available")
                    .foregroundColor(.white)
                    .padding()
            } else {
                Chart {
                    ForEach(earningsOverTime, id: \.year) { data in
                        LineMark(
                            x: .value("Year", data.year),
                            y: .value("Earnings", data.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Color.green)
                    }
                }
                .chartXAxis {
                    AxisMarks(position: .bottom, values: .stride(by: 1)) { value in
                        AxisGridLine().foregroundStyle(Color.white)
                        AxisTick().foregroundStyle(Color.white)
                        AxisValueLabel().foregroundStyle(Color.white)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisGridLine().foregroundStyle(Color.white)
                        AxisTick().foregroundStyle(Color.white)
                        AxisValueLabel().foregroundStyle(Color.white)
                    }
                }
                .frame(height: 300)
                .padding()
            }

            Spacer()
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
