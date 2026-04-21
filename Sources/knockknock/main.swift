import Foundation

// main.swift top-level code is implicitly @MainActor in Swift 6.
let config = Config.load()
log("starting — recipient: \(config.recipient), cooldown: \(Int(config.cooldownSeconds))s")

let watcher = UnlockWatcher(config: config)
_ = watcher  // keep reference alive for the lifetime of the process

RunLoop.main.run()
