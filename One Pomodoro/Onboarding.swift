import SwiftUI

struct Onboarding: View {
    var onContinue: () -> Void = {}

    var body: some View {
        ZStack {

            VStack(spacing: 5) {
                Image("app_bg_welcome")
                    .resizable()
                    .scaledToFill()
                    .frame(height: Device.isSmall ? 280 : 450)

                Spacer()

                (Text("BENEFITS ")
                    .foregroundColor(Color(hex: "#00A3FF"))
                    .montserrat(.blackItalic, Device.isSmall ? 22 : 26)
                    + Text("OF THE\nPOMODORO TECHNIQUE")
                    .foregroundColor(.white)
                    .montserrat(.blackItalic, Device.isSmall ? 22 : 26))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)
                    .padding(.horizontal)
                    .shadow(
                        color: Device.isSmall
                            ? Color(hex: "00164E").opacity(0.9) : .clear,
                        radius: Device.isSmall ? 3 : 0,
                        x: 0,
                        y: Device.isSmall ? 1 : 0
                    )
                    .shadow(
                        color: Device.isSmall
                            ? Color(hex: "00164E").opacity(0.9) : .clear,
                        radius: Device.isSmall ? 3 : 0,
                        x: 0,
                        y: Device.isSmall ? 2 : 0
                    )

                VStack(alignment: .leading, spacing: 3) {

                    benefitItem(
                        bold: "Improves",
                        rest: "Focus and Concentration"
                    )

                    benefitItem(
                        bold: "Prevents",
                        rest: "Burnout"
                    )

                    benefitItem(
                        bold: "Enhances",
                        rest: "Time Awareness"
                    )

                    benefitItem(
                        bold: "Boosts",
                        rest: "Motivation"
                    )

                    benefitItem(
                        bold: "Reduces",
                        rest: "Procrastination"
                    )

                    benefitItem(
                        bold: "Supports",
                        rest: "Work-Life Balance"
                    )

                    benefitItem(
                        bold: "Increases",
                        rest: "Productivity"
                    )
                }
                .padding(.bottom)

                Button(action: {

                    onContinue()
                }) {
                    ZStack {
                        Text("Continue")
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
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(BtnStyle())
                .padding(.bottom, 8)
                .padding(.horizontal)

                TermsFooter().padding(
                    .bottom,
                    60
                )
                .padding(.horizontal)

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
}

@ViewBuilder
private func benefitItem(bold: String, rest: String) -> some View {
    HStack(alignment: .top, spacing: 10) {
        Text("•")
            .montserrat(.semiBold, 16)
            .foregroundColor(Color(hex: "#00A3FF"))

        (Text(bold + " ")
            .montserrat(.semiBold, Device.isSmall ? 14 : 16)
            .foregroundColor(Color(hex: "#00A3FF"))
            + Text(rest)
            .montserrat(.semiBold, Device.isSmall ? 14 : 16)
            .foregroundColor(.white))
    }
}

private struct TermsFooter: View {
    var body: some View {
        VStack(spacing: 2) {
            Text("By Proceeding You Accept")
                .foregroundColor(Color.init(hex: "2850EB"))
                .font(.footnote)

            HStack(spacing: 0) {
                Text("Our ")
                    .foregroundColor(Color.init(hex: "2850EB"))
                    .montserrat(.medium, 12)

                Link("Terms Of Use", destination: Links.terms)

                    .foregroundColor(Color.init(hex: "FFFFFF"))
                    .montserrat(.medium, 12)

                Text(" And ")
                    .foregroundColor(Color.init(hex: "2850EB"))
                    .montserrat(.medium, 12)

                Link("Privacy Policy", destination: Links.policy)
                    .montserrat(.medium, 12)
                    .foregroundColor(Color.init(hex: "FFFFFF"))

            }
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }
}

struct BtnStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(hex: "#2850EB"))
            )
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    Onboarding {
        print("Finished")
    }
}
