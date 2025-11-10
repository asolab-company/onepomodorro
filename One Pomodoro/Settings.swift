import SwiftUI

struct Settings: View {
    var onBack: () -> Void = {}
    @Environment(\.openURL) private var openURL
    @State private var showShare = false

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 10) {

                HStack {
                    Button(action: { onBack() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    Spacer()

                }
                .padding(.horizontal, 30)
                .padding(.top, 8)
                .padding(.bottom, 20)

                SettingsRow(
                    title: "Share app",
                    systemImage: "app_ic_share"
                ) {
                    showShare = true
                }
                .padding(.horizontal)

                SettingsRow(
                    title: "Terms and Conditions",
                    systemImage: "app_ic_terms"
                ) {
                    openURL(Links.terms)
                }
                .padding(.horizontal)

                SettingsRow(
                    title: "Privacy",
                    systemImage: "app_ic_privacy"
                ) {
                    openURL(Links.policy)
                }
                .padding(.horizontal)

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
        .sheet(isPresented: $showShare) {
            ShareSheet(items: Links.shareItems)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

struct SettingsRow: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                ZStack {
                    Image(systemImage)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(width: 40, height: 40)

                Text(title)
                    .foregroundColor(.white)
                    .montserrat(.bold, 16)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 10)
            }
            .padding(.horizontal, 16)
            .frame(height: 64)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(Color(hex: "162C80"))
        )
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
    }
    func updateUIViewController(
        _ vc: UIActivityViewController,
        context: Context
    ) {}
}

#Preview {
    Settings()
}
