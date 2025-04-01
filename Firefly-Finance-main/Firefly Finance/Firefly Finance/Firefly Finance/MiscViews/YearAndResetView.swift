import SwiftUI

struct YearAndResetView: View {
    @Binding var currentYear: Double
    @Binding var showingResetConfirmation: Bool
    @Binding var currentView: String
    @State private var isHoveringHelp = false
    @State private var isHoveringReset = false

    var body: some View {
        HStack {
            // Year Display with glass-morphic effect
            Text("Year \(Int(currentYear))")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .padding(.leading)

            Spacer()

            HStack(spacing: 20) {
                // Help Button
                Button(action: { currentView = "Help" }) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.cyan)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    Circle()
                                        .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                .contentShape(Circle())

                // Reset Button
                Button(action: { showingResetConfirmation = true }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.red.opacity(0.9))
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    Circle()
                                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                .contentShape(Circle())
            }
            .padding(.trailing)
        }
        .padding(.vertical, 8)
    }
}
