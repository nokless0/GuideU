import SwiftUI
import SpriteKit

/// Pantalla que une el juego SpriteKit con los controles y objetivos accesibles de SwiftUI.
struct WorldAdventureView: View {
    @ObservedObject var progress: ProgressStore
    @StateObject private var model = WorldAdventureModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var confirmRestart = false

    var body: some View {
        GuideUPage {
            VStack(alignment: .leading, spacing: 18) {
                GuideUHero {
                    HStack(spacing: 14) {
                        VStack(alignment: .leading, spacing: 7) {
                            Text("AVENTURA 2D")
                                .font(.caption.bold())
                                .foregroundStyle(GuideUTheme.mint)
                                .tracking(1)
                            Text("Mi pequeño mundo")
                                .font(.title.bold())
                                .accessibilityAddTraits(.isHeader)
                            Text("Recorre el pueblo, encuentra objetos y ayuda a sus habitantes.")
                                .foregroundStyle(.secondary)
                        }
                        Spacer(minLength: 0)
                        Image(systemName: "map.fill")
                            .font(.system(size: 43))
                            .foregroundStyle(GuideUTheme.mint)
                            .accessibilityHidden(true)
                    }
                }

                HStack(spacing: 12) {
                    Label("\(progress.completedWorldCount) de \(progress.worldMissionCount) misiones",
                          systemImage: "star.fill")
                        .font(.headline)
                        .foregroundStyle(GuideUTheme.mint)
                    Spacer()
                    Button {
                        confirmRestart = true
                    } label: {
                        Label("Reiniciar mundo", systemImage: "arrow.counterclockwise")
                            .font(.subheadline.weight(.semibold))
                    }
                }

                SpriteView(scene: model.scene, options: [.ignoresSiblingOrder])
                    .frame(height: horizontalSizeClass == .regular ? 440 : 325)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .strokeBorder(GuideUTheme.mint.opacity(0.35), lineWidth: 2)
                    )
                    .accessibilityLabel("Mapa explorable de Mi pequeño mundo. Usa las flechas de movimiento disponibles debajo del mapa.")
                    .accessibilityHint("También puedes tocar un destino para que el personaje camine hasta él.")

                GuideUCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Lo que ocurre", systemImage: "bubble.left.and.text.bubble.right")
                            .font(.headline)
                            .foregroundStyle(GuideUTheme.mint)
                        Text(model.message)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                            .accessibilityAddTraits(.updatesFrequently)
                    }
                }

                controlPanel

                GuideUCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Mi mochila", systemImage: "backpack.fill")
                            .font(.headline)
                        HStack(spacing: 12) {
                            inventoryItem("Cuaderno", symbol: "book.closed.fill", found: model.hasNotebook)
                            inventoryItem("Manzana", symbol: "apple.logo", found: model.hasApple)
                            VStack(alignment: .center, spacing: 6) {
                                Image(systemName: "leaf.fill")
                                    .font(.title3)
                                    .foregroundStyle(GuideUTheme.mint)
                                Text("\(model.leafCount)/3 hojas")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }

                SectionHeading(title: "Misiones del pueblo",
                               subtitle: "Tienes libertad para explorarlas en cualquier orden.")

                ForEach(WorldMission.allCases) { mission in
                    GuideUCard {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: progress.isWorldCompleted(mission) ?
                                  "checkmark.seal.fill" : mission.symbol)
                                .font(.title2)
                                .foregroundStyle(progress.isWorldCompleted(mission) ?
                                                 GuideUTheme.mint : GuideUTheme.accent)
                                .frame(width: 32)
                                .accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: 6) {
                                Text(mission.title)
                                    .font(.headline)
                                Text(mission.details)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(progress.isWorldCompleted(mission) ?
                                     "¡Completada!" : "Por descubrir")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(progress.isWorldCompleted(mission) ?
                                                     GuideUTheme.mint : Color.secondary)
                            }
                            Spacer(minLength: 0)
                        }
                    }
                }

                Text("Sin relojes, sin castigos y sin compras reales. No necesitas terminar todas las misiones.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            }
        }
        .navigationTitle("Mi pequeño mundo")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            model.onMissionCompleted = { [weak progress = progress] mission in
                _ = progress?.completeWorldMission(mission)
            }
            model.syncLeafMissionIfNeeded(isComplete: progress.isWorldCompleted(.leaves))
        }
        .confirmationDialog(
            "¿Quieres explorar el pueblo desde el comienzo?",
            isPresented: $confirmRestart,
            titleVisibility: .visible
        ) {
            Button("Reiniciar solo el mundo", role: .destructive) {
                progress.resetWorldMissions()
                model.reset()
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Se borrarán los objetos recogidos y las tres estrellas del mundo. Tus otros retos y juegos no cambiarán.")
        }
    }

    private var controlPanel: some View {
        GuideUCard {
            VStack(spacing: 14) {
                HStack(alignment: .top, spacing: 14) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Camina y explora")
                            .font(.headline)
                        Text("Toca una flecha o mantenla presionada. También puedes tocar el mapa.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer(minLength: 0)
                    Label("Sin prisa", systemImage: "leaf")
                        .font(.caption.bold())
                        .foregroundStyle(GuideUTheme.mint)
                }

                HStack(alignment: .center, spacing: 24) {
                    Spacer(minLength: 0)
                    VStack(spacing: 5) {
                        WorldDirectionButton(scene: model.scene, direction: .up,
                                             symbol: "arrow.up", label: "Mover arriba")
                        HStack(spacing: 5) {
                            WorldDirectionButton(scene: model.scene, direction: .left,
                                                 symbol: "arrow.left", label: "Mover izquierda")
                            WorldDirectionButton(scene: model.scene, direction: .down,
                                                 symbol: "arrow.down", label: "Mover abajo")
                            WorldDirectionButton(scene: model.scene, direction: .right,
                                                 symbol: "arrow.right", label: "Mover derecha")
                        }
                    }
                    Spacer(minLength: 0)
                }

                Button {
                    model.interact(completedMissions: progress.completedWorldIDs)
                } label: {
                    PrimaryActionLabel(
                        title: model.nearbyPlace.map { "Visitar \($0.title)" } ?? "Acércate a un lugar",
                        symbol: "hand.tap.fill"
                    )
                }
                .buttonStyle(.borderedProminent)
                .tint(GuideUTheme.mint)
                .disabled(model.nearbyPlace == nil)
                .accessibilityHint("Se activa cuando el personaje llega a un círculo azul del pueblo")
            }
        }
    }

    private func inventoryItem(_ title: String, symbol: String, found: Bool) -> some View {
        VStack(alignment: .center, spacing: 6) {
            Image(systemName: found ? symbol : "questionmark.circle")
                .font(.title3)
                .foregroundStyle(found ? GuideUTheme.mint : Color.secondary)
                .accessibilityHidden(true)
            Text(found ? title : "Por hallar")
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}

private struct WorldDirectionButton: View {
    let scene: TownScene
    let direction: WorldDirection
    let symbol: String
    let label: String

    var body: some View {
        Button {
            scene.step(direction)
        } label: {
            Image(systemName: symbol)
                .font(.system(size: 21, weight: .bold))
                .frame(width: 60, height: 52)
                .contentShape(Rectangle())
        }
        .buttonStyle(.bordered)
        .tint(GuideUTheme.accent)
        .accessibilityLabel(label)
        .accessibilityHint("Toca para avanzar un paso o mantén presionado para caminar")
        .onLongPressGesture(
            minimumDuration: 0.1,
            maximumDistance: 80,
            pressing: { pressed in
                scene.setMovement(pressed ? direction : nil)
            },
            perform: {}
        )
    }
}
