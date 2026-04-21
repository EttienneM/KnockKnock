import Foundation

@MainActor
final class UnlockWatcher {
    private let config: Config
    private var lastSentAt: Date?

    init(config: Config) {
        self.config = config
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(screenUnlocked),
            name: NSNotification.Name("com.apple.screenIsUnlocked"),
            object: nil
        )
        log("watching for com.apple.screenIsUnlocked (cooldown \(Int(config.cooldownSeconds))s)")
    }

    @objc private func screenUnlocked() {
        let now = Date()
        if let last = lastSentAt, now.timeIntervalSince(last) < config.cooldownSeconds {
            log("debounced (within \(Int(config.cooldownSeconds))s cooldown)")
            return
        }
        lastSentAt = now
        let machine = Host.current().localizedName ?? ProcessInfo.processInfo.hostName
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy, HH:mm"
        let message = "\(machine) unlocked — \(formatter.string(from: now))"
        sendMessage(message, to: config.recipient)
    }
}
