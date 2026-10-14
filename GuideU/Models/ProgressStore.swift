import Foundation
import Combine

/// Guarda únicamente identificadores de retos completados en este dispositivo.
final class ProgressStore: ObservableObject {
    @Published private(set) var completedIDs: Set<String>

    private let defaults: UserDefaults
    private let storageKey = "GuideU.completedChallengeIDs"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        completedIDs = Set(defaults.stringArray(forKey: storageKey) ?? [])
    }

    var completedCount: Int {
        ChallengeLibrary.all.filter { completedIDs.contains($0.id) }.count
    }

    var totalCount: Int { ChallengeLibrary.all.count }

    var stars: Int { completedCount }

    func isCompleted(_ challenge: Challenge) -> Bool {
        completedIDs.contains(challenge.id)
    }

    @discardableResult
    func complete(_ challenge: Challenge) -> Bool {
        let isNew = completedIDs.insert(challenge.id).inserted
        if isNew { save() }
        return isNew
    }

    func reset() {
        completedIDs.removeAll()
        save()
    }

    private func save() {
        defaults.set(Array(completedIDs).sorted(), forKey: storageKey)
    }
}
