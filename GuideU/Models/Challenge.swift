import Foundation

enum ChallengeCategory: String, CaseIterable, Identifiable {
    case escuela, familia, comunidad

    var id: String { rawValue }

    var title: String {
        switch self {
        case .escuela: return "Escuela"
        case .familia: return "Familia"
        case .comunidad: return "Comunidad"
        }
    }

    var symbol: String {
        switch self {
        case .escuela: return "backpack.fill"
        case .familia: return "house.fill"
        case .comunidad: return "figure.2.and.child.holdinghands"
        }
    }

    var description: String {
        switch self {
        case .escuela: return "Practica situaciones del salón y el recreo."
        case .familia: return "Expresa lo que necesitas en casa."
        case .comunidad: return "Aprende a pedir ayuda y comunicarte fuera de casa."
        }
    }
}

struct AnswerOption: Identifiable {
    let id: String
    let text: String
    let feedback: String
    let helpful: Bool

    init(_ id: String, _ text: String, _ feedback: String, helpful: Bool) {
        self.id = id
        self.text = text
        self.feedback = feedback
        self.helpful = helpful
    }
}

struct Challenge: Identifiable {
    let id: String
    let category: ChallengeCategory
    let title: String
    let symbol: String
    let situation: String
    let question: String
    let options: [AnswerOption]
    let tip: String
    let practiceIdea: String
}

/// Historias inventadas para practicar. Una respuesta no define el valor de una persona.
enum ChallengeLibrary {
    static let all: [Challenge] = [
        Challenge(
            id: "saludar",
            category: .escuela,
            title: "Un saludo en el salón",
            symbol: "hand.wave.fill",
            situation: "Llegas a clase. Un compañero te dice: «¡Hola, buenos días!».",
            question: "¿Cómo puedes responder de una forma cómoda para ti?",
            options: [
                AnswerOption("a", "Decir «hola» o saludar con la mano.", "¡Buena idea! Puedes elegir palabras o gestos.", helpful: true),
                AnswerOption("b", "Gritarle para que se aleje.", "Si necesitas espacio, puedes pedirlo con tranquilidad.", helpful: false),
                AnswerOption("c", "Decir «ahora prefiero estar tranquilo».", "¡Bien! Expresar tus límites también es válido.", helpful: true)
            ],
            tip: "No es necesario mirar a los ojos para saludar.",
            practiceIdea: "Prueba saludar con palabras, con una sonrisa o levantando la mano."
        ),
        Challenge(
            id: "pedir-ayuda",
            category: .escuela,
            title: "Pedir ayuda en clase",
            symbol: "questionmark.circle.fill",
            situation: "La maestra explica una actividad, pero una instrucción no quedó clara.",
            question: "¿Qué podrías hacer?",
            options: [
                AnswerOption("a", "Preguntar: «¿Me lo explica otra vez, por favor?».", "¡Muy bien! Pedir una explicación es una habilidad útil.", helpful: true),
                AnswerOption("b", "Quedarme confundido sin intentar pedir apoyo.", "Está bien necesitar más tiempo. También puedes pedir ayuda.", helpful: false),
                AnswerOption("c", "Señalar la instrucción y pedir un ejemplo.", "¡Excelente! Hay diferentes maneras de pedir apoyo.", helpful: true)
            ],
            tip: "Puedes escribir o señalar tu pregunta si hablar te resulta difícil.",
            practiceIdea: "Practica la frase: «¿Me puedes dar un ejemplo?»."
        ),
        Challenge(
            id: "recreo",
            category: .escuela,
            title: "Compartir un juego",
            symbol: "gamecontroller.fill",
            situation: "Durante el recreo ves a unos compañeros jugando algo que te interesa.",
            question: "¿Cómo puedes acercarte?",
            options: [
                AnswerOption("a", "Preguntar: «¿Puedo jugar con ustedes?».", "¡Buena opción! Preguntar permite conocer si hay lugar.", helpful: true),
                AnswerOption("b", "Tomar el juego sin preguntar.", "Es mejor preguntar antes de usar algo que pertenece a otras personas.", helpful: false),
                AnswerOption("c", "Observar un momento y preguntar después.", "¡También funciona! Puedes acercarte a tu propio ritmo.", helpful: true)
            ],
            tip: "También está bien elegir jugar a solas si eso te hace sentir mejor.",
            practiceIdea: "Ensaya cómo invitar a alguien a jugar contigo."
        ),
        Challenge(
            id: "trabajo-equipo",
            category: .escuela,
            title: "Trabajar en equipo",
            symbol: "person.3.fill",
            situation: "En un proyecto grupal, todos tienen ideas diferentes.",
            question: "¿Qué podrías decir?",
            options: [
                AnswerOption("a", "«Tengo una idea. ¿La podemos escuchar?».", "¡Excelente! Puedes compartir tu idea con respeto.", helpful: true),
                AnswerOption("b", "«Solo mi idea sirve».", "Escuchar otras ideas ayuda a encontrar una solución en equipo.", helpful: false),
                AnswerOption("c", "«¿Podemos repartir las tareas?».", "¡Muy bien! Repartir tareas puede facilitar el trabajo.", helpful: true)
            ],
            tip: "Pedir que las instrucciones estén por escrito puede ayudar al equipo.",
            practiceIdea: "Piensa en una tarea que te gustaría hacer en un equipo."
        ),
        Challenge(
            id: "descanso",
            category: .familia,
            title: "Necesito un descanso",
            symbol: "moon.stars.fill",
            situation: "Hay mucho ruido en casa y te estás sintiendo cansado.",
            question: "¿Cómo podrías explicar lo que necesitas?",
            options: [
                AnswerOption("a", "«Hay mucho ruido. ¿Puedo ir a un lugar tranquilo?».", "¡Muy bien! Pedir una pausa es importante.", helpful: true),
                AnswerOption("b", "Guardar silencio aunque me sienta muy mal.", "Tu comodidad importa. Puedes comunicarlo con palabras o señales.", helpful: false),
                AnswerOption("c", "Mostrar una tarjeta o gesto para pedir una pausa.", "¡Buena estrategia! No necesitas hablar para comunicarte.", helpful: true)
            ],
            tip: "Puedes acordar con tu familia una señal para pedir descanso.",
            practiceIdea: "Elige un lugar tranquilo y piensa cómo pedirías ir allí."
        ),
        Challenge(
            id: "limites",
            category: .familia,
            title: "Decir lo que prefiero",
            symbol: "heart.text.square.fill",
            situation: "Un familiar quiere darte un abrazo, pero hoy no quieres.",
            question: "¿Qué puedes hacer?",
            options: [
                AnswerOption("a", "«Hoy prefiero saludarte con la mano».", "¡Perfecto! Puedes elegir cómo mostrar cariño.", helpful: true),
                AnswerOption("b", "Aceptar aunque me incomode porque debo hacerlo.", "Tienes derecho a expresar tus límites de contacto físico.", helpful: false),
                AnswerOption("c", "Decir «no quiero un abrazo, gracias».", "¡Bien! Un límite claro y respetuoso es válido.", helpful: true)
            ],
            tip: "Tu cuerpo es tuyo. Un abrazo no es obligatorio.",
            practiceIdea: "Piensa en un saludo que te resulte cómodo."
        ),
        Challenge(
            id: "planes",
            category: .familia,
            title: "Cuando cambia el plan",
            symbol: "calendar.badge.clock",
            situation: "Iban a salir al parque, pero empieza a llover y deben cambiar el plan.",
            question: "¿Qué podría ayudarte?",
            options: [
                AnswerOption("a", "Preguntar cuál será el nuevo plan.", "¡Muy bien! Saber qué ocurrirá puede dar tranquilidad.", helpful: true),
                AnswerOption("b", "Romper objetos para mostrar mi disgusto.", "Estar molesto es válido; romper cosas puede hacer daño. Puedes pedir apoyo.", helpful: false),
                AnswerOption("c", "Pedir unos minutos para adaptarme al cambio.", "¡Buena idea! Puedes darte tiempo para procesarlo.", helpful: true)
            ],
            tip: "Puedes pedir que te expliquen los cambios paso a paso.",
            practiceIdea: "Imagina dos actividades que te gusten para un día de lluvia."
        ),
        Challenge(
            id: "turnos",
            category: .comunidad,
            title: "Esperar mi turno",
            symbol: "person.2.line.dotted.person.fill",
            situation: "En una tienda hay personas esperando para pagar.",
            question: "¿Qué puedes hacer?",
            options: [
                AnswerOption("a", "Ubicar el final de la fila y esperar mi turno.", "¡Correcto! Las filas ayudan a respetar el orden.", helpful: true),
                AnswerOption("b", "Pasar delante de todos sin preguntar.", "Eso puede confundir a los demás. Es mejor preguntar dónde empieza la fila.", helpful: false),
                AnswerOption("c", "Preguntar dónde termina la fila si no está claro.", "¡Excelente! Preguntar te ayuda a orientarte.", helpful: true)
            ],
            tip: "Si esperar es difícil, puedes pedir ayuda o usar una actividad tranquila.",
            practiceIdea: "Practica la frase: «¿Aquí es el final de la fila?»."
        ),
        Challenge(
            id: "lugar-nuevo",
            category: .comunidad,
            title: "Un lugar desconocido",
            symbol: "mappin.and.ellipse",
            situation: "Llegas con un adulto de confianza a un lugar que no conoces.",
            question: "¿Qué podrías hacer para sentirte más seguro?",
            options: [
                AnswerOption("a", "Preguntar dónde están los baños y la salida.", "¡Buena idea! Conocer el lugar puede ayudarte.", helpful: true),
                AnswerOption("b", "Alejarme sin avisar a nadie.", "Es más seguro comunicar a la persona que te acompaña adónde vas.", helpful: false),
                AnswerOption("c", "Pedir que me expliquen qué haremos primero.", "¡Excelente! Tener un plan claro puede darte tranquilidad.", helpful: true)
            ],
            tip: "Puedes llevar una lista visual de los pasos de la visita.",
            practiceIdea: "Piensa en tres preguntas que harías al visitar un sitio nuevo."
        )
    ]

    static func forCategory(_ category: ChallengeCategory?) -> [Challenge] {
        guard let category else { return all }
        return all.filter { $0.category == category }
    }
}
