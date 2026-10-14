import Foundation
import Combine

/// Guarda el progreso local y conserva las claves de versiones anteriores.
final class ProgressStore: ObservableObject {
    @Published private(set) var completedIDs: Set<String>
    @Published private(set) var completedGameIDs: Set<String>
    @Published private(set) var completedWorldIDs: Set<String>

    private let defaults: UserDefaults
    private let challengeKey = "GuideU.completedChallengeIDs"
    private let gameKey = "GuideU.completedMiniGameIDs"
    private let worldKey = "GuideU.world.completedMissions"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        completedIDs = Set(defaults.stringArray(forKey: challengeKey) ?? [])
        completedGameIDs = Set(defaults.stringArray(forKey: gameKey) ?? [])
        completedWorldIDs = Set(defaults.stringArray(forKey: worldKey) ?? [])
    }

    var completedCount: Int {
        ChallengeLibrary.all.filter { completedIDs.contains($0.id) }.count
    }

    var totalCount: Int { ChallengeLibrary.all.count }
    var completedGameCount: Int { GameLibrary.all.filter { completedGameIDs.contains($0.id) }.count }
    var gameCount: Int { GameLibrary.all.count }
    var worldMissionCount: Int { WorldMission.allCases.count }
    var completedWorldCount: Int {
        WorldMission.allCases.filter { completedWorldIDs.contains($0.id) }.count
    }
    var stars: Int { completedCount + completedGameCount + completedWorldCount }
    var totalActivities: Int { totalCount + gameCount + worldMissionCount }
    var completedActivities: Int { stars }

    func isCompleted(_ challenge: Challenge) -> Bool { completedIDs.contains(challenge.id) }
    func isCompleted(_ game: MiniGame) -> Bool { completedGameIDs.contains(game.id) }
    func isWorldCompleted(_ mission: WorldMission) -> Bool { completedWorldIDs.contains(mission.id) }

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

    @discardableResult
    func completeWorldMission(_ mission: WorldMission) -> Bool {
        let added = completedWorldIDs.insert(mission.id).inserted
        if added { save() }
        return added
    }

    func resetWorldMissions() {
        completedWorldIDs.removeAll()
        defaults.removeObject(forKey: "GuideU.world.collectedItems")
        save()
    }

    func reset() {
        completedIDs.removeAll()
        completedGameIDs.removeAll()
        completedWorldIDs.removeAll()
        defaults.removeObject(forKey: "GuideU.world.collectedItems")
        save()
    }

    private func save() {
        defaults.set(Array(completedIDs).sorted(), forKey: challengeKey)
        defaults.set(Array(completedGameIDs).sorted(), forKey: gameKey)
        defaults.set(Array(completedWorldIDs).sorted(), forKey: worldKey)
    }
}
