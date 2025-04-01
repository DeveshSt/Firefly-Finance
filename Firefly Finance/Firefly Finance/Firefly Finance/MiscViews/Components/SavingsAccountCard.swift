import SwiftUI

struct SavingsAccountCard: View {
    let account: SavingsAccount
    let onDeposit: () -> Void
    let onWithdraw: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(account.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Text("\(Int(account.interestRate * 100))% APY")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.green)
            }
            
            Text("$\(account.balance, specifier: "%.2f")")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                Button(action: onDeposit) {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                        Text("Deposit")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.green, Color.green.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                    )
                    .foregroundColor(.black)
                }
                
                Button(action: onWithdraw) {
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                        Text("Withdraw")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 10)
    }
} 