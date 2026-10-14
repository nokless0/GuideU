import SwiftUI

struct ProgressScreen: View {
    @ObservedObject var progress: ProgressStore

    private var finishedChallenges: [Challenge] {
        ChallengeLibrary.all.filter { progress.isCompleted($0) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                GuideUCard {
                    VStack(spacing: 12) {
                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 66))
                            .foregroundStyle(.yellow)
                            .accessibilityHidden(true)
                        Text("\(progress.stars) estrellas")
                            .font(.largeTitle.bold())
                        Text("\(progress.completedCount) de \(progress.totalCount) retos diferentes")
                            .foregroundStyle(.secondary)
                        ProgressView(value: Double(progress.completedCount),
                                     total: Double(progress.totalCount))
                            .accessibilityLabel("Retos completados")
                            .accessibilityValue("\(progress.completedCount) de \(progress.totalCount)")
                    }
                    .frame(maxWidth: .infinity)
                }

                Text("Retos que ya practicaste")
                    .font(.title2.bold())
                    .accessibilityAddTraits(.isHeader)

                if finishedChallenges.isEmpty {
                    GuideUCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Tu aventura comienza aquí", systemImage: "sparkles")
                                .font(.headline)
                            Text("Cuando completes tu primer reto, aparecerá en esta pantalla.")
                                .foregroundStyle(.secondary)
                        }
                    }
                } else {
                    ForEach(finishedChallenges) { challenge in
                        NavigationLink {
                            ChallengeDetailView(challenge: challenge, progress: progress)
                        } label: {
                            GuideUCard {
                                HStack(spacing: 12) {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundStyle(.green)
                                        .accessibilityHidden(true)
                                    Text(challenge.title)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                        .accessibilityHidden(true)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }

                Text("No necesitas hacerlo todo de una vez. Repetir y descansar también forma parte del aprendizaje.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(20)
        }
        .background(GuideUTheme.background)
        .navigationTitle("Mi progreso")
    }
}
