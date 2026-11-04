import SwiftUI

/// Colores suaves, con texto del sistema para conservar contraste en modo claro y oscuro.
enum GuideUTheme {
    static let accent = Color(red: 0.25, green: 0.31, blue: 0.67)
    static let mint = Color(red: 0.15, green: 0.52, blue: 0.45)
    static let coral = Color(red: 0.76, green: 0.34, blue: 0.35)
    static let sunny = Color(red: 1.0, green: 0.70, blue: 0.23)
    static let lilac = Color(red: 0.70, green: 0.53, blue: 0.88)
    static let sky = Color(red: 0.30, green: 0.61, blue: 0.83)
    static let background = Color(uiColor: .systemGroupedBackground)
    static let card = Color(uiColor: .secondarySystemGroupedBackground)
    static let border = Color(uiColor: .separator).opacity(0.22)
}

/// Anchura máxima cómoda para leer en iPad sin perder adaptación al iPhone.
struct GuideUPage<Content: View>: View {
    @AppStorage("GuideU.quietMode") private var quietMode = false
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }

    var body: some View {
        ScrollView {
            content
                .frame(maxWidth: 880)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 18)
                .padding(.vertical, 20)
        }
        .background {
            ZStack {
                GuideUTheme.background
                if !quietMode {
                    LinearGradient(
                        colors: [
                            GuideUTheme.lilac.opacity(0.13),
                            GuideUTheme.sunny.opacity(0.06),
                            GuideUTheme.sky.opacity(0.11)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct GuideUCard<Content: View>: View {
    @AppStorage("GuideU.quietMode") private var quietMode = false
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }

    var body: some View {
        content
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(quietMode ? Color(uiColor: .systemBackground) : GuideUTheme.card)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(GuideUTheme.border, lineWidth: 1)
            )
            .shadow(color: quietMode ? .clear : GuideUTheme.accent.opacity(0.06),
                    radius: 12, y: 5)
    }
}

struct GuideUHero<Content: View>: View {
    @AppStorage("GuideU.quietMode") private var quietMode = false
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }

    var body: some View {
        content
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                    .overlay {
                        if !quietMode {
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [GuideUTheme.lilac.opacity(0.16),
                                                 GuideUTheme.sky.opacity(0.07),
                                                 GuideUTheme.sunny.opacity(0.10)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                    }
                    .overlay(alignment: .topTrailing) {
                        if !quietMode {
                            Circle()
                                .fill(GuideUTheme.accent.opacity(0.08))
                                .frame(width: 150, height: 150)
                                .offset(x: 42, y: -60)
                                .clipped()
                                .accessibilityHidden(true)
                        }
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .strokeBorder(GuideUTheme.accent.opacity(0.12), lineWidth: 1)
            )
    }
}

/// Logo y mascota dibujados en SwiftUI, sin imágenes externas ni recursos remotos.
struct GuideUMascot: View {
    var size: CGFloat = 72

    var body: some View {
        ZStack {
            Circle()
                .fill(GuideUTheme.lilac.opacity(0.21))
            Circle()
                .fill(GuideUTheme.sunny.opacity(0.25))
                .frame(width: size * 0.79, height: size * 0.79)
            Image(systemName: "star.fill")
                .font(.system(size: size * 0.66))
                .foregroundStyle(
                    LinearGradient(colors: [GuideUTheme.sunny, .orange],
                                   startPoint: .top, endPoint: .bottom)
                )
                .shadow(color: GuideUTheme.sunny.opacity(0.30), radius: 3, y: 2)

            HStack(spacing: size * 0.10) {
                Circle().frame(width: size * 0.055, height: size * 0.055)
                Circle().frame(width: size * 0.055, height: size * 0.055)
            }
            .foregroundStyle(Color(red: 0.27, green: 0.20, blue: 0.34))
            .offset(y: -size * 0.032)

            Path { path in
                path.move(to: CGPoint(x: size * 0.43, y: size * 0.54))
                path.addQuadCurve(to: CGPoint(x: size * 0.57, y: size * 0.54),
                                  control: CGPoint(x: size * 0.50, y: size * 0.65))
            }
            .stroke(Color(red: 0.27, green: 0.20, blue: 0.34),
                    style: StrokeStyle(lineWidth: max(1.5, size * 0.025),
                                       lineCap: .round))
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Lumi, la estrella sonriente de GuideU")
    }
}

struct GuideULogo: View {
    var mascotSize: CGFloat = 58

    var body: some View {
        HStack(spacing: 12) {
            GuideUMascot(size: mascotSize)
            VStack(alignment: .leading, spacing: 2) {
                Text("GuideU")
                    .font(.system(.title2, design: .rounded, weight: .heavy))
                    .foregroundStyle(GuideUTheme.accent)
                Text("¡Un mundo a tu ritmo!")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("GuideU. ¡Un mundo a tu ritmo!")
    }
}

struct PrimaryActionLabel: View {
    let title: String
    let symbol: String

    var body: some View {
        Label(title, systemImage: symbol)
            .font(.headline)
            .frame(maxWidth: .infinity, minHeight: 54)
            .contentShape(Rectangle())
    }
}

struct CategoryPill: View {
    let category: ChallengeCategory
    var body: some View {
        Label(category.title, systemImage: category.symbol)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 11)
            .padding(.vertical, 7)
            .background(GuideUTheme.accent.opacity(0.10), in: Capsule())
            .foregroundStyle(GuideUTheme.accent)
    }
}

struct SectionHeading: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title2.bold())
                .accessibilityAddTraits(.isHeader)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
