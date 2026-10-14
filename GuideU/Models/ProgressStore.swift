import Foundation
import Combine

/// Conserva el progreso únicamente en el dispositivo. Mantiene los retos de la versión 1.
final class ProgressStore: ObservableObject {
    @Published private(set) var completedIDs: Set<String>
    @Published private(set) var completedGameIDs: Set<String>

    private let defaults: UserDefaults
    private let challengeKey = "GuideU.completedChallengeIDs"
    private let gameKey = "GuideU.completedMiniGameIDs"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        completedIDs = Set(defaults.stringArray(forKey: challengeKey) ?? [])
        completedGameIDs = Set(defaults.stringArray(forKey: gameKey) ?? [])
    }

    var completedCount: Int {
        ChallengeLibrary.all.filter { completedIDs.contains($0.id) }.count
    }

    var totalCount: Int { ChallengeLibrary.all.count }
    var completedGameCount: Int { GameLibrary.all.filter { completedGameIDs.contains($0.id) }.count }
    var gameCount: Int { GameLibrary.all.count }
    var stars: Int { completedCount + completedGameCount }
    var totalActivities: Int { totalCount + gameCount }
    var completedActivities: Int { completedCount + completedGameCount }

    func isCompleted(_ challenge: Challenge) -> Bool { completedIDs.contains(challenge.id) }
    func isCompleted(_ game: MiniGame) -> Bool { completedGameIDs.contains(game.id) }

    @discardableResult
    func complete(_ challenge: Challenge) -> Bool {
        let added = completedIDs.insert(challenge.id).inserted
        if added { save() }
        return added
    }

    @discardableResult
    func complete(_ game: MiniGame) -> Bool {
        let added = completedGameIDs.insert(game.id).inserted
        if added { save() }
        return added
    }

    func reset() {
        completedIDs.removeAll()
        completedGameIDs.removeAll()
        save()
    }

    private func save() {
        defaults.set(Array(completedIDs).sorted(), forKey: challengeKey)
        defaults.set(Array(completedGameIDs).sorted(), forKey: gameKey)
    }
}
