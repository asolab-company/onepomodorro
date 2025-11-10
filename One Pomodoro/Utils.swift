import SwiftUI

enum Device {
    static var isSmall: Bool {
        UIScreen.main.bounds.height < 700
    }

    static var isMedium: Bool {
        UIScreen.main.bounds.height >= 700 && UIScreen.main.bounds.height < 850
    }

    static var isLarge: Bool {
        UIScreen.main.bounds.height >= 850
    }
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

extension View {
    func montserrat(_ weight: MontserratWeight, _ size: CGFloat) -> some View {
        self.font(.custom(weight.rawValue, size: size))
    }
}
extension Text {
    func montserrat(_ weight: MontserratWeight, _ size: CGFloat) -> Text {
        self.font(.custom(weight.rawValue, size: size))
    }
}

enum MontserratWeight: String {
    case thin = "Montserrat-Thin"
    case thinItalic = "Montserrat-ThinItalic"

    case light = "Montserrat-Light"
    case lightItalic = "Montserrat-LightItalic"

    case regular = "Montserrat-Regular"
    case italic = "Montserrat-Italic"

    case medium = "Montserrat-Medium"
    case mediumItalic = "Montserrat-MediumItalic"

    case semiBold = "Montserrat-SemiBold"
    case semiBoldItalic = "Montserrat-SemiBoldItalic"

    case bold = "Montserrat-Bold"
    case boldItalic = "Montserrat-BoldItalic"

    case extraBold = "Montserrat-ExtraBold"
    case extraBoldItalic = "Montserrat-ExtraBoldItalic"

    case black = "Montserrat-Black"
    case blackItalic = "Montserrat-BlackItalic"
}

enum Links {

    static let applink = URL(string: "")!
    static let terms = URL(
        string:
            "https://docs.google.com/document/d/e/2PACX-1vSDH0qCGDvKjB4Ap7IeZPJfSOofudnZHAxUWiiLg0W-sDuB6NrsvGzQfo8WEcn94WmGQw-V_YeL3-Ne/pub"
    )!
    static let policy = URL(
        string:
            "https://docs.google.com/document/d/e/2PACX-1vSDH0qCGDvKjB4Ap7IeZPJfSOofudnZHAxUWiiLg0W-sDuB6NrsvGzQfo8WEcn94WmGQw-V_YeL3-Ne/pub"
    )!

    static var shareMessage: String {
        """
        Benefits of the Pomodoro Technique.
        Download the app now:  
        \(applink.absoluteString)
        """
    }

    static var shareItems: [Any] { [shareMessage, applink] }
}
