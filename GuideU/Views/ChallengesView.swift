import SwiftUI

struct ChallengesListView: View {
    @ObservedObject var progress: ProgressStore
    @State private var selectedCategory: ChallengeCategory?
    private let columns = [GridItem(.adaptive(minimum: 260), spacing: 14)]

    init(progress: ProgressStore, initialCategory: ChallengeCategory? = nil) {
        self.progress = progress
        _selectedCategory = State(initialValue: initialCategory)
    }

    var body: some View {
        GuideUPage {
            VStack(alignment: .leading, spacing: 22) {
                GuideUHero {
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("HISTORIAS INTERACTIVAS")
                                .font(.caption.bold())
                                .tracking(1)
                                .foregroundStyle(GuideUTheme.accent)
                            Text("Mis retos")
                                .font(.largeTitle.bold())
                                .accessibilityAddTraits(.isHeader)
                            Text("Descubre estrategias para situaciones reales, a tu ritmo.")
                                .foregroundStyle(.secondary)
                        }
                        Spacer(minLength: 4)
                        Image(systemName: "books.vertical.circle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(GuideUTheme.accent)
                            .accessibilityHidden(true)
                    }
                }

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

                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(ChallengeLibrary.forCategory(selectedCategory)) { challenge in
                        NavigationLink {
                            ChallengeDetailView(challenge: challenge, progress: progress)
                        } label: {
                            GuideUCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: challenge.symbol)
                                            .font(.system(size: 27))
                                            .foregroundStyle(GuideUTheme.accent)
                                            .frame(width: 60, height: 60)
                                            .background(GuideUTheme.accent.opacity(0.10),
                                                        in: RoundedRectangle(cornerRadius: 18))
                                            .accessibilityHidden(true)
                                        Spacer()
                                        if progress.isCompleted(challenge) {
                                            Label("Listo", systemImage: "checkmark.seal.fill")
                                                .font(.caption.bold())
                                                .foregroundStyle(GuideUTheme.mint)
                                        }
                                    }
                                    CategoryPill(category: challenge.category)
                                    Text(challenge.title)
                                        .font(.title3.bold())
                                        .foregroundStyle(.primary)
                                        .multilineTextAlignment(.leading)
                                    Label("Explorar historia", systemImage: "arrow.right")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(GuideUTheme.accent)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
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
        GuideUPage {
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

            GuideUHero {
                HStack(spacing: 16) {
                    Image(systemName: challenge.symbol)
                        .font(.system(size: 48))
                        .foregroundStyle(GuideUTheme.accent)
                        .frame(width: 68)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("UNA HISTORIA PARA TI")
                            .font(.caption.bold())
                            .foregroundStyle(GuideUTheme.accent)
                        Text(challenge.title)
                            .font(.title.bold())
                            .accessibilityAddTraits(.isHeader)
                    }
                    Spacer(minLength: 0)
                }
            }

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
                                .fill(Color(uiColor: .secondarySystemGroupedBackground))
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
            GuideUMascot(size: 108)
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
