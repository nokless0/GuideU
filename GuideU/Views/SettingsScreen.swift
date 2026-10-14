import SwiftUI

struct SettingsScreen: View {
    @ObservedObject var progress: ProgressStore

    @AppStorage("GuideU.largeText") private var largeText = false
    @AppStorage("GuideU.showTips") private var showTips = true
    @AppStorage("GuideU.finishedOnboarding") private var finishedOnboarding = true
    @State private var confirmReset = false

    var body: some View {
        Form {
            Section {
                Toggle(isOn: $largeText) {
                    Label("Texto ampliado", systemImage: "textformat.size")
                }
                .accessibilityHint("Aumenta el tamaño de las letras")

                Toggle(isOn: $showTips) {
                    Label("Mostrar pistas", systemImage: "lightbulb.fill")
                }
                .accessibilityHint("Muestra una sugerencia en cada reto")
            } header: {
                Text("Preferencias")
            } footer: {
                Text("GuideU también respeta el tamaño de texto y VoiceOver de iOS.")
            }

            Section("Volver a empezar") {
                Button {
                    finishedOnboarding = false
                } label: {
                    Label("Ver introducción otra vez", systemImage: "arrow.counterclockwise")
                }

                Button(role: .destructive) {
                    confirmReset = true
                } label: {
                    Label("Borrar mis estrellas", systemImage: "trash")
                }
                .confirmationDialog(
                    "¿Quieres borrar las estrellas guardadas?",
                    isPresented: $confirmReset,
                    titleVisibility: .visible
                ) {
                    Button("Borrar progreso", role: .destructive) {
                        progress.reset()
                    }
                    Button("Cancelar", role: .cancel) {}
                } message: {
                    Text("Los retos seguirán disponibles. Esta acción no se puede deshacer.")
                }
            }

            Section("Acerca de GuideU") {
                LabeledContent("Versión", value: "1.0")
                Text("Prototipo educativo para practicar habilidades de comunicación y autonomía. No sustituye el acompañamiento de profesionales o familiares.")
                Text("Los avances y preferencias se guardan solo en este dispositivo. La app no requiere una cuenta ni recopila datos personales.")
            }
        }
        .navigationTitle("Ajustes")
    }
}
