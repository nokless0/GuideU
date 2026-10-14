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
