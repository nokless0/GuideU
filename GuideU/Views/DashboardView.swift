import SwiftUI

struct DashboardView: View {
    @ObservedObject var progress: ProgressStore

    private var suggestedChallenge: Challenge {
        ChallengeLibrary.all.first { !progress.isCompleted($0) }
            ?? ChallengeLibrary.all[0]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                HStack(alignment: .center, spacing: 16) {
                    Image(systemName: "hand.wave.circle.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(GuideUTheme.accent)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("¡Bienvenido a GuideU!")
                            .font(.title.bold())
                            .accessibilityAddTraits(.isHeader)
                        Text("Aprende a tu propio ritmo.")
                            .foregroundStyle(.secondary)
                    }
                }

                GuideUCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Tus avances", systemImage: "star.fill")
                            .font(.headline)
                            .foregroundStyle(GuideUTheme.accent)
                        Text("\(progress.completedCount) de \(progress.totalCount) retos completados")
                            .font(.title3.bold())
                        ProgressView(value: Double(progress.completedCount),
                                     total: Double(progress.totalCount))
                            .accessibilityLabel("Avance general")
                            .accessibilityValue("\(progress.completedCount) de \(progress.totalCount)")
                        Text("¡Cada reto completado suma una estrella!")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Un reto para ti")
                        .font(.title2.bold())
                        .accessibilityAddTraits(.isHeader)
                    NavigationLink {
                        ChallengeDetailView(challenge: suggestedChallenge, progress: progress)
                    } label: {
                        GuideUCard {
                            HStack(spacing: 14) {
                                Image(systemName: suggestedChallenge.symbol)
                                    .font(.largeTitle)
                                    .foregroundStyle(GuideUTheme.accent)
                                    .frame(width: 48)
                                    .accessibilityHidden(true)
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(suggestedChallenge.title)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    Text(suggestedChallenge.category.title)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer(minLength: 4)
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                                    .accessibilityHidden(true)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint("Abre el reto recomendado")
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Elige dónde practicar")
                        .font(.title2.bold())
                        .accessibilityAddTraits(.isHeader)
                    ForEach(ChallengeCategory.allCases) { category in
                        NavigationLink {
                            ChallengesListView(progress: progress, initialCategory: category)
                        } label: {
                            GuideUCard {
                                HStack(spacing: 14) {
                                    Image(systemName: category.symbol)
                                        .font(.title2)
                                        .foregroundStyle(GuideUTheme.accent)
                                        .frame(width: 38)
                                        .accessibilityHidden(true)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(category.title)
                                            .font(.headline)
                                            .foregroundStyle(.primary)
                                        Text(category.description)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer(minLength: 2)
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                        .accessibilityHidden(true)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(20)
        }
        .background(GuideUTheme.background)
        .navigationTitle("Inicio")
    }
}
