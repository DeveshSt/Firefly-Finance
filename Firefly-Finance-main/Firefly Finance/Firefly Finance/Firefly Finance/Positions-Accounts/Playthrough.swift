import Foundation

struct Playthrough: Identifiable, Equatable {
    var id = UUID()
    let year: Int
    let netAccountValue: Double
    let date: Date
    let userAccount: UserAccount
    let earningsOverTime: [(year: Int, value: Double)]
    
    static func == (lhs: Playthrough, rhs: Playthrough) -> Bool {
        return lhs.id == rhs.id
    }
}

// Extension to conform to Codable
extension Playthrough: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case year
        case netAccountValue
        case date
        case userAccount
        case earningsOverTime
    }
    
    enum EarningsCodingKeys: String, CodingKey {
        case year
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        year = try container.decode(Int.self, forKey: .year)
        netAccountValue = try container.decode(Double.self, forKey: .netAccountValue)
        date = try container.decode(Date.self, forKey: .date)
        userAccount = try container.decode(UserAccount.self, forKey: .userAccount)
        
        // Decode earningsOverTime
        var earningsContainer = try container.nestedUnkeyedContainer(forKey: .earningsOverTime)
        var earnings: [(year: Int, value: Double)] = []
        
        while !earningsContainer.isAtEnd {
            let earningsValues = try earningsContainer.nestedContainer(keyedBy: EarningsCodingKeys.self)
            let year = try earningsValues.decode(Int.self, forKey: .year)
            let value = try earningsValues.decode(Double.self, forKey: .value)
            earnings.append((year: year, value: value))
        }
        
        earningsOverTime = earnings
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(year, forKey: .year)
        try container.encode(netAccountValue, forKey: .netAccountValue)
        try container.encode(date, forKey: .date)
        try container.encode(userAccount, forKey: .userAccount)
        
        // Encode earningsOverTime
        var earningsContainer = container.nestedUnkeyedContainer(forKey: .earningsOverTime)
        for earnings in earningsOverTime {
            var earningsValues = earningsContainer.nestedContainer(keyedBy: EarningsCodingKeys.self)
            try earningsValues.encode(earnings.year, forKey: .year)
            try earningsValues.encode(earnings.value, forKey: .value)
        }
    }
}
