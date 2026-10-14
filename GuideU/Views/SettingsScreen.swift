import SwiftUI

struct SettingsScreen: View {
    @ObservedObject var progress: ProgressStore

    @AppStorage("GuideU.largeText") private var largeText = false
    @AppStorage("GuideU.showTips") private var showTips = true
    @AppStorage("GuideU.quietMode") private var quietMode = false
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
                .accessibilityHint("Muestra sugerencias durante los retos")
            } header: {
                Text("Lectura y ayuda")
            } footer: {
                Text("La app también respeta el tamaño de letra y VoiceOver configurados en iOS.")
            }

            Section {
                Toggle(isOn: $quietMode) {
                    Label("Diseño tranquilo", systemImage: "leaf")
                }
                .accessibilityHint("Reduce los adornos y simplifica el fondo de las tarjetas")
            } header: {
                Text("Comodidad visual")
            } footer: {
                Text("Los juegos no tienen música automática, cronómetros ni destellos. Se respeta Reducir movimiento de iOS.")
            }

            Section("Volver a empezar") {
                Button {
                    finishedOnboarding = false
                } label: {
                    Label("Ver la introducción otra vez", systemImage: "arrow.counterclockwise")
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
                    Text("Se borrarán las estrellas, las misiones del pueblo y los objetos encontrados. Esta acción no se puede deshacer.")
                }
            }

            Section("Acerca de GuideU") {
                LabeledContent("Versión", value: "3.0 — Mi pequeño mundo")
                Text("Lumi te acompaña a explorar situaciones cotidianas. Puedes practicar sin competir ni sentir presión.")
                Text("Prototipo educativo; no reemplaza el acompañamiento de familiares o profesionales.")
                Text("El progreso se guarda únicamente en este dispositivo. No necesitas cuenta ni conexión a internet.")
            }
        }
        .navigationTitle("Ajustes")
    }
}
