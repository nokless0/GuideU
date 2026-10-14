import SwiftUI

struct ProgressScreen: View {
    @ObservedObject var progress: ProgressStore

    private let columns = [GridItem(.adaptive(minimum: 68), spacing: 12)]

    private var finishedChallenges: [Challenge] {
        ChallengeLibrary.all.filter { progress.isCompleted($0) }
    }

    private var finishedGames: [MiniGame] {
        GameLibrary.all.filter { progress.isCompleted($0) }
    }

    var body: some View {
        GuideUPage {
            VStack(alignment: .leading, spacing: 22) {
                GuideUHero {
                    VStack(alignment: .center, spacing: 13) {
                        GuideUMascot(size: 88)
                        Text("Tu colección de estrellas")
                            .font(.title.bold())
                            .multilineTextAlignment(.center)
                            .accessibilityAddTraits(.isHeader)
                        Text("\(progress.stars) de \(progress.totalActivities) estrellas")
                            .font(.title3.bold())
                            .foregroundStyle(GuideUTheme.accent)
                        ProgressView(
                            value: Double(progress.completedActivities),
                            total: Double(progress.totalActivities)
                        )
                        .accessibilityLabel("Colección de estrellas")
                        .accessibilityValue("\(progress.stars) de \(progress.totalActivities)")
                        Text("No hay fecha límite. Vuelve cuando tengas ganas.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }

                SectionHeading(
                    title: "El cielo de Lumi",
                    subtitle: "Cada estrella representa una actividad diferente que exploraste."
                )
                GuideUCard {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(0..<progress.totalActivities, id: \.self) { index in
                            Image(systemName: index < progress.stars ? "star.fill" : "star")
                                .font(.system(size: 28))
                                .foregroundStyle(index < progress.stars ?
                                                 GuideUTheme.accent : Color.secondary)
                                .frame(maxWidth: .infinity, minHeight: 56)
                                .background(
                                    GuideUTheme.accent.opacity(index < progress.stars ? 0.09 : 0.03),
                                    in: RoundedRectangle(cornerRadius: 14)
                                )
                                .accessibilityLabel(index < progress.stars ?
                                                    "Estrella \(index + 1) conseguida" :
                                                    "Estrella \(index + 1) por descubrir")
                        }
                    }
                }

                HStack(spacing: 12) {
                    GuideUCard {
                        VStack(alignment: .leading, spacing: 7) {
                            Image(systemName: "books.vertical.fill")
                                .foregroundStyle(GuideUTheme.accent)
                            Text("Retos")
                                .font(.headline)
                            Text("\(progress.completedCount)/\(progress.totalCount)")
                                .font(.title2.bold().monospacedDigit())
                        }
                    }

                    GuideUCard {
                        VStack(alignment: .leading, spacing: 7) {
                            Image(systemName: "puzzlepiece.fill")
                                .foregroundStyle(GuideUTheme.mint)
                            Text("Juegos")
                                .font(.headline)
                            Text("\(progress.completedGameCount)/\(progress.gameCount)")
                                .font(.title2.bold().monospacedDigit())
                        }
                    }
                }

                SectionHeading(
                    title: "Lo que ya descubriste",
                    subtitle: "Puedes volver a cualquier actividad completada."
                )

                if finishedChallenges.isEmpty && finishedGames.isEmpty {
                    GuideUCard {
                        Label("Tu primera estrella te espera en Retos o Juegos.",
                              systemImage: "sparkles")
                            .font(.body)
                    }
                }

                ForEach(finishedGames) { game in
                    NavigationLink {
                        GameDetailView(game: game, progress: progress)
                    } label: {
                        completedRow(title: game.title, symbol: game.symbol, kind: "Juego")
                    }
                    .buttonStyle(.plain)
                }

                ForEach(finishedChallenges) { challenge in
                    NavigationLink {
                        ChallengeDetailView(challenge: challenge, progress: progress)
                    } label: {
                        completedRow(title: challenge.title, symbol: challenge.symbol, kind: "Reto")
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("Mis logros")
    }

    private func completedRow(title: String, symbol: String, kind: String) -> some View {
        GuideUCard {
            HStack(spacing: 12) {
                Image(systemName: symbol)
                    .font(.title2)
                    .foregroundStyle(GuideUTheme.accent)
                    .frame(width: 42)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    Text(kind)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                Spacer()
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(GuideUTheme.mint)
                    .accessibilityHidden(true)
            }
        }
    }
}
