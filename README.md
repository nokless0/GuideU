# GuideU 2.0 — aprende, explora y juega

GuideU es un **prototipo educativo de iOS y iPadOS**, escrito en SwiftUI, con actividades para practicar comunicación, autonomía y situaciones cotidianas. Está pensado especialmente para niños y adolescentes (aprox. 10–15 años), incluidas personas autistas. No es una herramienta diagnóstica ni un tratamiento.

## Qué incluye la versión 2.0

- Nueva identidad visual juvenil con **Lumi**, una pequeña estrella acompañante dibujada con SF Symbols, tarjetas de esquinas redondeadas, diseño adaptable a iPhone y iPad.
- 4 pantallas introductorias que pueden volver a consultarse.
- **9 retos sociales** de escuela, familia y comunidad, con comentarios amables y más de una respuesta útil cuando corresponde.
- **6 minijuegos nuevos** de dos mecánicas accesibles:
  - **Ordena los pasos:** construye secuencias al tocar tarjetas; puedes deshacer pasos y pedir una pista.
  - **Relaciona las ideas:** conecta una situación con una estrategia adecuada, paso a paso.
- Colección de **15 estrellas posibles** (una por actividad diferente) y registro de actividades exploradas.
- No hay cronómetros, rachas, penalizaciones, competencia, publicidad ni reproducción automática de sonidos.
- Progreso y preferencias guardados únicamente en el dispositivo, conservando los retos completados en la versión anterior.
- Preferencias para tamaño de texto, pistas y **diseño tranquilo**; controles grandes, etiquetas con iconos y textos, soporte de VoiceOver y Dynamic Type.
- Sin cuentas, paquetes externos o conexión a internet.

Las situaciones se diseñaron para respetar diferentes maneras de comunicarse: no se exige mirar a los ojos, hablar en voz alta o aceptar contacto físico. Hay maneras alternativas de pedir ayuda, expresar límites y descansar.

## Cómo abrirlo

1. Clona el repositorio:
   ```bash
   git clone https://github.com/nokless0/GuideU.git
   ```
2. Abre **GuideU.xcodeproj** con Xcode.
3. Elige el esquema **GuideU**, selecciona un simulador de iPhone o iPad y pulsa **⌘R**.
4. Para instalarlo en un dispositivo físico, selecciona el equipo de firma en **Signing & Capabilities**.

**Requisitos:** iOS 17 o posterior, y una versión reciente de Xcode. Lenguaje Swift 5; sin dependencias externas.

Si ya clonaste GuideU, usa `git pull` desde la rama `main` o **Integrate → Pull** en Xcode para obtener la actualización.

## Comprobaciones sugeridas

1. Recorrer la introducción; volver a abrirla desde Ajustes.
2. Terminar un reto nuevo y observar su estrella en Logros.
3. Ir a Juegos, completar una secuencia y una asociación.
4. Volver a jugar: no deben duplicarse las estrellas.
5. Cerrar y abrir la aplicación y comprobar que las estrellas persistan.
6. Activar Texto ampliado y Diseño tranquilo; revisar en iPhone e iPad.
7. Probar VoiceOver y texto grande desde Ajustes de iOS.

## Estructura

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
    OnboardingView.swift
    DashboardView.swift
    ChallengesView.swift
    GamesView.swift
    ProgressScreen.swift
    SettingsScreen.swift
  Assets.xcassets/
  PrivacyInfo.xcprivacy
```

## Decisiones de diseño

- Las recomendaciones de [Apple sobre accesibilidad](https://developer.apple.com/design/human-interface-guidelines/accessibility) fundamentan el uso de Dynamic Type, VoiceOver, legibilidad, apoyo no basado solo en color y el respeto a Reducir movimiento.
- La [iniciativa RITEC de UNICEF](https://www.unicef.org/innovation/responsible-innovation-technology-children-ritec) destaca la autonomía, la elección y el bienestar en el juego digital. Por ello evitamos clasificaciones públicas y recompensas por tiempo o por rachas.
- Los [patrones de accesibilidad cognitiva de W3C](https://www.w3.org/WAI/WCAG2/supplemental/patterns/o1p05-clear-controls/) recomiendan controles claros, instrucciones breves y una navegación consistente.

**Importante:** sigue siendo un prototipo educativo. Antes de un uso real sostenido, conviene validarlo con personas autistas de distintas edades, familias y especialistas, sin asumir que existe una sola preferencia sensorial o de comunicación.
