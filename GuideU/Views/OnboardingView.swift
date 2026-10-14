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
            symbol: "hand.wave.fill",
            title: "¡Hola! Soy GuideU",
            description: "Aquí puedes practicar situaciones cotidianas a tu propio ritmo.",
            detail: "No hay prisa: cada pequeño paso cuenta."
        ),
        IntroPage(
            symbol: "rectangle.stack.fill",
            title: "Explora los retos",
            description: "Elige situaciones de la escuela, la familia y otros lugares.",
            detail: "Puedes repetir cualquier actividad cuando quieras."
        ),
        IntroPage(
            symbol: "text.bubble.fill",
            title: "Elige tu respuesta",
            description: "Lee una historia, piensa qué harías y recibe una explicación amable.",
            detail: "A veces hay más de una buena respuesta."
        ),
        IntroPage(
            symbol: "star.circle.fill",
            title: "Celebra tus avances",
            description: "Consigue una estrella por cada reto diferente que completes.",
            detail: "Puedes cambiar el tamaño del texto en Ajustes."
        )
    ]

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundStyle(GuideUTheme.accent)
                Text("GuideU")
                    .font(.title2.bold())
                Spacer()
                Button("Omitir") { onFinish() }
                    .accessibilityHint("Ir directamente al inicio")
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            TabView(selection: $page) {
                ForEach(pages.indices, id: \.self) { index in
                    ScrollView {
                        VStack(spacing: 22) {
                            Spacer(minLength: 20)
                            Image(systemName: pages[index].symbol)
                                .font(.system(size: 76, weight: .medium))
                                .foregroundStyle(GuideUTheme.accent)
                                .accessibilityHidden(true)
                            Text(pages[index].title)
                                .font(.largeTitle.bold())
                                .multilineTextAlignment(.center)
                                .accessibilityAddTraits(.isHeader)
                            Text(pages[index].description)
                                .font(.title3)
                                .multilineTextAlignment(.center)
                            GuideUCard {
                                Text(pages[index].detail)
                                    .font(.body)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.center)
                            }
                            Spacer(minLength: 20)
                        }
                        .padding(.horizontal, 28)
                        .frame(maxWidth: .infinity)
                    }
                    .tag(index)
                    .accessibilityElement(children: .contain)
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
                        title: page == pages.count - 1 ? "Empezar" : "Siguiente",
                        symbol: "arrow.right"
                    )
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        .background(GuideUTheme.background)
    }
}
