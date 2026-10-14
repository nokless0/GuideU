# GuideU 3.0 — Mi pequeño mundo

GuideU es una aplicación educativa para **iPhone y iPad** desarrollada en **SwiftUI**. Combina historias, actividades guiadas y ahora una **aventura 2D hecha con SpriteKit**, sin anuncios ni conexión a internet. Está dirigida principalmente a niños y adolescentes de aproximadamente 10 a 15 años, incluyendo a personas autistas.

## Novedad: Mi pequeño mundo

**Mi pequeño mundo** es un pequeño pueblo ilustrado mediante figuras de SpriteKit. Puedes:

- Caminar con las **cuatro flechas** (tocarlas para avanzar o mantenerlas presionadas para caminar) o **tocar un destino en el mapa**.
- Recorrer una plaza, escuela, tienda y parque, con cámara que sigue al personaje y edificios que no se pueden atravesar.
- Recoger cinco objetos repartidos por el escenario y guardar los hallazgos en el dispositivo.
- Completar **tres misiones exploratorias reales**: encontrar y entregar el cuaderno, llevar una manzana al parque y reunir tres hojas virtuales.
- Acercarte a los círculos azules de cada lugar y usar el botón **Visitar** para interactuar.
- Ganar una estrella por misión diferente, volver a explorar y reiniciar únicamente el mundo cuando quieras.

No hay cronómetros, muerte del personaje, castigos, publicidad, transacciones ni presión por completar todas las misiones. El recorrido es libre; las acciones se realizan moviendo al personaje, no mediante preguntas de opción múltiple.

### Dónde está

En la pestaña **Juegos → Mi pequeño mundo**, o desde la tarjeta destacada de **Inicio**. Los retos y seis minijuegos de la versión anterior siguen disponibles.

## Resto de la aplicación

- Introducción de cuatro pantallas.
- **9 retos sociales** con distintas respuestas posibles para escuela, familia y comunidad.
- **6 minijuegos guiados** de secuencias y relaciones.
- **3 misiones del mundo**, para un total de **18 estrellas posibles**, una por actividad diferente.
- Progreso y preferencias guardados localmente sin cuentas ni servidores.
- Tamaño de texto ampliado, diseño tranquilo, pistas opcionales, VoiceOver en controles SwiftUI, botones grandes y actividades sin límite de tiempo.
- No se exige contacto visual, abrazos ni hablar para completar las historias.

> El mapa SpriteKit es visual, pero puede controlarse mediante botones accesibles desde SwiftUI; las instrucciones, misiones e inventario se muestran también como texto. El prototipo requiere pruebas adicionales de accesibilidad con usuarios reales.

## Probar con Xcode

1. Si aún no lo tienes, clona `https://github.com/nokless0/GuideU.git`.
2. Abre `GuideU.xcodeproj`, elige el esquema **GuideU**, selecciona un simulador de iPhone o iPad y pulsa **⌘R**.
3. Si ya lo habías clonado, actualiza primero `main` con **Integrate → Pull** o `git pull origin main`.
4. Para probar en un equipo físico, configura la firma en **Signing & Capabilities**.

**Requisitos:** iOS 17 o superior, Xcode reciente. Usa **SwiftUI y SpriteKit** (ambas tecnologías de Apple), sin paquetes de terceros.

### Recorrido de prueba

1. Abre Juegos → Mi pequeño mundo; comprueba que el personaje y el mapa aparecen.
2. Toca una flecha y mantenla presionada; prueba también tocar un destino en el mapa.
3. Ve a la plaza y recoge el cuaderno situado cerca del camino; camina hacia la escuela y pulsa Visitar.
4. Ve a la tienda, recoge la manzana cerca de su entrada; llévala al parque y pulsa Visitar.
5. Camina por el parque y encuentra las tres hojas brillantes.
6. Comprueba las tres estrellas en Logros y cierra/abre la aplicación: el avance debe persistir.
7. Reinicia el mundo desde su pantalla y verifica que solo se borran los hallazgos de esa aventura.
8. Comprueba el diseño en iPhone e iPad; usa VoiceOver para probar los controles de movimiento.

## Archivos relevantes

```text
GuideU.xcodeproj/
GuideU/
  ContentView.swift
  GuideUApp.swift
  Models/
    Challenge.swift
    MiniGame.swift
    ProgressStore.swift
  Design/
    GuideUTheme.swift
  Views/
    GamesView.swift
    DashboardView.swift
    ChallengesView.swift
    OnboardingView.swift
    ProgressScreen.swift
    SettingsScreen.swift
  World/
    TownScene.swift            # Escenario 2D, cámara, movimiento y elementos
    WorldAdventureModel.swift  # Inventario, misiones y guardado
    WorldAdventureView.swift   # Controles y presentación con SwiftUI
  Assets.xcassets/
  PrivacyInfo.xcprivacy
```

## Enfoque responsable

El proyecto es un **prototipo educativo**, no una herramienta de diagnóstico ni intervención clínica validada. Su diseño busca fomentar autonomía, exploración y comodidad sensorial, pero las necesidades y preferencias de cada persona son diferentes. Antes de distribuirlo a menores, conviene evaluar el contenido con personas autistas, familias y profesionales, y probar accesibilidad táctil, visual y cognitiva en dispositivos reales.

Referencias generales: [Apple — Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility), [Apple — SpriteKit](https://developer.apple.com/documentation/spritekit) y [UNICEF — RITEC](https://www.unicef.org/innovation/responsible-innovation-technology-children-ritec).
