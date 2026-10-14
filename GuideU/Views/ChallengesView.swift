import SwiftUI

struct ChallengesListView: View {
    @ObservedObject var progress: ProgressStore
    @State private var selectedCategory: ChallengeCategory?

    init(progress: ProgressStore, initialCategory: ChallengeCategory? = nil) {
        self.progress = progress
        _selectedCategory = State(initialValue: initialCategory)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Practica cuando quieras. Puedes repetir los retos las veces que necesites.")
                    .foregroundStyle(.secondary)

                Menu {
                    Button("Todas las categorías") { selectedCategory = nil }
                    ForEach(ChallengeCategory.allCases) { category in
                        Button(category.title) { selectedCategory = category }
                    }
                } label: {
                    Label(selectedCategory?.title ?? "Todas las categorías",
                          systemImage: "line.3.horizontal.decrease.circle")
                        .font(.headline)
                        .padding(.vertical, 10)
                }
                .accessibilityHint("Filtra los retos por lugar")

                ForEach(ChallengeLibrary.forCategory(selectedCategory)) { challenge in
                    NavigationLink {
                        ChallengeDetailView(challenge: challenge, progress: progress)
                    } label: {
                        GuideUCard {
                            HStack(alignment: .top, spacing: 14) {
                                Image(systemName: challenge.symbol)
                                    .font(.title)
                                    .foregroundStyle(GuideUTheme.accent)
                                    .frame(width: 40)
                                    .accessibilityHidden(true)
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(challenge.title)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    CategoryPill(category: challenge.category)
                                    if progress.isCompleted(challenge) {
                                        Label("Completado", systemImage: "checkmark.seal.fill")
                                            .font(.subheadline.weight(.medium))
                                            .foregroundStyle(.green)
                                    } else {
                                        Text("Por practicar")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
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
            .padding(20)
        }
        .background(GuideUTheme.background)
        .navigationTitle("Retos")
    }
}

struct ChallengeDetailView: View {
    let challenge: Challenge
    @ObservedObject var progress: ProgressStore

    @AppStorage("GuideU.showTips") private var showTips = true
    @Environment(\.dismiss) private var dismiss
    @State private var selectedID: String?
    @State private var finished = false
    @State private var earnedNewStar = false

    private var selected: AnswerOption? {
        challenge.options.first { $0.id == selectedID }
    }

    var body: some View {
        ScrollView {
            if finished {
                resultContent
            } else {
                activityContent
            }
        }
        .background(GuideUTheme.background)
        .navigationTitle(finished ? "¡Lo lograste!" : "Practicar")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var activityContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                CategoryPill(category: challenge.category)
                Spacer()
                if progress.isCompleted(challenge) {
                    Label("Ya completado", systemImage: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Image(systemName: challenge.symbol)
                .font(.system(size: 56))
                .foregroundStyle(GuideUTheme.accent)
                .frame(maxWidth: .infinity)
                .accessibilityHidden(true)

            Text(challenge.title)
                .font(.title.bold())
                .accessibilityAddTraits(.isHeader)

            GuideUCard {
                VStack(alignment: .leading, spacing: 10) {
                    Label("Situación", systemImage: "text.book.closed.fill")
                        .font(.headline)
                    Text(challenge.situation)
                        .font(.title3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Text(challenge.question)
                .font(.title3.bold())
                .accessibilityAddTraits(.isHeader)

            VStack(spacing: 12) {
                ForEach(challenge.options) { option in
                    Button {
                        selectedID = option.id
                    } label: {
                        HStack(alignment: .center, spacing: 12) {
                            Image(systemName: selectedID == option.id
                                  ? "largecircle.fill.circle" : "circle")
                                .foregroundStyle(GuideUTheme.accent)
                                .accessibilityHidden(true)
                            Text(option.text)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.primary)
                            Spacer(minLength: 0)
                        }
                        .font(.body.weight(.medium))
                        .padding(16)
                        .frame(maxWidth: .infinity, minHeight: 58, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(GuideUTheme.card)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(selectedID == option.id
                                        ? GuideUTheme.accent : Color.clear,
                                        lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(option.text)
                    .accessibilityAddTraits(selectedID == option.id ? .isSelected : [])
                    .accessibilityHint("Escoge esta respuesta para ver la explicación")
                }
            }

            if let selected {
                GuideUCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Label(selected.helpful ? "¡Buena alternativa!" : "Pensemos en otra opción",
                              systemImage: selected.helpful ? "checkmark.circle.fill" : "lightbulb.fill")
                            .font(.headline)
                            .foregroundStyle(GuideUTheme.accent)
                        Text(selected.feedback)
                            .fixedSize(horizontal: false, vertical: true)
                        if !selected.helpful {
                            Text("Puedes elegir otra respuesta. Aquí aprendemos practicando.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .accessibilityElement(children: .combine)
            }

            if showTips {
                GuideUCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Una pista", systemImage: "lightbulb")
                            .font(.headline)
                        Text(challenge.tip)
                    }
                }
            }

            if selected?.helpful == true {
                Button {
                    earnedNewStar = progress.complete(challenge)
                    finished = true
                } label: {
                    PrimaryActionLabel(title: "Completar reto", symbol: "star.fill")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
    }

    private var resultContent: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 32)
            Image(systemName: "star.circle.fill")
                .font(.system(size: 88))
                .foregroundStyle(.yellow)
                .accessibilityHidden(true)
            Text("¡Buen trabajo!")
                .font(.largeTitle.bold())
                .accessibilityAddTraits(.isHeader)
            Text(earnedNewStar ? "Ganaste una estrella nueva." :
                 "Ya habías ganado la estrella de este reto.")
                .font(.title3)
                .multilineTextAlignment(.center)

            GuideUCard {
                VStack(alignment: .leading, spacing: 12) {
                    Label("Para la vida diaria", systemImage: "heart.text.square")
                        .font(.headline)
                    Text(challenge.practiceIdea)
                    Text("Tú decides cuándo y cómo practicar.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Button {
                dismiss()
            } label: {
                PrimaryActionLabel(title: "Volver", symbol: "arrow.left")
            }
            .buttonStyle(.borderedProminent)

            Button("Repetir este reto") {
                selectedID = nil
                finished = false
            }
            .buttonStyle(.bordered)
            .frame(minHeight: 50)

            Spacer(minLength: 20)
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
        .padding(22)
    }
}
