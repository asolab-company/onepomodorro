import SwiftUI
import UserNotifications

struct StepView: View {
    var onBack: () -> Void = {}
    var onFinish: () -> Void = {}
    @Environment(\.openURL) private var openURL
    @State private var showShare = false

    @State private var isRunning = false
    @State private var remainingSeconds: Int = 25 * 60
    @State private var timer: Timer?
    @State private var isPaused = false
    @State private var isRest = false
    @State private var totalDurationSeconds: Int = 25 * 60

    @Environment(\.scenePhase) private var scenePhase
    @State private var sessionStartDate: Date?
    @State private var sessionEndDate: Date?

    private let kSessionEnd = "OnePomodoro.sessionEnd"
    private let kSessionIsRest = "OnePomodoro.sessionIsRest"
    private let kSessionIsRunning = "OnePomodoro.sessionIsRunning"

    private var progress: CGFloat {
        guard totalDurationSeconds > 0 else { return 0 }
        return 1 - CGFloat(remainingSeconds) / CGFloat(totalDurationSeconds)
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [
            .alert, .sound, .badge,
        ]) { granted, _ in
            if !granted {
                print("🔕 Notifications permission not granted")
            }
        }
    }

    private func scheduleEndNotification(seconds: Int, isRest: Bool) {
        let content = UNMutableNotificationContent()
        if isRest {
            content.title = "Rest finished"
            content.body = "Time to get back to work."
        } else {
            content.title = "Work session finished"
            content.body = "Take a 5‑minute break."
        }
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(max(1, seconds)),
            repeats: false
        )
        let req = UNNotificationRequest(
            identifier: "onepomodoro.session.end",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(req)
    }

    private func cancelAllNotifications() {
        UNUserNotificationCenter.current()
            .removeAllPendingNotificationRequests()
    }

    private func persistSessionState() {
        let defaults = UserDefaults.standard
        if let end = sessionEndDate {
            defaults.set(end.timeIntervalSince1970, forKey: kSessionEnd)
        } else {
            defaults.removeObject(forKey: kSessionEnd)
        }
        defaults.set(isRest, forKey: kSessionIsRest)
        defaults.set(isRunning, forKey: kSessionIsRunning)
    }

    private func restoreSessionStateIfNeeded(now: Date = Date()) {
        let defaults = UserDefaults.standard
        guard defaults.bool(forKey: kSessionIsRunning) else { return }
        let endTs = defaults.double(forKey: kSessionEnd)
        guard endTs > 0 else { return }
        let endDate = Date(timeIntervalSince1970: endTs)
        let remaining = Int(max(0, endDate.timeIntervalSince(now)))
        isRest = defaults.bool(forKey: kSessionIsRest)
        sessionEndDate = endDate
        sessionStartDate = Date(
            timeIntervalSince1970: endTs - Double(remaining)
        )
        totalDurationSeconds =
            remaining > 0
            ? Int(endDate.timeIntervalSince(sessionStartDate ?? now))
            : (isRest ? 5 * 60 : 25 * 60)
        remainingSeconds = remaining
        if remaining > 0 {
            isRunning = true

            startForegroundTicking()
        } else {

            if isRest {
                stopAll(resetToStart: true)
            } else {
                stopAll()
            }
        }
    }

    private func startForegroundTicking() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            _ in
            let now = Date()
            if let end = sessionEndDate {
                let remaining = Int(max(0, end.timeIntervalSince(now)))
                remainingSeconds = remaining
                if remaining == 0 {

                    if isRest {
                        stopAll(resetToStart: true)
                    } else {
                        stopAll()
                    }
                }
            }
        }
    }

    private func startWork() {
        requestNotificationPermission()
        isRest = false
        isPaused = false
        if isRunning { return }
        isRunning = true
        totalDurationSeconds = 25 * 60
        remainingSeconds = totalDurationSeconds
        sessionStartDate = Date()
        sessionEndDate = sessionStartDate!.addingTimeInterval(
            TimeInterval(totalDurationSeconds)
        )
        persistSessionState()
        cancelAllNotifications()
        scheduleEndNotification(seconds: totalDurationSeconds, isRest: false)
        startForegroundTicking()
    }

    private func startRest(minutes: Int) {
        requestNotificationPermission()
        isRest = true
        isPaused = false
        if isRunning { return }
        isRunning = true
        totalDurationSeconds = minutes * 60
        remainingSeconds = totalDurationSeconds
        sessionStartDate = Date()
        sessionEndDate = sessionStartDate!.addingTimeInterval(
            TimeInterval(totalDurationSeconds)
        )
        persistSessionState()
        cancelAllNotifications()
        scheduleEndNotification(seconds: totalDurationSeconds, isRest: true)
        startForegroundTicking()
    }

    private func stopAll(resetToStart: Bool = false) {
        isRunning = false
        cancelAllNotifications()
        timer?.invalidate()
        timer = nil
        if resetToStart {

            isPaused = false
            isRest = false
            totalDurationSeconds = 25 * 60
            remainingSeconds = totalDurationSeconds
        } else {

            isPaused = true
        }
        sessionStartDate = nil
        sessionEndDate = nil
        persistSessionState()
    }

    private func formatTime(_ total: Int) -> String {
        let m = total / 60
        let s = total % 60
        return String(format: "%02d:%02d", m, s)
    }

    var body: some View {
        ZStack(alignment: .top) {

            VStack(spacing: 10) {

                HStack {
                    Button(action: {
                        stopAll(resetToStart: true)
                        onBack()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    Spacer()

                }
                .padding(.horizontal, 30)
                .padding(.top, 8)

                Spacer()

                Text(
                    isRest
                        ? "REST"
                        : (isRunning ? "WORK" : (isPaused ? "PAUSE" : "START"))
                )
                .montserrat(.blackItalic, 24)
                .foregroundStyle(Color(hex: "00A3FF"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)

                if !isRunning && !isPaused {
                    VStack(alignment: .leading, spacing: 3) {
                        benefitItem(rest: "Choose a task")
                        benefitItem(
                            rest:
                                "When you're ready to start working, start the timer."
                        )
                    }
                    .padding(.bottom)
                    .padding(.horizontal, 30)
                } else if isRunning && !isRest {
                    VStack(alignment: .leading, spacing: 6) {
                        benefitItem(
                            rest:
                                "Set the timer for 25 minutes and work all this time"
                        )
                        benefitItem(
                            rest: "If you want, you can stop the timer."
                        )
                    }
                    .padding(.bottom)
                    .padding(.horizontal, 30)
                } else if isRunning && isRest {
                    VStack(alignment: .leading, spacing: 6) {
                        benefitItem(
                            rest:
                                "Great, when the rest period is over, you can repeat the cycle if the task isn't completed."
                        )
                    }
                    .padding(.bottom)
                    .padding(.horizontal, 30)
                } else {
                    if isRest {
                        VStack(alignment: .leading, spacing: 6) {
                            benefitItem(
                                rest:
                                    "Great, when the rest period is over, you can repeat the cycle if the task isn't completed."
                            )
                        }
                        .padding(.bottom)
                        .padding(.horizontal, 30)
                    } else {
                        VStack(alignment: .leading, spacing: 6) {
                            benefitItem(rest: "Take a break for 5 minutes")
                            benefitItem(
                                rest:
                                    "When you're ready to start breakup, start the timer."
                            )
                        }
                        .padding(.bottom)
                        .padding(.horizontal, 30)
                    }
                }

                TimerCircleView(progress: progress, isRunning: isRunning)
                    .padding(.vertical, Device.isSmall ? 10 : 30)

                Text(formatTime(remainingSeconds))
                    .montserrat(.semiBold, 32)
                    .foregroundColor(.white)
                    .opacity(isRunning ? 1 : 0)
                    .animation(.easeInOut(duration: 0.25), value: isRunning)

                Button(action: {
                    if isRunning {
                        if isRest {
                            stopAll(resetToStart: true)
                            onFinish()

                        } else {
                            stopAll()
                        }
                    } else {
                        if isPaused {

                            startRest(minutes: 5)
                        } else {

                            startWork()
                        }
                    }
                }) {
                    ZStack {
                        Text(
                            isRunning
                                ? "Stop"
                                : (isPaused
                                    ? "Сontinue\n(Take a break for 5 minutes)"
                                    : "Start")
                        )
                        .montserrat(.medium, 16)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

                        .padding(.horizontal, 20)
                    }

                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(BtnStyle())
                .padding(.horizontal)

                Button(action: {
                    startRest(minutes: 30)
                }) {
                    ZStack {
                        Text("The task is completed\n(Take a 30 minutes break)")
                            .montserrat(.medium, 16)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 20)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(BtnStyle())
                .frame(height: 60)
                .padding(.horizontal)
                .opacity(isPaused && !isRest ? 1 : 0)

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
        .onAppear {
            requestNotificationPermission()
            restoreSessionStateIfNeeded()
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                restoreSessionStateIfNeeded()
            case .background:
                persistSessionState()
            default:
                break
            }
        }

    }

    @ViewBuilder
    private func benefitItem(rest: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Text("•")
                .montserrat(.semiBold, 16)
                .foregroundColor(.white)
                .padding(.top, 2)

            Text(rest)
                .montserrat(.semiBold, 16)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TimerCircleView: View {
    var progress: CGFloat
    var isRunning: Bool
    var body: some View {
        ZStack {
            if isRunning {

                Circle()
                    .stroke(Color(hex: "162C80"), lineWidth: 10)

                Circle()
                    .trim(from: 0, to: max(0, min(1, progress)))
                    .stroke(
                        Color.white,
                        style: StrokeStyle(
                            lineWidth: 10,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))

            }

            Image("app_bg_timer")
                .resizable()
                .scaledToFit()
                .padding(12)
        }
        .frame(
            width: Device.isSmall ? 220 : 270,
            height: Device.isSmall ? 220 : 270
        )
    }
}
#Preview {
    StepView()
}
