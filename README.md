# GuideU · SwiftUI

**GuideU** es un prototipo educativo de iOS para practicar habilidades de comunicación, autonomía y situaciones cotidianas en un entorno amable y accesible. Está pensado como apoyo para niños y adolescentes de aproximadamente 10 a 15 años, incluyendo usuarios autistas.

## Funciones

- Introducción de cuatro pantallas (solo en el primer inicio; puede repetirse desde Ajustes).
- Pantallas Inicio, Retos, Progreso y Ajustes, con navegación inferior.
- **9 retos interactivos** repartidos entre Escuela, Familia y Comunidad.
- Retroalimentación inmediata y varias respuestas válidas cuando corresponde.
- Pistas opcionales y sugerencias para practicar fuera de la aplicación.
- Una estrella por cada reto diferente completado; se pueden repetir los retos sin duplicar estrellas.
- Guardado local automático de progreso y preferencias usando UserDefaults.
- Texto ampliado opcional, Dynamic Type, VoiceOver, símbolos acompañados de texto y botones grandes.
- Sin cuentas, sin servicios externos, sin permisos especiales y sin necesidad de internet.

Las actividades no exigen contacto visual ni contacto físico; se pueden expresar límites, pedir pausas y usar comunicación no verbal. **No es una herramienta diagnóstica ni sustituye apoyo profesional.**

## Cómo ejecutar en Xcode

1. Clona el repositorio:
   ```bash
   git clone https://github.com/nokless0/GuideU.git
   ```
2. Abre **GuideU.xcodeproj** (el archivo está en la raíz del repositorio).
3. Selecciona el esquema **GuideU** y un simulador de iPhone.
4. Pulsa **⌘R** para compilar y ejecutar.

**Requisitos:** macOS con Xcode que soporte SwiftUI e iOS 17 o posterior. El proyecto usa Swift 5 language mode y no requiere paquetes de terceros.

Para probar en un iPhone físico, selecciona tu equipo de desarrollo en **Target GuideU → Signing & Capabilities** y configura la firma.

## Estructura

```text
GuideU.xcodeproj/
GuideU/
  GuideUApp.swift
  ContentView.swift
  Models/
    Challenge.swift
    ProgressStore.swift
  Design/
    GuideUTheme.swift
  Views/
    OnboardingView.swift
    DashboardView.swift
    ChallengesView.swift
    ProgressScreen.swift
    SettingsScreen.swift
  Assets.xcassets/
  PrivacyInfo.xcprivacy
```

## Probar el prototipo

1. La primera vez, avanza las cuatro páginas de introducción.
2. En Inicio entra en «Un reto para ti» o filtra desde Retos.
3. Selecciona una respuesta, lee la explicación y, cuando corresponda, pulsa «Completar reto».
4. Consulta tu estrella en Progreso y cierra y abre la app para comprobar que se conserve.
5. En Ajustes cambia el texto, activa o desactiva las pistas, repite la introducción o restablece el progreso.

## Privacidad

Toda la información guardada son identificadores de retos completados y preferencias de la app, almacenados localmente. No hay analítica, publicidad, cuentas ni transmisión de información personal. La app puede usarse sin conexión.

## Estado

Versión **1.0 de prototipo educativo**. El código y el proyecto Xcode están listos para que se compile y pruebe desde un Mac; deben validarse en el simulador y con usuarios antes de considerarse una versión de producción.
