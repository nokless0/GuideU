import Foundation

enum MiniGameKind {
    case steps
    case matches

    var description: String {
        switch self {
        case .steps: return "Ordena los pasos"
        case .matches: return "Relaciona las ideas"
        }
    }
}

struct GameStep: Identifiable {
    let id: String
    let text: String
    let symbol: String
}

struct GamePair: Identifiable {
    let id: String
    let need: String
    let strategy: String
    let symbol: String
}

struct MiniGame: Identifiable {
    let id: String
    let title: String
    let summary: String
    let symbol: String
    let kind: MiniGameKind
    let steps: [GameStep]
    let pairs: [GamePair]
    let takeaway: String

    var taskCount: Int {
        switch kind {
        case .steps: return steps.count
        case .matches: return pairs.count
        }
    }
}

/// Las soluciones se presentan sin límite de tiempo ni castigos.
enum GameLibrary {
    static let all: [MiniGame] = [
        MiniGame(
            id: "pasos-ayuda",
            title: "Misión: pedir ayuda",
            summary: "Ordena cuatro pasos para pedir apoyo en clase.",
            symbol: "hands.sparkles.fill",
            kind: .steps,
            steps: [
                GameStep(id: "1", text: "Identifico qué parte no entendí.", symbol: "lightbulb"),
                GameStep(id: "2", text: "Busco a alguien que pueda ayudarme.", symbol: "person.crop.circle"),
                GameStep(id: "3", text: "Hago mi pregunta con palabras o señales.", symbol: "bubble.left"),
                GameStep(id: "4", text: "Escucho o leo la explicación.", symbol: "book")
            ],
            pairs: [],
            takeaway: "Pedir ayuda es válido. Puedes hablar, escribir o señalar."
        ),
        MiniGame(
            id: "pasos-descanso",
            title: "Mi plan de descanso",
            summary: "Construye un plan sencillo para tomar una pausa.",
            symbol: "leaf.fill",
            kind: .steps,
            steps: [
                GameStep(id: "1", text: "Noto que necesito descansar.", symbol: "heart"),
                GameStep(id: "2", text: "Comunico que quiero una pausa.", symbol: "hand.raised"),
                GameStep(id: "3", text: "Voy a un lugar que me resulte cómodo.", symbol: "house"),
                GameStep(id: "4", text: "Regreso cuando me siento listo, si quiero.", symbol: "checkmark.circle")
            ],
            pairs: [],
            takeaway: "Descansar no es fallar. Cada persona necesita pausas distintas."
        ),
        MiniGame(
            id: "pasos-plan",
            title: "Un cambio de planes",
            summary: "Organiza una manera de afrontar una sorpresa.",
            symbol: "map.fill",
            kind: .steps,
            steps: [
                GameStep(id: "1", text: "Me entero de que cambió el plan.", symbol: "calendar"),
                GameStep(id: "2", text: "Pido información sobre lo que sigue.", symbol: "questionmark.circle"),
                GameStep(id: "3", text: "Tomo un momento para adaptarme.", symbol: "clock"),
                GameStep(id: "4", text: "Elijo qué hacer o pido apoyo.", symbol: "checkmark.seal")
            ],
            pairs: [],
            takeaway: "Está bien que los cambios te cuesten. Pedir tiempo ayuda."
        ),
        MiniGame(
            id: "parejas-escuela",
            title: "Detective de soluciones",
            summary: "Relaciona situaciones escolares con ideas útiles.",
            symbol: "magnifyingglass.circle.fill",
            kind: .matches,
            steps: [],
            pairs: [
                GamePair(id: "a", need: "No entendí la tarea.", strategy: "Pido otro ejemplo.", symbol: "book.closed"),
                GamePair(id: "b", need: "Quiero participar en un juego.", strategy: "Pregunto si puedo unirme.", symbol: "gamecontroller"),
                GamePair(id: "c", need: "Hay demasiado ruido.", strategy: "Pido un espacio más tranquilo.", symbol: "ear.badge.waveform")
            ],
            takeaway: "Hay muchas formas de expresar lo que necesitas."
        ),
        MiniGame(
            id: "parejas-familia",
            title: "Mi caja de herramientas",
            summary: "Elige ideas para comunicar tus preferencias.",
            symbol: "shippingbox.fill",
            kind: .matches,
            steps: [],
            pairs: [
                GamePair(id: "a", need: "No quiero un abrazo.", strategy: "Propongo saludar con la mano.", symbol: "hand.raised"),
                GamePair(id: "b", need: "Cambiaron los planes.", strategy: "Pregunto cuál es el nuevo plan.", symbol: "calendar.badge.clock"),
                GamePair(id: "c", need: "Quiero estar solo un rato.", strategy: "Pido un momento de tranquilidad.", symbol: "moon.stars")
            ],
            takeaway: "Puedes comunicar tus límites y tus preferencias con respeto."
        ),
        MiniGame(
            id: "parejas-comunidad",
            title: "Exploradores tranquilos",
            summary: "Relaciona necesidades con estrategias al salir.",
            symbol: "safari.fill",
            kind: .matches,
            steps: [],
            pairs: [
                GamePair(id: "a", need: "No encuentro la fila.", strategy: "Pregunto dónde comienza.", symbol: "person.2"),
                GamePair(id: "b", need: "No sé qué haremos después.", strategy: "Pido que me expliquen el plan.", symbol: "list.bullet"),
                GamePair(id: "c", need: "Necesito descansar durante la salida.", strategy: "Se lo digo a mi acompañante.", symbol: "figure.walk")
            ],
            takeaway: "Conocer las opciones puede hacer más cómoda una salida."
        )
    ]
}
