import Foundation

func sendMessage(_ text: String, to recipient: String) {
    let script = "tell application \"Messages\" to send \"\(text)\" to buddy \"\(recipient)\""
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
    process.arguments = ["-e", script]

    let pipe = Pipe()
    process.standardError = pipe

    do {
        try process.run()
        process.waitUntilExit()
        if process.terminationStatus != 0 {
            let errData = pipe.fileHandleForReading.readDataToEndOfFile()
            let errText = String(data: errData, encoding: .utf8) ?? ""
            log("osascript error (status \(process.terminationStatus)): \(errText.trimmingCharacters(in: .whitespacesAndNewlines))")
        } else {
            log("sent to \(recipient)")
        }
    } catch {
        log("failed to launch osascript: \(error)")
    }
}

func log(_ message: String) {
    let ts = ISO8601DateFormatter().string(from: Date())
    print("[\(ts)] [knockknock] \(message)")
    fflush(stdout)
}
