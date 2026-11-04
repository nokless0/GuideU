import SwiftUI

struct GamesHubView: View {
    @ObservedObject var progress: ProgressStore
    private let columns = [GridItem(.adaptive(minimum: 255), spacing: 14)]

    var body: some View {
        GuideUPage {
            VStack(alignment: .leading, spacing: 22) {
                GuideUHero {
                    HStack(alignment: .center, spacing: 14) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("ZONA DE JUEGOS")
                                .font(.caption.bold())
                                .tracking(1)
                                .foregroundStyle(GuideUTheme.mint)
                            Text("Aprende jugando")
                                .font(.largeTitle.bold())
                                .accessibilityAddTraits(.isHeader)
                            Text("Misiones cortas, pistas cuando las necesites y sin reloj.")
                                .foregroundStyle(.secondary)
                        }
                        Spacer(minLength: 4)
                        Image(systemName: "puzzlepiece.extension.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(GuideUTheme.mint)
                            .accessibilityHidden(true)
                    }
                }

                NavigationLink {
                    WorldAdventureView(progress: progress)
                } label: {
                    GuideUHero {
                        HStack(spacing: 15) {
                            Image(systemName: "map.fill")
                                .font(.system(size: 37))
                                .foregroundStyle(GuideUTheme.mint)
                                .frame(width: 63, height: 63)
                                .background(GuideUTheme.mint.opacity(0.12),
                                            in: RoundedRectangle(cornerRadius: 17))
                                .accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: 7) {
                                Text("NUEVA AVENTURA 2D")
                                    .font(.caption.bold())
                                    .foregroundStyle(GuideUTheme.mint)
                                Text("Mi pequeño mundo")
                                    .font(.title2.bold())
                                    .foregroundStyle(.primary)
                                Text("Camina por un pueblo, encuentra objetos y cumple misiones.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.leading)
                                Label("Explorar el pueblo", systemImage: "arrow.right")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(GuideUTheme.mint)
                            }
                            Spacer(minLength: 0)
                        }
                    }
                }
                .buttonStyle(.plain)
                .accessibilityHint("Abre el videojuego de exploración")

                NavigationLink {
                    RoomTidyGameView(progress: progress)
                } label: {
                    GuideUHero {
                        HStack(spacing: 15) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(GuideUTheme.coral)
                                .frame(width: 63, height: 63)
                                .background(GuideUTheme.sunny.opacity(0.17),
                                            in: RoundedRectangle(cornerRadius: 19))
                                .accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: 7) {
                                Text("NUEVO • JUEGO DE ARRASTRAR")
                                    .font(.caption.bold())
                                    .foregroundStyle(GuideUTheme.coral)
                                Text("El cuarto de Lumi")
                                    .font(.title2.bold())
                                    .foregroundStyle(.primary)
                                Text("Ordena juguetes, útiles y ropa. ¡Tú preparas el espacio!")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.leading)
                                Label(progress.roomGameCompleted ? "Volver a jugar" : "¡Vamos a ordenar!",
                                      systemImage: "arrow.right")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(GuideUTheme.coral)
                            }
                            Spacer(minLength: 0)
                        }
                    }
                }
                .buttonStyle(.plain)
                .accessibilityHint("Abre el juego de ordenar objetos arrastrando o tocando")

                Label("\(progress.completedGameCount) de \(progress.gameCount) juegos explorados",
                      systemImage: "star.circle.fill")
                    .font(.headline)
                    .foregroundStyle(GuideUTheme.mint)

                SectionHeading(
                    title: "Elige un juego",
                    subtitle: "Puedes cambiar de actividad o repetirla cuando quieras."
                )

                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(GameLibrary.all) { game in
                        NavigationLink {
                            GameDetailView(game: game, progress: progress)
                        } label: {
                            GuideUCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: game.symbol)
                                            .font(.system(size: 31))
                                            .foregroundStyle(GuideUTheme.mint)
                                            .frame(width: 60, height: 60)
                                            .background(GuideUTheme.mint.opacity(0.10),
                                                        in: RoundedRectangle(cornerRadius: 18))
                                            .accessibilityHidden(true)
                                        Spacer()
                                        if progress.isCompleted(game) {
                                            Label("Listo", systemImage: "checkmark.seal.fill")
                                                .font(.caption.bold())
                                                .foregroundStyle(GuideUTheme.mint)
                                        }
                                    }
                                    Text(game.kind.description)
                                        .font(.caption.weight(.medium))
                                        .foregroundStyle(.secondary)
                                    Text(game.title)
                                        .font(.title3.bold())
                                        .foregroundStyle(.primary)
                                    Text(game.summary)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.leading)
                                    Label("Abrir juego", systemImage: "arrow.right")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(GuideUTheme.mint)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .navigationTitle("Juegos")
    }
}

struct GameDetailView: View {
    let game: MiniGame
    @ObservedObject var progress: ProgressStore

    @Environment(\.dismiss) private var dismiss
    @State private var pickedSteps: [String] = []
    @State private var feedback = ""
    @State private var showHint = false
    @State private var currentPair = 0
    @State private var matchedPairs: Set<String> = []
    @State private var matchedCurrent = false
    @State private var finished = false
    @State private var earnedStar = false

    private var unorderedSteps: [GameStep] {
        Array(game.steps.reversed())
    }

    var body: some View {
        GuideUPage {
            if finished {
                resultScreen
            } else {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Label(game.kind.description, systemImage: "puzzlepiece.fill")
                            .font(.subheadline.bold())
                            .foregroundStyle(GuideUTheme.mint)
                        Spacer()
                        if progress.isCompleted(game) {
                            Label("Ya explorado", systemImage: "checkmark.seal.fill")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    GuideUHero {
                        VStack(alignment: .leading, spacing: 12) {
                            Image(systemName: game.symbol)
                                .font(.system(size: 48))
                                .foregroundStyle(GuideUTheme.mint)
                                .accessibilityHidden(true)
                            Text(game.title)
                                .font(.largeTitle.bold())
                                .accessibilityAddTraits(.isHeader)
                            Text(game.summary)
                                .foregroundStyle(.secondary)
                        }
                    }

                    switch game.kind {
                    case .steps: stepsContent
                    case .matches: matchesContent
                    }
                }
            }
        }
        .navigationTitle("Jugar")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var stepsContent: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("1. Toca los pasos en el orden que prefieras probar.")
                .font(.headline)

            GuideUCard {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Mi secuencia")
                            .font(.headline)
                        Spacer()
                        Text("\(pickedSteps.count)/\(game.steps.count)")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }

                    if pickedSteps.isEmpty {
                        Text("Aquí aparecerán tus pasos.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(Array(pickedSteps.enumerated()), id: \.offset) { index, stepID in
                            if let step = game.steps.first(where: { $0.id == stepID }) {
                                Label("\(index + 1). \(step.text)", systemImage: "checkmark.circle")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .accessibilityElement(children: .combine)
                            }
                        }
                        Button("Quitar el último paso") {
                            if !pickedSteps.isEmpty { pickedSteps.removeLast() }
                            feedback = ""
                        }
                        .font(.subheadline.weight(.medium))
                    }
                }
            }

            Text("2. Elige el siguiente paso")
                .font(.headline)

            ForEach(unorderedSteps) { step in
                if !pickedSteps.contains(step.id) {
                    Button {
                        pickedSteps.append(step.id)
                        feedback = ""
                        showHint = false
                    } label: {
                        GuideUCard {
                            HStack(spacing: 12) {
                                Image(systemName: step.symbol)
                                    .font(.title2)
                                    .foregroundStyle(GuideUTheme.mint)
                                    .frame(width: 36)
                                    .accessibilityHidden(true)
                                Text(step.text)
                                    .font(.body.weight(.medium))
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)
                                Spacer(minLength: 0)
                                Image(systemName: "plus.circle")
                                    .foregroundStyle(GuideUTheme.mint)
                                    .accessibilityHidden(true)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint("Añade este paso a tu secuencia")
                }
            }

            if !feedback.isEmpty {
                feedbackCard(feedback, symbol: "lightbulb")
            }

            if showHint, pickedSteps.count < game.steps.count {
                feedbackCard("Una posibilidad para seguir: \(game.steps[pickedSteps.count].text)",
                             symbol: "lightbulb.fill")
            }

            Button("Ver una pista") { showHint.toggle() }
                .buttonStyle(.bordered)
                .disabled(pickedSteps.count == game.steps.count)

            Button {
                if pickedSteps == game.steps.map(\.id) {
                    finishGame()
                } else {
                    feedback = "Esta secuencia se puede mejorar. Quita algunos pasos y vuelve a probar; no hay prisa."
                }
            } label: {
                PrimaryActionLabel(title: "Comprobar mis pasos", symbol: "checkmark.circle")
            }
            .buttonStyle(.borderedProminent)
            .tint(GuideUTheme.mint)
            .disabled(pickedSteps.count != game.steps.count)

            Button("Volver a empezar") {
                pickedSteps = []
                feedback = ""
                showHint = false
            }
            .frame(minHeight: 44)
        }
    }

    private var matchesContent: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("Situación \(currentPair + 1) de \(game.pairs.count)")
                    .font(.headline)
                Spacer()
                Text("Sin límite de tiempo")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: Double(currentPair),
                         total: Double(game.pairs.count))
                .tint(GuideUTheme.mint)
                .accessibilityLabel("Avance del juego")
                .accessibilityValue("\(currentPair) de \(game.pairs.count)")

            GuideUCard {
                VStack(alignment: .leading, spacing: 14) {
                    Image(systemName: game.pairs[currentPair].symbol)
                        .font(.system(size: 38))
                        .foregroundStyle(GuideUTheme.mint)
                        .accessibilityHidden(true)
                    Text("¿Qué podría ayudarme si...?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(game.pairs[currentPair].need)
                        .font(.title2.bold())
                        .accessibilityAddTraits(.isHeader)
                }
            }

            Text("Elige una herramienta")
                .font(.headline)

            ForEach(Array(game.pairs.reversed())) { pair in
                if !matchedPairs.contains(pair.id) {
                    Button {
                        if pair.id == game.pairs[currentPair].id {
                            matchedCurrent = true
                            matchedPairs.insert(pair.id)
                            feedback = "¡Encontraste una idea útil! También puede haber otras maneras de resolverlo."
                        } else {
                            matchedCurrent = false
                            feedback = "Esa idea podría servir en otra situación. Prueba otra opción."
                        }
                    } label: {
                        GuideUCard {
                            HStack(spacing: 12) {
                                Image(systemName: "bubble.left.and.bubble.right")
                                    .font(.title2)
                                    .foregroundStyle(GuideUTheme.mint)
                                    .accessibilityHidden(true)
                                Text(pair.strategy)
                                    .font(.body.weight(.medium))
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)
                                Spacer(minLength: 0)
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    .foregroundStyle(GuideUTheme.mint)
                                    .accessibilityHidden(true)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .disabled(matchedCurrent)
                }
            }

            if !feedback.isEmpty {
                feedbackCard(feedback,
                             symbol: matchedCurrent ? "checkmark.circle.fill" : "lightbulb")
            }

            if matchedCurrent {
                Button {
                    if currentPair == game.pairs.count - 1 {
                        finishGame()
                    } else {
                        currentPair += 1
                        feedback = ""
                        matchedCurrent = false
                    }
                } label: {
                    PrimaryActionLabel(
                        title: currentPair == game.pairs.count - 1 ? "Terminar juego" : "Siguiente situación",
                        symbol: "arrow.right"
                    )
                }
                .buttonStyle(.borderedProminent)
                .tint(GuideUTheme.mint)
            }
        }
    }

    private func feedbackCard(_ message: String, symbol: String) -> some View {
        GuideUCard {
            Label(message, systemImage: symbol)
                .font(.body.weight(.medium))
                .foregroundStyle(.primary)
                .accessibilityElement(children: .combine)
        }
    }

    private var resultScreen: some View {
        VStack(spacing: 22) {
            Spacer(minLength: 35)
            GuideUMascot(size: 106)
            Text("¡Misión completada!")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            Text(earnedStar ? "¡Descubriste una estrella nueva!" :
                 "¡Qué bien que practiques de nuevo!")
                .font(.title3)
                .multilineTextAlignment(.center)

            GuideUCard {
                VStack(alignment: .leading, spacing: 12) {
                    Label("Lo que descubriste", systemImage: "heart.text.square")
                        .font(.headline)
                    Text(game.takeaway)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Button {
                dismiss()
            } label: {
                PrimaryActionLabel(title: "Volver a los juegos", symbol: "arrow.left")
            }
            .buttonStyle(.borderedProminent)
            .tint(GuideUTheme.mint)

            Button("Repetir esta misión") {
                pickedSteps = []
                feedback = ""
                showHint = false
                currentPair = 0
                matchedPairs = []
                matchedCurrent = false
                finished = false
            }
            .buttonStyle(.bordered)
            .frame(minHeight: 44)

            Text("Puedes jugar tantas veces como quieras.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func finishGame() {
        earnedStar = progress.complete(game)
        finished = true
    }
}

 
// MARK: - El cuarto de Lumi
// Juego de organización de objetos: arrastrar y soltar, o tocar objeto y destino.
// La puntuación recompensa la exploración; no hay reloj, errores castigados ni compras.

private enum RoomZone: String, CaseIterable, Identifiable {
    case desk, toys, wardrobe

    var id: String { rawValue }

    var title: String {
        switch self {
        case .desk: return "Escritorio"
        case .toys: return "Caja de juegos"
        case .wardrobe: return "Armario"
        }
    }

    var symbol: String {
        switch self {
        case .desk: return "books.vertical.fill"
        case .toys: return "shippingbox.fill"
        case .wardrobe: return "door.left.hand.closed"
        }
    }

    var color: Color {
        switch self {
        case .desk: return GuideUTheme.sky
        case .toys: return GuideUTheme.coral
        case .wardrobe: return GuideUTheme.mint
        }
    }
}

private struct RoomObject: Identifiable {
    let id: String
    let title: String
    let symbol: String
    let zone: RoomZone

    static let all: [RoomObject] = [
        RoomObject(id: "cuaderno", title: "Cuaderno",
                   symbol: "book.closed.fill", zone: .desk),
        RoomObject(id: "lapices", title: "Lápices",
                   symbol: "pencil.tip.crop.circle", zone: .desk),
        RoomObject(id: "pelota", title: "Pelota",
                   symbol: "soccerball", zone: .toys),
        RoomObject(id: "peluche", title: "Peluche",
                   symbol: "teddybear.fill", zone: .toys),
        RoomObject(id: "sueter", title: "Suéter",
                   symbol: "sweater", zone: .wardrobe),
        RoomObject(id: "zapatos", title: "Zapatos",
                   symbol: "shoeprints.fill", zone: .wardrobe)
    ]
}

struct RoomTidyGameView: View {
    @ObservedObject var progress: ProgressStore
    @AppStorage("GuideU.showTips") private var showTips = true
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dismiss) private var dismiss
    @State private var placedIDs: Set<String> = []
    @State private var selectedID: String?
    @State private var message = "Toca un objeto y después su lugar, o arrástralo."
    @State private var finished = false
    @State private var earnedStar = false

    private let columns = [GridItem(.adaptive(minimum: 155), spacing: 12)]
    private let zoneColumns = [GridItem(.adaptive(minimum: 210), spacing: 12)]

    var body: some View {
        GuideUPage {
            VStack(alignment: .leading, spacing: 18) {
                GuideUHero {
                    HStack(spacing: 14) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("JUEGO INTERACTIVO")
                                .font(.caption.bold())
                                .foregroundStyle(GuideUTheme.coral)
                            Text("El cuarto de Lumi")
                                .font(.title.bold())
                                .accessibilityAddTraits(.isHeader)
                            Text("¡Ayuda a Lumi a dejar su cuarto listo para otra aventura!")
                                .foregroundStyle(.secondary)
                        }
                        Spacer(minLength: 0)
                        GuideUMascot(size: 78)
                    }
                }

                if finished {
                    GuideUHero {
                        VStack(spacing: 16) {
                            GuideUMascot(size: 105)
                            Text("¡Lo lograste!")
                                .font(.largeTitle.bold())
                            Text(earnedStar
                                 ? "¡Un cuarto ordenado y una estrella nueva!"
                                 : "¡Qué bien volver a practicar!")
                                .font(.title3)
                                .multilineTextAlignment(.center)
                            Text("Cada cosa tiene su lugar. Ordenar poquito a poquito también cuenta.")
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                            Button("Jugar de nuevo") { restart() }
                                .buttonStyle(.borderedProminent)
                                .tint(GuideUTheme.mint)
                                .frame(minHeight: 54)
                            Button("Volver a los juegos") { dismiss() }
                                .buttonStyle(.bordered)
                                .frame(minHeight: 48)
                        }
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    HStack {
                        Label("Mi cuarto", systemImage: "house.fill")
                            .font(.headline)
                        Spacer()
                        Text("\(placedIDs.count) / \(RoomObject.all.count) objetos")
                            .font(.headline.monospacedDigit())
                            .foregroundStyle(GuideUTheme.accent)
                    }
                    ProgressView(value: Double(placedIDs.count),
                                 total: Double(RoomObject.all.count))
                        .tint(GuideUTheme.mint)
                        .accessibilityLabel("Objetos ordenados")
                        .accessibilityValue("\(placedIDs.count) de \(RoomObject.all.count)")

                    SectionHeading(
                        title: "¿Dónde va cada cosa?",
                        subtitle: "Arrastra los objetos a estos lugares o tócales después de elegir uno."
                    )

                    LazyVGrid(columns: zoneColumns, spacing: 12) {
                        ForEach(RoomZone.allCases) { zone in
                            Button {
                                placeSelected(in: zone)
                            } label: {
                                roomZoneCard(zone)
                            }
                            .buttonStyle(.plain)
                            .dropDestination(for: String.self) { itemIDs, _ in
                                guard let id = itemIDs.first else { return false }
                                return place(id, in: zone)
                            }
                            .accessibilityLabel("\(zone.title). \(count(in: zone)) objetos guardados")
                            .accessibilityHint("Toca para guardar aquí el objeto seleccionado, o arrastra un objeto")
                        }
                    }

                    GuideUCard {
                        Label(message, systemImage: "bubble.left.fill")
                            .font(.body.weight(.medium))
                            .foregroundStyle(.primary)
                            .accessibilityAddTraits(.updatesFrequently)
                    }

                    SectionHeading(
                        title: "Objetos por ordenar",
                        subtitle: "Elige un objeto. No hay tiempo límite ni castigos."
                    )
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(RoomObject.all.filter { !placedIDs.contains($0.id) }) { item in
                            Button {
                                selectedID = item.id
                                message = "Elegiste \(item.title.lowercased()). ¿Dónde quieres guardarlo?"
                            } label: {
                                VStack(spacing: 12) {
                                    Image(systemName: item.symbol)
                                        .font(.system(size: 36, weight: .medium))
                                        .foregroundStyle(GuideUTheme.accent)
                                        .frame(height: 46)
                                        .accessibilityHidden(true)
                                    Text(item.title)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                }
                                .frame(maxWidth: .infinity, minHeight: 108)
                                .padding(12)
                                .background(
                                    selectedID == item.id
                                    ? GuideUTheme.sunny.opacity(0.24)
                                    : GuideUTheme.card,
                                    in: RoundedRectangle(cornerRadius: 20)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(selectedID == item.id
                                                      ? GuideUTheme.accent : GuideUTheme.border,
                                                      lineWidth: selectedID == item.id ? 3 : 1)
                                )
                            }
                            .buttonStyle(.plain)
                            .draggable(item.id)
                            .accessibilityLabel("\(item.title). \(selectedID == item.id ? "Seleccionado" : "Sin ordenar")")
                            .accessibilityHint("Toca y luego elige un lugar de arriba o mantén presionado para arrastrar")
                        }
                    }

                    if showTips, let selectedID,
                       let item = RoomObject.all.first(where: { $0.id == selectedID }) {
                        Label("Pista: \(item.title) puede ir en \(item.zone.title.lowercased()).",
                              systemImage: "lightbulb.fill")
                            .font(.subheadline)
                            .foregroundStyle(GuideUTheme.mint)
                    }

                    Button("Volver a empezar este cuarto") { restart() }
                        .buttonStyle(.bordered)
                        .frame(minHeight: 44)
                }
            }
        }
        .navigationTitle("El cuarto de Lumi")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func roomZoneCard(_ zone: RoomZone) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: zone.symbol)
                    .font(.system(size: 30, weight: .medium))
                    .foregroundStyle(zone.color)
                    .frame(width: 50, height: 50)
                    .background(zone.color.opacity(0.13),
                                in: RoundedRectangle(cornerRadius: 16))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 3) {
                    Text(zone.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text("\(count(in: zone)) de 2 guardados")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Divider()
            HStack(spacing: 8) {
                ForEach(RoomObject.all.filter { $0.zone == zone && placedIDs.contains($0.id) }) { item in
                    Label(item.title, systemImage: item.symbol)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary)
                        .padding(6)
                        .background(zone.color.opacity(0.12), in: Capsule())
                        .lineLimit(1)
                }
                if count(in: zone) == 0 {
                    Text("Aquí puedes guardar cosas")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
            }
            .frame(minHeight: 32)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 144, alignment: .leading)
        .background(GuideUTheme.card, in: RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .strokeBorder(zone.color.opacity(0.55), lineWidth: 2)
        )
    }

    private func count(in zone: RoomZone) -> Int {
        RoomObject.all.filter { $0.zone == zone && placedIDs.contains($0.id) }.count
    }

    private func placeSelected(in zone: RoomZone) {
        guard let selectedID else {
            message = "Elige primero un objeto de abajo."
            return
        }
        _ = place(selectedID, in: zone)
    }

    @discardableResult
    private func place(_ itemID: String, in zone: RoomZone) -> Bool {
        guard let item = RoomObject.all.first(where: { $0.id == itemID }),
              !placedIDs.contains(itemID) else { return false }

        guard item.zone == zone else {
            message = "Puedes probar otro lugar para \(item.title.lowercased())."
            return false
        }

        if reduceMotion {
            placedIDs.insert(itemID)
        } else {
            withAnimation(.easeInOut(duration: 0.20)) {
                _ = placedIDs.insert(itemID)
            }
        }
        selectedID = nil
        message = "¡Bien! \(item.title) ya está en \(zone.title.lowercased())."
        if placedIDs.count == RoomObject.all.count {
            earnedStar = progress.completeRoomGame()
            finished = true
        }
        return true
    }

    private func restart() {
        placedIDs = []
        selectedID = nil
        message = "Toca un objeto y después su lugar, o arrástralo."
        finished = false
        earnedStar = false
    }
}
