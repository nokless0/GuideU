import SwiftUI

enum GuideUTheme {
    static let accent = Color(red: 0.29, green: 0.32, blue: 0.69)
    static let background = Color(uiColor: .systemGroupedBackground)
    static let card = Color(uiColor: .secondarySystemGroupedBackground)
}

struct GuideUCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(GuideUTheme.card)
            )
    }
}

struct PrimaryActionLabel: View {
    let title: String
    let symbol: String

    var body: some View {
        Label(title, systemImage: symbol)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 54)
            .contentShape(Rectangle())
    }
}

struct CategoryPill: View {
    let category: ChallengeCategory

    var body: some View {
        Label(category.title, systemImage: category.symbol)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(GuideUTheme.accent.opacity(0.10), in: Capsule())
            .foregroundStyle(GuideUTheme.accent)
    }
}
