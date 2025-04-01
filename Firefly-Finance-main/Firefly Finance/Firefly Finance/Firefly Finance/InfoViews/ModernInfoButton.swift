import SwiftUI

struct ModernInfoButton: View {
    let action: () -> Void
    var color: Color = .cyan
    var size: CGFloat = 20
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: size))
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            Circle()
                                .stroke(color.opacity(0.3), lineWidth: 1)
                        )
                )
                .contentShape(Circle())
        }
    }
} 