import SpriteKit
import UIKit

enum WorldDirection {
    case up, down, left, right

    var vector: CGVector {
        switch self {
        case .up: return CGVector(dx: 0, dy: 1)
        case .down: return CGVector(dx: 0, dy: -1)
        case .left: return CGVector(dx: -1, dy: 0)
        case .right: return CGVector(dx: 1, dy: 0)
        }
    }
}

enum WorldPlace: String, CaseIterable, Identifiable {
    case plaza, school, market, park

    var id: String { rawValue }

    var title: String {
        switch self {
        case .plaza: return "Plaza de Lumi"
        case .school: return "Escuela"
        case .market: return "Tienda"
        case .park: return "Parque"
        }
    }

    var symbol: String {
        switch self {
        case .plaza: return "sparkles"
        case .school: return "books.vertical.fill"
        case .market: return "basket.fill"
        case .park: return "leaf.fill"
        }
    }

    /// Entrada accesible, fuera de edificios y obstáculos.
    var entrance: CGPoint {
        switch self {
        case .plaza: return CGPoint(x: 565, y: 420)
        case .school: return CGPoint(x: 280, y: 570)
        case .market: return CGPoint(x: 940, y: 568)
        case .park: return CGPoint(x: 950, y: 285)
        }
    }
}

/// Minijuego exploratorio sin dependencia de texturas, redes o paquetes externos.
/// El mapa se dibuja con SpriteKit y puede manejarse con botones o tocando destinos.
final class TownScene: SKScene {
    static let mapSize = CGSize(width: 1220, height: 880)

    var onCollect: ((String) -> Void)?
    var onNearbyChange: ((WorldPlace?) -> Void)?
    var collectedIDs: Set<String> = []

    private let cameraNode = SKCameraNode()
    private let avatar = SKNode()
    private var collectibleNodes: [String: SKNode] = [:]
    private var activeDirection: WorldDirection?
    private var destination: CGPoint?
    private var lastTime: TimeInterval = 0
    private var nearbyPlace: WorldPlace?

    private let movementSpeed: CGFloat = 215
    private let wallRects: [CGRect] = [
        CGRect(x: 160, y: 617, width: 240, height: 160),
        CGRect(x: 808, y: 617, width: 265, height: 160),
        CGRect(x: 537, y: 479, width: 86, height: 86)
    ]

    override func didMove(to view: SKView) {
        guard childNode(withName: "ground") == nil else { return }
        anchorPoint = .zero
        backgroundColor = SKColor(red: 0.77, green: 0.88, blue: 0.72, alpha: 1)
        buildMap()
        buildAvatar()
        addChild(cameraNode)
        camera = cameraNode
        updateCameraScale()
        updateCameraPosition()
        updateNearby()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        updateCameraScale()
        updateCameraPosition()
    }

    func setMovement(_ direction: WorldDirection?) {
        activeDirection = direction
        if direction != nil { destination = nil }
    }

    func step(_ direction: WorldDirection) {
        destination = nil
        move(dx: direction.vector.dx * 38, dy: direction.vector.dy * 38)
        updateNearby()
        checkCollectibles()
        updateCameraPosition()
    }

    /// Recupera recursos del mundo cuando el usuario reinicia su aventura.
    func resetExploration() {
        collectedIDs.removeAll()
        collectibleNodes.values.forEach { $0.removeFromParent() }
        collectibleNodes.removeAll()
        buildCollectibles()
        avatar.position = CGPoint(x: 570, y: 350)
        activeDirection = nil
        destination = nil
        updateNearby()
        updateCameraPosition()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        // Al tocar un edificio, dirigirse a su entrada y no atravesar paredes.
        if wallRects[0].contains(point) {
            destination = WorldPlace.school.entrance
        } else if wallRects[1].contains(point) {
            destination = WorldPlace.market.entrance
        } else if wallRects[2].contains(point) {
            destination = WorldPlace.plaza.entrance
        } else {
            destination = clamped(point)
        }
        activeDirection = nil
    }

    override func update(_ currentTime: TimeInterval) {
        defer { lastTime = currentTime }
        guard lastTime > 0 else { return }
        let delta = min(CGFloat(currentTime - lastTime), 0.05)
        guard delta > 0 else { return }

        if let direction = activeDirection {
            move(dx: direction.vector.dx * movementSpeed * delta,
                 dy: direction.vector.dy * movementSpeed * delta)
        } else if let destination {
            let vx = destination.x - avatar.position.x
            let vy = destination.y - avatar.position.y
            let distance = hypot(vx, vy)
            if distance <= 5 {
                self.destination = nil
            } else {
                let amount = min(movementSpeed * delta, distance)
                move(dx: vx / distance * amount, dy: vy / distance * amount)
            }
        }

        checkCollectibles()
        updateNearby()
        updateCameraPosition()
    }

    private func clamped(_ point: CGPoint) -> CGPoint {
        CGPoint(x: min(max(point.x, 36), TownScene.mapSize.width - 36),
                y: min(max(point.y, 40), TownScene.mapSize.height - 42))
    }

    private func move(dx: CGFloat, dy: CGFloat) {
        let previous = avatar.position
        var attempt = clamped(CGPoint(x: previous.x + dx, y: previous.y))
        if canStand(attempt) { avatar.position.x = attempt.x }
        attempt = clamped(CGPoint(x: avatar.position.x, y: previous.y + dy))
        if canStand(attempt) { avatar.position.y = attempt.y }
    }

    private func canStand(_ position: CGPoint) -> Bool {
        !wallRects.contains(where: { $0.insetBy(dx: -13, dy: -12).contains(position) })
    }

    private func updateNearby() {
        let candidate = WorldPlace.allCases
            .filter { hypot($0.entrance.x - avatar.position.x,
                            $0.entrance.y - avatar.position.y) < 106 }
            .min {
                hypot($0.entrance.x - avatar.position.x,
                      $0.entrance.y - avatar.position.y) <
                hypot($1.entrance.x - avatar.position.x,
                      $1.entrance.y - avatar.position.y)
            }
        if candidate != nearbyPlace {
            nearbyPlace = candidate
            onNearbyChange?(candidate)
        }
    }

    private func updateCameraScale() {
        guard size.width > 0, size.height > 0 else { return }
        // Pantallas estrechas muestran ~610 puntos del mapa; iPad muestra una zona mayor.
        let cameraScale = max(1.0, min(1.9, 610 / size.width))
        cameraNode.setScale(cameraScale)
    }

    private func updateCameraPosition() {
        guard size.width > 0, size.height > 0 else { return }
        let halfWidth = min(TownScene.mapSize.width / 2, size.width * cameraNode.xScale / 2)
        let halfHeight = min(TownScene.mapSize.height / 2, size.height * cameraNode.yScale / 2)
        cameraNode.position = CGPoint(
            x: min(max(avatar.position.x, halfWidth), TownScene.mapSize.width - halfWidth),
            y: min(max(avatar.position.y, halfHeight), TownScene.mapSize.height - halfHeight)
        )
    }

    private func makeRect(_ rect: CGRect, color: SKColor, radius: CGFloat = 0, z: CGFloat = 0) {
        let node = SKShapeNode(rect: rect, cornerRadius: radius)
        node.fillColor = color
        node.strokeColor = .clear
        node.zPosition = z
        addChild(node)
    }

    private func makeCircle(_ center: CGPoint, radius: CGFloat, color: SKColor, z: CGFloat = 0) {
        let node = SKShapeNode(circleOfRadius: radius)
        node.fillColor = color
        node.strokeColor = .clear
        node.position = center
        node.zPosition = z
        addChild(node)
    }

    private func makeLabel(_ text: String, at point: CGPoint, size: CGFloat = 19,
                           color: SKColor = .darkGray, z: CGFloat = 8) {
        let label = SKLabelNode(text: text)
        label.fontName = "AvenirNext-DemiBold"
        label.fontSize = size
        label.fontColor = color
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.position = point
        label.zPosition = z
        addChild(label)
    }

    private func buildMap() {
        let ground = SKShapeNode(rect: CGRect(origin: .zero, size: TownScene.mapSize))
        ground.name = "ground"
        ground.fillColor = SKColor(red: 0.79, green: 0.90, blue: 0.75, alpha: 1)
        ground.strokeColor = .clear
        ground.zPosition = -20
        addChild(ground)

        // Camino principal y cruces, con esquinas suaves.
        let path = SKColor(red: 0.95, green: 0.89, blue: 0.76, alpha: 1)
        makeRect(CGRect(x: 55, y: 392, width: 1110, height: 112), color: path, radius: 48)
        makeRect(CGRect(x: 238, y: 375, width: 88, height: 250), color: path, radius: 38)
        makeRect(CGRect(x: 893, y: 254, width: 88, height: 372), color: path, radius: 38)
        makeRect(CGRect(x: 538, y: 320, width: 82, height: 210), color: path, radius: 30)

        // Árboles lejos de las entradas.
        let trees: [CGPoint] = [
            CGPoint(x: 65, y: 685), CGPoint(x: 480, y: 725),
            CGPoint(x: 620, y: 735), CGPoint(x: 745, y: 700),
            CGPoint(x: 1140, y: 720), CGPoint(x: 95, y: 190),
            CGPoint(x: 285, y: 195), CGPoint(x: 405, y: 130),
            CGPoint(x: 1100, y: 120), CGPoint(x: 750, y: 120)
        ]
        for p in trees { makeTree(at: p) }

        // Escuela y su puerta: pared de colisión sobre el edificio.
        makeRect(CGRect(x: 160, y: 617, width: 240, height: 160),
                 color: SKColor(red: 0.98, green: 0.79, blue: 0.63, alpha: 1), radius: 14, z: 3)
        makeRect(CGRect(x: 148, y: 758, width: 264, height: 29),
                 color: SKColor(red: 0.72, green: 0.36, blue: 0.34, alpha: 1), radius: 7, z: 4)
        for x in [215.0, 344.0] {
            makeRect(CGRect(x: x, y: 681, width: 44, height: 52),
                     color: SKColor(red: 0.65, green: 0.83, blue: 0.94, alpha: 1), radius: 9, z: 5)
        }
        makeRect(CGRect(x: 264, y: 617, width: 35, height: 72),
                 color: SKColor(red: 0.43, green: 0.45, blue: 0.68, alpha: 1), radius: 5, z: 6)
        makeLabel("ESCUELA", at: CGPoint(x: 280, y: 742), size: 19, z: 7)

        // Tienda
        makeRect(CGRect(x: 808, y: 617, width: 265, height: 160),
                 color: SKColor(red: 0.97, green: 0.84, blue: 0.68, alpha: 1), radius: 14, z: 3)
        makeRect(CGRect(x: 795, y: 748, width: 291, height: 37),
                 color: SKColor(red: 0.26, green: 0.59, blue: 0.55, alpha: 1), radius: 9, z: 5)
        makeRect(CGRect(x: 843, y: 666, width: 59, height: 56),
                 color: SKColor(red: 0.69, green: 0.88, blue: 0.96, alpha: 1), radius: 8, z: 5)
        makeRect(CGRect(x: 977, y: 617, width: 50, height: 86),
                 color: SKColor(red: 0.40, green: 0.60, blue: 0.56, alpha: 1), radius: 6, z: 5)
        makeLabel("TIENDA", at: CGPoint(x: 942, y: 758), size: 18, color: .white, z: 7)

        // Parque de juegos tranquilo: camino, canteros y bancas.
        makeCircle(CGPoint(x: 972, y: 246), radius: 164,
                   color: SKColor(red: 0.67, green: 0.85, blue: 0.62, alpha: 1))
        makeCircle(CGPoint(x: 974, y: 248), radius: 113,
                   color: SKColor(red: 0.81, green: 0.91, blue: 0.74, alpha: 1))
        for x in [835.0, 1050.0] {
            makeRect(CGRect(x: x, y: 349, width: 64, height: 16),
                     color: SKColor(red: 0.57, green: 0.42, blue: 0.31, alpha: 1),
                     radius: 4, z: 3)
        }
        makeLabel("PARQUE", at: CGPoint(x: 964, y: 387), size: 20)

        // Plaza, fuente y carteles de ubicación.
        makeCircle(CGPoint(x: 580, y: 521), radius: 56,
                   color: SKColor(red: 0.63, green: 0.79, blue: 0.89, alpha: 1), z: 2)
        makeCircle(CGPoint(x: 580, y: 521), radius: 33,
                   color: SKColor(red: 0.84, green: 0.94, blue: 0.97, alpha: 1), z: 3)
        makeLabel("PLAZA", at: CGPoint(x: 575, y: 600), size: 20)

        // Flores decorativas sencillas.
        for p in [
            CGPoint(x: 112, y: 350), CGPoint(x: 395, y: 302),
            CGPoint(x: 702, y: 580), CGPoint(x: 1100, y: 468),
            CGPoint(x: 760, y: 210), CGPoint(x: 1163, y: 350)
        ] {
            makeCircle(p, radius: 9,
                       color: SKColor(red: 0.97, green: 0.83, blue: 0.66, alpha: 1), z: 2)
            makeCircle(CGPoint(x: p.x + 1, y: p.y), radius: 3,
                       color: SKColor(red: 0.85, green: 0.52, blue: 0.48, alpha: 1), z: 3)
        }

        // Marcas de acceso para interacción.
        for place in WorldPlace.allCases {
            makeCircle(place.entrance, radius: 23,
                       color: SKColor(red: 0.30, green: 0.59, blue: 0.66, alpha: 0.20), z: 6)
            makeCircle(place.entrance, radius: 7,
                       color: SKColor(red: 0.26, green: 0.58, blue: 0.64, alpha: 1), z: 7)
        }

        buildCollectibles()
    }

    private func makeTree(at position: CGPoint) {
        makeRect(CGRect(x: position.x - 8, y: position.y - 24, width: 16, height: 28),
                 color: SKColor(red: 0.52, green: 0.41, blue: 0.29, alpha: 1), radius: 4, z: 1)
        makeCircle(CGPoint(x: position.x, y: position.y + 5), radius: 30,
                   color: SKColor(red: 0.35, green: 0.65, blue: 0.47, alpha: 1), z: 2)
        makeCircle(CGPoint(x: position.x - 12, y: position.y + 18), radius: 17,
                   color: SKColor(red: 0.44, green: 0.74, blue: 0.50, alpha: 1), z: 3)
    }

    private func buildCollectibles() {
        addCollectible(id: "notebook", symbol: "📓", at: CGPoint(x: 460, y: 375))
        addCollectible(id: "apple", symbol: "🍎", at: CGPoint(x: 1030, y: 552))
        addCollectible(id: "leaf1", symbol: "🍃", at: CGPoint(x: 805, y: 230))
        addCollectible(id: "leaf2", symbol: "🍃", at: CGPoint(x: 1084, y: 310))
        addCollectible(id: "leaf3", symbol: "🍃", at: CGPoint(x: 980, y: 145))
    }

    private func addCollectible(id: String, symbol: String, at position: CGPoint) {
        guard !collectedIDs.contains(id) else { return }
        let node = SKNode()
        node.position = position
        node.zPosition = 12
        let background = SKShapeNode(circleOfRadius: 28)
        background.fillColor = SKColor.white.withAlphaComponent(0.92)
        background.strokeColor = SKColor(red: 0.27, green: 0.48, blue: 0.52, alpha: 0.48)
        background.lineWidth = 2
        node.addChild(background)
        let label = SKLabelNode(text: symbol)
        label.fontSize = 27
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        node.addChild(label)
        node.name = "collectible-\(id)"
        collectibleNodes[id] = node
        addChild(node)
    }

    private func buildAvatar() {
        avatar.position = CGPoint(x: 570, y: 350)
        avatar.zPosition = 30
        let shadow = SKShapeNode(ellipseOf: CGSize(width: 40, height: 15))
        shadow.fillColor = SKColor.black.withAlphaComponent(0.16)
        shadow.strokeColor = .clear
        shadow.position = CGPoint(x: 0, y: -28)
        avatar.addChild(shadow)

        let legs = SKShapeNode(rectOf: CGSize(width: 28, height: 25), cornerRadius: 8)
        legs.fillColor = SKColor(red: 0.29, green: 0.43, blue: 0.60, alpha: 1)
        legs.strokeColor = .clear
        legs.position = CGPoint(x: 0, y: -18)
        avatar.addChild(legs)

        let body = SKShapeNode(rectOf: CGSize(width: 43, height: 46), cornerRadius: 18)
        body.fillColor = SKColor(red: 0.42, green: 0.39, blue: 0.73, alpha: 1)
        body.strokeColor = .clear
        body.position = CGPoint(x: 0, y: 1)
        avatar.addChild(body)

        let head = SKShapeNode(circleOfRadius: 24)
        head.fillColor = SKColor(red: 0.99, green: 0.84, blue: 0.66, alpha: 1)
        head.strokeColor = SKColor(red: 0.45, green: 0.37, blue: 0.34, alpha: 0.35)
        head.lineWidth = 1
        head.position = CGPoint(x: 0, y: 34)
        avatar.addChild(head)

        for x in [-8.0, 8.0] {
            let eye = SKShapeNode(circleOfRadius: 2.8)
            eye.fillColor = SKColor(red: 0.34, green: 0.32, blue: 0.35, alpha: 1)
            eye.strokeColor = .clear
            eye.position = CGPoint(x: x, y: 37)
            avatar.addChild(eye)
        }
        let hair = SKShapeNode(ellipseOf: CGSize(width: 44, height: 15))
        hair.fillColor = SKColor(red: 0.31, green: 0.28, blue: 0.35, alpha: 1)
        hair.strokeColor = .clear
        hair.position = CGPoint(x: 0, y: 53)
        avatar.addChild(hair)

        addChild(avatar)
    }

    private func checkCollectibles() {
        for (id, node) in collectibleNodes {
            guard !collectedIDs.contains(id) else { continue }
            if hypot(node.position.x - avatar.position.x,
                     node.position.y - avatar.position.y) <= 43 {
                collectedIDs.insert(id)
                node.removeFromParent()
                onCollect?(id)
            }
        }
    }
}
