import SwiftUI

/// Colores suaves, con texto del sistema para conservar contraste en modo claro y oscuro.
enum GuideUTheme {
    static let accent = Color(red: 0.25, green: 0.31, blue: 0.67)
    static let mint = Color(red: 0.15, green: 0.52, blue: 0.45)
    static let coral = Color(red: 0.73, green: 0.36, blue: 0.34)
    static let background = Color(uiColor: .systemGroupedBackground)
    static let card = Color(uiColor: .secondarySystemGroupedBackground)
    static let border = Color(uiColor: .separator).opacity(0.22)
}

/// Anchura máxima cómoda para leer en iPad sin perder adaptación al iPhone.
struct GuideUPage<Content: View>: View {
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
        .background(GuideUTheme.background.ignoresSafeArea())
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
                    .fill(quietMode
                          ? Color(uiColor: .secondarySystemGroupedBackground)
                          : Color(uiColor: .secondarySystemGroupedBackground))
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

struct GuideUMascot: View {
    var size: CGFloat = 72

    var body: some View {
        ZStack {
            Circle()
                .fill(GuideUTheme.accent.opacity(0.12))
            Image(systemName: "sparkles")
                .font(.system(size: size * 0.46, weight: .semibold))
                .foregroundStyle(GuideUTheme.accent)
        }
        .frame(width: size, height: size)
        .accessibilityLabel("Lumi, la estrella que acompaña GuideU")
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
