import SwiftUI

struct Success: View {
    var onBack: () -> Void = {}
    var onContinue: () -> Void = {}
    @Environment(\.openURL) private var openURL
    @State private var showShare = false

    var body: some View {
        ZStack(alignment: .top) {

            VStack(spacing: 10) {

                HStack {
                    Button(action: { onBack() }) {
                        Image("app_ic_home")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    Spacer()

                }
                .padding(.horizontal, 30)
                .padding(.top, 8)
                .padding(.bottom, 20)

                Text("SUCCESS")
                    .montserrat(.blackItalic, 50)
                    .foregroundStyle(Color.init(hex: "00A3FF"))

                Image("app_bg_welcome")
                    .resizable()
                    .scaledToFit()
                    .frame(height: Device.isSmall ? 350 : 450)

                Button(action: {
                    onContinue()
                }) {
                    ZStack {
                        Text("Restart with the new task")
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
                .padding(.horizontal)

                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
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

#Preview {
    Success()
}
