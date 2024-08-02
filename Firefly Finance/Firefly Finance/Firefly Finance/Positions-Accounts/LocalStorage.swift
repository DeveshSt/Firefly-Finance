import Foundation

class LocalStorage {
    private static let playthroughsKey = "playthroughs"
    private static let maxPlaythroughs = 10

    static func savePlaythrough(_ playthrough: Playthrough) {
        var playthroughs = getPlaythroughs()
        if let index = playthroughs.firstIndex(where: { $0.id == playthrough.id }) {
            // Replace existing playthrough
            playthroughs[index] = playthrough
        } else {
            // Add new playthrough
            playthroughs.append(playthrough)
        }

        // Keep only the latest 10 playthroughs
        if playthroughs.count > maxPlaythroughs {
            playthroughs = Array(playthroughs.suffix(maxPlaythroughs))
        }

        if let data = try? JSONEncoder().encode(playthroughs) {
            UserDefaults.standard.set(data, forKey: playthroughsKey)
        }
    }

    static func getPlaythroughs() -> [Playthrough] {
        guard let data = UserDefaults.standard.data(forKey: playthroughsKey),
              let playthroughs = try? JSONDecoder().decode([Playthrough].self, from: data) else {
            return []
        }
        return playthroughs
    }

    static func deletePlaythrough(_ playthrough: Playthrough) {
        var playthroughs = getPlaythroughs()
        playthroughs.removeAll { $0.id == playthrough.id }
        if let data = try? JSONEncoder().encode(playthroughs) {
            UserDefaults.standard.set(data, forKey: playthroughsKey)
        }
    }
}
