let stocks = [
    Stock(
        name: "CyberMosaic Systems",
        ticker: "CMSY",
        price: Double.random(in: 80.00...120.00),  // More volatile tech stock
        riskLevel: .high,
        projectedRateOfReturn: 0.12,  // 12% potential return
        dividendYield: 0.0  // No dividend - growth stock
    ),
    Stock(
        name: "Prickler Holdings",
        ticker: "PHGS",
        price: Double.random(in: 180.00...220.00),  // More stable blue chip
        riskLevel: .medium,
        projectedRateOfReturn: 0.06,  // 6% potential return
        dividendYield: 0.04  // 4% dividend - value stock
    ),
    Stock(
        name: "Pinemoore Finance",
        ticker: "PIMF",
        price: Double.random(in: 40.00...60.00),  // Growing fintech
        riskLevel: .medium,
        projectedRateOfReturn: 0.09,  // 9% potential return
        dividendYield: 0.02  // 2% dividend - balanced stock
    )
] 