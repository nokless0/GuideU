import SwiftUI

struct ContentView: View {
    @AppStorage("largeText") private var largeText = false

    var body: some View {
        NavigationStack {
            WelcomeView()
        }
        .modifier(LargeTextModifier(enabled: largeText))
    }
}

// MARK: - Texto grande

struct LargeTextModifier: ViewModifier {
    let enabled: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if enabled {
            content
                .dynamicTypeSize(.accessibility2)
        } else {
            content
        }
    }
}

// MARK: - Pantalla de bienvenida

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 25) {
            Spacer()

            Image(systemName: "person.2.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.indigo)
                .accessibilityHidden(true)

            Text("GuideU")
                .font(.largeTitle)
                .bold()
                .accessibilityAddTraits(.isHeader)

            Text("Aprende a enfrentar situaciones sociales paso a paso.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("Practica situaciones sencillas de la escuela y la familia.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            NavigationLink {
                HomeView()
            } label: {
                Label("Comenzar", systemImage: "arrow.right.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 56)
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
            .accessibilityLabel("Comenzar GuideU")
            .accessibilityHint("Abre la pantalla principal de la aplicación")

            Spacer()
        }
        .padding(30)
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Pantalla de inicio

struct HomeView: View {
    var body: some View {
        VStack(spacing: 25) {
            Image(systemName: "house.circle.fill")
                .font(.system(size: 65))
                .foregroundStyle(.indigo)
                .accessibilityHidden(true)

            Text("¿Qué quieres hacer?")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            Text("Puedes practicar una situación social o cambiar las opciones de accesibilidad.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            NavigationLink {
                ActivityView()
            } label: {
                Label("Practicar un reto", systemImage: "person.2.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 56)
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
            .accessibilityLabel("Practicar un reto social")
            .accessibilityHint("Abre una situación social para practicar")

            NavigationLink {
                SettingsView()
            } label: {
                Label("Ajustes", systemImage: "gearshape.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 56)
            }
            .buttonStyle(.bordered)
            .tint(.indigo)
            .accessibilityLabel("Abrir ajustes")
            .accessibilityHint("Permite modificar opciones de accesibilidad")

            Spacer()
        }
        .padding(30)
        .navigationTitle("Inicio")
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Pantalla de actividad

struct ActivityView: View {
    @State private var feedbackMessage = ""
    @State private var isCorrect = false

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                Image(systemName: "person.wave.2.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.indigo)
                    .accessibilityHidden(true)

                Text("Situación")
                    .font(.title)
                    .bold()
                    .accessibilityAddTraits(.isHeader)

                VStack(spacing: 12) {
                    Text("Estás llegando a tu salón.")
                        .font(.headline)

                    Text("Un compañero te mira y dice:")
                        .font(.body)

                    Text("“Hola, buenos días.”")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(.secondarySystemGroupedBackground))
                )

                Text("¿Qué podrías hacer?")
                    .font(.headline)
                    .padding(.top)

                answerButton(
                    title: "Saludarlo",
                    icon: "hand.wave.fill",
                    correct: true
                )

                answerButton(
                    title: "Gritarle",
                    icon: "speaker.wave.3.fill",
                    correct: false
                )

                answerButton(
                    title: "Darle la espalda",
                    icon: "arrow.uturn.backward.circle.fill",
                    correct: false
                )

                if !feedbackMessage.isEmpty {
                    VStack(spacing: 10) {
                        Image(
                            systemName:
                                isCorrect
                                ? "checkmark.circle.fill"
                                : "arrow.clockwise.circle.fill"
                        )
                        .font(.largeTitle)
                        .foregroundStyle(isCorrect ? .green : .orange)

                        Text(feedbackMessage)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(.secondarySystemGroupedBackground))
                    )
                }

                if isCorrect {
                    NavigationLink {
                        ResultView()
                    } label: {
                        Label(
                            "Continuar",
                            systemImage: "arrow.right.circle.fill"
                        )
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 56)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)
                    .accessibilityLabel("Continuar al resultado")
                }
            }
            .padding(25)
        }
        .navigationTitle("Reto")
        .background(Color(.systemGroupedBackground))
    }

    private func answerButton(
        title: String,
        icon: String,
        correct: Bool
    ) -> some View {
        Button {
            if correct {
                isCorrect = true
                feedbackMessage =
                    "¡Muy bien! Saludar es una forma amable de responder."
            } else {
                isCorrect = false
                feedbackMessage =
                    "Inténtalo de nuevo. Piensa en una respuesta amable."
            }
        } label: {
            Label(title, systemImage: icon)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 56)
        }
        .buttonStyle(.bordered)
        .tint(.indigo)
        .accessibilityLabel("Opción: \(title)")
        .accessibilityHint("Selecciona esta respuesta")
    }
}

// MARK: - Pantalla de resultado

struct ResultView: View {
    var body: some View {
        VStack(spacing: 25) {
            Spacer()

            Image(systemName: "star.circle.fill")
                .font(.system(size: 85))
                .foregroundStyle(.yellow)
                .accessibilityHidden(true)

            Text("¡Muy bien!")
                .font(.largeTitle)
                .bold()
                .accessibilityAddTraits(.isHeader)

            Text("Completaste el reto.")
                .font(.title2)

            Text(
                "Saludar puede ser una forma sencilla y amable de comenzar una interacción con otra persona."
            )
            .font(.body)
            .multilineTextAlignment(.center)
            .padding(.horizontal)

            NavigationLink {
                HomeView()
            } label: {
                Label(
                    "Volver al inicio",
                    systemImage: "house.fill"
                )
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 56)
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
            .accessibilityLabel("Volver a la pantalla de inicio")

            Spacer()
        }
        .padding(30)
        .navigationTitle("Resultado")
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Pantalla de ajustes

struct SettingsView: View {
    @AppStorage("largeText") private var largeText = false

    var body: some View {
        Form {
            Section {
                Toggle(
                    "Texto ampliado",
                    isOn: $largeText
                )
                .accessibilityLabel("Texto ampliado")
                .accessibilityHint(
                    "Aumenta el tamaño del texto de GuideU"
                )
            } header: {
                Text("Accesibilidad")
            } footer: {
                Text(
                    "GuideU utiliza estilos de texto adaptables para facilitar la lectura."
                )
            }

            Section("Características") {
                Label(
                    "Botones grandes y separados",
                    systemImage: "hand.tap.fill"
                )

                Label(
                    "Etiquetas compatibles con VoiceOver",
                    systemImage: "speaker.wave.2.fill"
                )

                Label(
                    "Texto adaptable",
                    systemImage: "textformat.size"
                )

                Label(
                    "Iconos acompañados de texto",
                    systemImage: "photo.on.rectangle"
                )
            }
        }
        .navigationTitle("Ajustes")
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
