import SwiftUI

private struct IntroPage {
    let symbol: String
    let title: String
    let description: String
    let detail: String
}

struct OnboardingView: View {
    let onFinish: () -> Void
    @State private var page = 0

    private let pages: [IntroPage] = [
        IntroPage(
            symbol: "sparkles",
            title: "¡Hola! Soy Lumi",
            description: "Te doy la bienvenida a GuideU, un espacio para aprender a tu ritmo.",
            detail: "Aquí puedes explorar, jugar y hacer pausas cuando quieras."
        ),
        IntroPage(
            symbol: "rectangle.stack.fill",
            title: "Descubre historias",
            description: "Practica situaciones de la escuela, la familia y otros lugares.",
            detail: "Hay diferentes maneras de comunicarse. Tú eliges."
        ),
        IntroPage(
            symbol: "puzzlepiece.fill",
            title: "Juguemos juntos",
            description: "Explora un pueblo en 2D, encuentra objetos y descubre nuevas misiones.",
            detail: "También hay retos y juegos cortos, sin reloj ni penalizaciones."
        ),
        IntroPage(
            symbol: "star.circle.fill",
            title: "Colecciona estrellas",
            description: "Descubre una estrella por cada actividad nueva que completes.",
            detail: "Puedes repetir cualquier actividad y cambiar el diseño en Ajustes."
        )
    ]

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                GuideUMascot(size: 34)
                Text("GuideU")
                    .font(.title2.bold())
                Spacer()
                Button("Omitir") { onFinish() }
                    .accessibilityHint("Ir directamente al inicio")
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)

            TabView(selection: $page) {
                ForEach(pages.indices, id: \.self) { index in
                    ScrollView {
                        VStack(spacing: 22) {
                            Spacer(minLength: 14)
                            Image(systemName: pages[index].symbol)
                                .font(.system(size: 72, weight: .medium))
                                .foregroundStyle(GuideUTheme.accent)
                                .frame(width: 142, height: 142)
                                .background(GuideUTheme.accent.opacity(0.10), in: Circle())
                                .accessibilityHidden(true)

                            Text(pages[index].title)
                                .font(.largeTitle.bold())
                                .multilineTextAlignment(.center)
                                .accessibilityAddTraits(.isHeader)

                            Text(pages[index].description)
                                .font(.title3)
                                .multilineTextAlignment(.center)

                            GuideUCard {
                                Label(pages[index].detail, systemImage: "heart.fill")
                                    .font(.body)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .multilineTextAlignment(.center)
                            }
                            Spacer(minLength: 20)
                        }
                        .frame(maxWidth: 650)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 24)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            HStack(spacing: 14) {
                if page > 0 {
                    Button("Anterior") { page -= 1 }
                        .buttonStyle(.bordered)
                        .frame(minHeight: 54)
                }

                Button {
                    if page == pages.count - 1 {
                        onFinish()
                    } else {
                        page += 1
                    }
                } label: {
                    PrimaryActionLabel(
                        title: page == pages.count - 1 ? "¡Vamos!" : "Siguiente",
                        symbol: "arrow.right"
                    )
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 18)
        }
        .background(GuideUTheme.background.ignoresSafeArea())
    }
}
