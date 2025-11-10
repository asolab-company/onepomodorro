import SwiftUI

struct Menu: View {

    var onSettings: () -> Void = {}
    var onStart: () -> Void = {}

    var body: some View {
        ZStack {

            GeometryReader { geo in
                let horizontalPadding: CGFloat = 40
                let barWidth = geo.size.width - horizontalPadding * 4

                VStack(spacing: 10) {
                    Spacer()
                    Image("app_ic_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width - horizontalPadding * 7)
                        .padding(.bottom, 30)

                    (Text("THE POMODORO ")
                        .foregroundColor(.white)
                        .montserrat(.blackItalic, Device.isSmall ? 18 : 22)
                        + Text("TECHNIQUE")
                        .foregroundColor(Color(hex: "#00A3FF"))
                        .montserrat(.blackItalic, Device.isSmall ? 18 : 22))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)

                    VStack(alignment: .leading, spacing: 3) {

                        benefitItem(
                            rest: "Choose a task"
                        )

                        benefitItem(

                            rest:
                                "Set the timer for 25 minutes and work all this time"
                        )

                        benefitItem(

                            rest: "Take a break for 5 minutes"
                        )

                        benefitItem(

                            rest: "Repeat until task is finished"
                        )

                        benefitItem(

                            rest: "Take a 30 minutes break"
                        )

                    }
                    .padding(.bottom)

                    Spacer()
                    Button(action: {
                        onStart()
                    }) {
                        ZStack {
                            Text("Let's Begin")
                                .montserrat(.medium, 16)
                            HStack {
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(
                                        .system(size: 18, weight: .bold)
                                    )
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(BtnStyle())
                    .padding(.bottom, 8)

                    Spacer()

                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .top
                )
                .padding(.horizontal, 20)
                .overlay(alignment: .bottom) {
                    SettingsTab { onSettings() }
                        .frame(maxWidth: .infinity)
                        .frame(height: 68)
                        .padding(.bottom, -geo.safeAreaInsets.bottom)
                }
            }
        }
        .background(
            ZStack {

                Color.black
                    .ignoresSafeArea()
                Image("app_bg_main")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
            }
        )

    }

    @ViewBuilder
    private func benefitItem(rest: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text("•")
                .montserrat(.semiBold, 16)
                .foregroundColor(Color(hex: "#FFFFFF"))

            Text(rest)
                .montserrat(.semiBold, 16)
                .foregroundColor(.white)
        }
    }

}

struct SlantedTabShape: Shape {
    var cornerRadius: CGFloat = 0
    var notchWidth: CGFloat = 140
    var notchDepth: CGFloat = 44

    func path(in rect: CGRect) -> Path {
        let r = min(cornerRadius, min(rect.width, rect.height) / 2)

        let w = min(notchWidth, rect.width * 0.6)
        let d = min(notchDepth, rect.height * 0.8)

        var p = Path()

        p.move(to: CGPoint(x: rect.minX + r, y: rect.minY))

        p.addLine(to: CGPoint(x: rect.minX + r + w, y: rect.minY))

        p.addLine(to: CGPoint(x: rect.minX + r + w + d, y: rect.minY + d))

        p.addLine(to: CGPoint(x: rect.maxX - r, y: rect.minY + d))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + d + r),
            control: CGPoint(x: rect.maxX, y: rect.minY + d)
        )

        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - r))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX - r, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: rect.maxY)
        )

        p.addLine(to: CGPoint(x: rect.minX + r, y: rect.maxY))
        p.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY - r),
            control: CGPoint(x: rect.minX, y: rect.maxY)
        )

        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY + r))
        p.addQuadCurve(
            to: CGPoint(x: rect.minX + r, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )

        return p
    }
}

struct SettingsTab: View {
    var onSettings: () -> Void = {}
    var title: String = "Settings"
    var body: some View {
        ZStack(alignment: .leading) {
            SlantedTabShape(cornerRadius: 0, notchWidth: 180, notchDepth: 36)
                .fill(Color(hex: "#142C83"))

            Button(action: {
                onSettings()
            }) {
                HStack(spacing: 14) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    Text(title)
                        .foregroundColor(.white)
                        .montserrat(.medium, 16)
                }
                .padding(.horizontal, 54)
                .padding(.bottom)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)

    }
}

#Preview {
    Menu()
}
