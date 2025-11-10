import SwiftUI

private let onboardingShownKey = "onboardingShown"

enum AppRoute {
    case loading
    case onboarding
    case main
    case settings
    case step
    case success
}

struct RootView: View {
    @State private var route: AppRoute = .loading

    var body: some View {
        ZStack {
            Color(hex: "#0A1240")
                .ignoresSafeArea()

            Group {
                switch route {
                case .loading:
                    Loading {
                        let defaults = UserDefaults.standard
                        let needsOnboarding = !defaults.bool(
                            forKey: onboardingShownKey
                        )

                        if needsOnboarding {
                            route = .onboarding
                        } else if defaults.bool(
                            forKey: "OnePomodoro.sessionIsRunning"
                        ) {

                            route = .step
                        } else {
                            route = .main
                        }
                    }

                case .onboarding:
                    Onboarding {
                        UserDefaults.standard.set(
                            true,
                            forKey: onboardingShownKey
                        )
                        route = .main
                    }

                case .main:
                    Menu(
                        onSettings: {
                            route = .settings
                        },
                        onStart: {
                            route = .step
                        }
                    )

                case .settings:
                    Settings(onBack: {
                        route = .main
                    })

                case .step:
                    StepView(
                        onBack: {
                            route = .main
                        },
                        onFinish: {
                            route = .success
                        }
                    )

                case .success:
                    Success(
                        onBack: {
                            route = .main
                        },
                        onContinue: {
                            route = .step
                        }
                    )
                }
            }
            .transition(
                .asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                )
            )
        }
        .animation(.easeInOut(duration: 0.30), value: route)
    }
}

#Preview {
    RootView()
}
