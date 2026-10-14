import SwiftUI

struct DashboardView: View {
    @ObservedObject var progress: ProgressStore

    private let columns = [GridItem(.adaptive(minimum: 260), spacing: 14)]

    private var suggestedChallenge: Challenge {
        ChallengeLibrary.all.first { !progress.isCompleted($0) }
            ?? ChallengeLibrary.all[0]
    }

    private var suggestedGame: MiniGame {
        GameLibrary.all.first { !progress.isCompleted($0) }
            ?? GameLibrary.all[0]
    }

    var body: some View {
        GuideUPage {
            VStack(alignment: .leading, spacing: 24) {
                GuideUHero {
                    VStack(alignment: .leading, spacing: 18) {
                        HStack(alignment: .top, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("UN ESPACIO PARA TI")
                                    .font(.caption.bold())
                                    .tracking(1.1)
                                    .foregroundStyle(GuideUTheme.accent)

                                Text("¡Hola! Soy Lumi")
                                    .font(.largeTitle.bold())
                                    .accessibilityAddTraits(.isHeader)

                                Text("¿Qué te gustaría descubrir hoy?")
                                    .font(.title3)
                            }
                            Spacer(minLength: 2)
                            GuideUMascot(size: 80)
                        }

                        Text("Practica, juega o descansa. Tú eliges el ritmo.")
                            .foregroundStyle(.secondary)

                        HStack(spacing: 10) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.orange)
                                .accessibilityHidden(true)
                            Text("\(progress.stars) estrellas ganadas")
                                .font(.headline)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(GuideUTheme.accent.opacity(0.08), in: Capsule())
                        .accessibilityElement(children: .combine)
                    }
                }

                NavigationLink {
                    WorldAdventureView(progress: progress)
                } label: {
                    GuideUHero {
                        HStack(spacing: 16) {
                            Image(systemName: "map.fill")
                                .font(.system(size: 37))
                                .foregroundStyle(GuideUTheme.mint)
                                .frame(width: 64, height: 64)
                                .background(GuideUTheme.mint.opacity(0.10),
                                            in: RoundedRectangle(cornerRadius: 18))
                                .accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: 7) {
                                Text("EXPLORA UN MUNDO NUEVO")
                                    .font(.caption.bold())
                                    .foregroundStyle(GuideUTheme.mint)
                                Text("Mi pequeño mundo")
                                    .font(.title2.bold())
                                    .foregroundStyle(.primary)
                                Text("Camina, recoge objetos y descubre misiones reales.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Label("Entrar al pueblo", systemImage: "arrow.right")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(GuideUTheme.mint)
                            }
                            Spacer(minLength: 0)
                        }
                    }
                }
                .buttonStyle(.plain)

                SectionHeading(
                    title: "Tu próxima aventura",
                    subtitle: "Dos formas de aprender, sin prisa."
                )

                LazyVGrid(columns: columns, spacing: 14) {
                    NavigationLink {
                        ChallengeDetailView(challenge: suggestedChallenge, progress: progress)
                    } label: {
                        NavigationFeatureCard(
                            title: suggestedChallenge.title,
                            description: "Explora una historia",
                            symbol: suggestedChallenge.symbol,
                            tint: GuideUTheme.accent,
                            action: "Ir al reto"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        GameDetailView(game: suggestedGame, progress: progress)
                    } label: {
                        NavigationFeatureCard(
                            title: suggestedGame.title,
                            description: suggestedGame.kind.description,
                            symbol: suggestedGame.symbol,
                            tint: GuideUTheme.mint,
                            action: "Jugar"
                        )
                    }
                    .buttonStyle(.plain)
                }

                GuideUCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("Mi recorrido", systemImage: "sparkles.rectangle.stack")
                                .font(.headline)
                            Spacer()
                            Text("\(progress.completedActivities)/\(progress.totalActivities)")
                                .font(.subheadline.monospacedDigit())
                                .foregroundStyle(.secondary)
                        }
                        ProgressView(
                            value: Double(progress.completedActivities),
                            total: Double(progress.totalActivities)
                        )
                        .tint(GuideUTheme.mint)
                        .accessibilityLabel("Actividades completadas")
                        .accessibilityValue("\(progress.completedActivities) de \(progress.totalActivities)")
                        Text("Cada actividad nueva te ayuda a descubrir otra estrategia.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                SectionHeading(
                    title: "Explora a tu manera",
                    subtitle: "Elige un lugar que conozcas o que quieras practicar."
                )

                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(ChallengeCategory.allCases) { category in
                        NavigationLink {
                            ChallengesListView(progress: progress, initialCategory: category)
                        } label: {
                            GuideUCard {
                                HStack(spacing: 12) {
                                    Image(systemName: category.symbol)
                                        .font(.title)
                                        .foregroundStyle(GuideUTheme.accent)
                                        .frame(width: 48)
                                        .accessibilityHidden(true)
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(category.title)
                                            .font(.headline)
                                            .foregroundStyle(.primary)
                                        Text(category.description)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer(minLength: 0)
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                        .accessibilityHidden(true)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }

                Text("Lumi te acompaña: puedes volver a practicar cualquier actividad cuando quieras.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            }
        }
        .navigationTitle("Inicio")
    }
}

struct NavigationFeatureCard: View {
    let title: String
    let description: String
    let symbol: String
    let tint: Color
    let action: String

    var body: some View {
        GuideUCard {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: symbol)
                    .font(.system(size: 30, weight: .medium))
                    .foregroundStyle(tint)
                    .frame(width: 62, height: 62)
                    .background(tint.opacity(0.10), in: RoundedRectangle(cornerRadius: 18))
                    .accessibilityHidden(true)
                Text(description.uppercased())
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Text(title)
                    .font(.title3.bold())
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                Label(action, systemImage: "arrow.right")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(tint)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }
}
