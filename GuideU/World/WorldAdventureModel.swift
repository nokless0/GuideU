import Foundation
import Combine
import CoreGraphics

enum WorldMission: String, CaseIterable, Identifiable {
    case notebook, picnic, leaves

    var id: String { rawValue }

    var title: String {
        switch self {
        case .notebook: return "El cuaderno perdido"
        case .picnic: return "Un picnic tranquilo"
        case .leaves: return "Explorador del parque"
        }
    }

    var details: String {
        switch self {
        case .notebook: return "Busca el cuaderno cerca de la plaza y llévalo a la escuela."
        case .picnic: return "Recoge la manzana cerca de la tienda y llévala al parque."
        case .leaves: return "Encuentra las tres hojas brillantes del parque."
        }
    }

    var symbol: String {
        switch self {
        case .notebook: return "book.closed.fill"
        case .picnic: return "basket.fill"
        case .leaves: return "leaf.fill"
        }
    }
}

/// Estado del mapa. Los objetos y las misiones se guardan por separado de los retos antiguos.
final class WorldAdventureModel: ObservableObject {
    @Published private(set) var collectedIDs: Set<String>
    @Published private(set) var nearbyPlace: WorldPlace?
    @Published var message: String = "¡Bienvenido! Toca el mapa para caminar o usa las flechas."
    var onMissionCompleted: ((WorldMission) -> Void)?

    let scene: TownScene

    private let key = "GuideU.world.collectedItems"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        collectedIDs = Set(defaults.stringArray(forKey: key) ?? [])
        scene = TownScene(size: TownScene.mapSize)
        scene.scaleMode = .resizeFill
        scene.collectedIDs = collectedIDs

        scene.onCollect = { [weak self] identifier in
            self?.collect(identifier)
        }
        scene.onNearbyChange = { [weak self] place in
            self?.nearbyPlace = place
        }
    }

    var leafCount: Int {
        ["leaf1", "leaf2", "leaf3"].filter { collectedIDs.contains($0) }.count
    }

    var hasNotebook: Bool { collectedIDs.contains("notebook") }
    var hasApple: Bool { collectedIDs.contains("apple") }

    func syncLeafMissionIfNeeded(isComplete: Bool) {
        if leafCount == 3 && !isComplete {
            onMissionCompleted?(.leaves)
        }
    }

    private func collect(_ id: String) {
        guard collectedIDs.insert(id).inserted else { return }
        defaults.set(Array(collectedIDs).sorted(), forKey: key)

        switch id {
        case "notebook":
            message = "¡Encontraste un cuaderno! Llévalo a la entrada de la escuela."
        case "apple":
            message = "¡Tienes una manzana! Camina hacia el parque para el picnic."
        case "leaf1", "leaf2", "leaf3":
            if leafCount == 3 {
                message = "¡Exploraste el parque y encontraste las tres hojas! Ganaste una estrella."
                onMissionCompleted?(.leaves)
            } else {
                message = "¡Una hoja brillante! Ya descubriste \(leafCount) de 3."
            }
        default:
            break
        }
    }

    func interact(completedMissions: Set<String>) {
        guard let place = nearbyPlace else {
            message = "Camina hasta uno de los círculos azules junto a los edificios o al parque."
            return
        }

        switch place {
        case .plaza:
            message = hasNotebook
                ? "Esta es la Plaza de Lumi. ¡Ya tienes el cuaderno! La escuela está al noroeste."
                : "Estás en la plaza. Explora cerca del camino para encontrar un cuaderno."
        case .school:
            if completedMissions.contains(WorldMission.notebook.id) {
                message = "¡Cuaderno entregado! Puedes volver a explorar cuando quieras."
            } else if hasNotebook {
                onMissionCompleted?(.notebook)
                message = "¡Entregaste el cuaderno en la escuela! Una estrella para tu colección."
            } else {
                message = "En la escuela necesitan un cuaderno. Busca uno en el camino de la plaza."
            }
        case .market:
            message = hasApple
                ? "¡Muy bien! Ahora lleva la manzana al parque, al sureste del mapa."
                : "Bienvenido a la tienda. Una manzana te espera cerca de la entrada."
        case .park:
            if completedMissions.contains(WorldMission.picnic.id) {
                message = "Este parque es un lugar tranquilo. Puedes pasear y explorar libremente."
            } else if hasApple {
                onMissionCompleted?(.picnic)
                message = "¡Preparaste un pequeño picnic en el parque! Ganaste una estrella."
            } else {
                message = "Bienvenido al parque. Aquí hay tres hojas para descubrir. También puedes traer una manzana de la tienda."
            }
        }
    }

    func reset() {
        collectedIDs.removeAll()
        defaults.removeObject(forKey: key)
        scene.resetExploration()
        message = "¡Comienza una nueva aventura! El mapa y las misiones están listos."
    }
}
