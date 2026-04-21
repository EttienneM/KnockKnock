import Foundation

struct Config: Codable {
    let recipient: String
    var message: String = "Mac unlocked"
    var cooldownSeconds: Double = 5

    static func load() -> Config {
        let path = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".config/knockknock/config.json")
        guard let data = try? Data(contentsOf: path) else {
            fputs("[knockknock] FATAL: config not found at \(path.path)\n", stderr)
            exit(1)
        }
        do {
            return try JSONDecoder().decode(Config.self, from: data)
        } catch {
            fputs("[knockknock] FATAL: config parse error: \(error)\n", stderr)
            exit(1)
        }
    }
}
