import SwiftUI

struct SetTime: View {


    @AppStorage("focus_time_minutes") private var focusTime: Int = 25
    @AppStorage("pause_time_minutes") private var pauseTime: Int = 15
    @AppStorage("rest_time_minutes")  private var restTime: Int  = 45
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {

            GeometryReader { geo in
                let horizontalPadding: CGFloat = 40
                let barWidth = geo.size.width - horizontalPadding * 4

                VStack(spacing: 10) {
                    
                    HStack {
                        Button(action: {   dismiss()  }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        Spacer()

                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                    
                    Spacer()
                    

                    Text("Set Your Pomodoro Timer")
                        .textCase(.uppercase)
                        .foregroundColor(Color(hex: "#00A3FF"))
                        .montserrat(.blackItalic, Device.isSmall ? 18 : 22)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                    
                    
                    Text("Customize your focus session by choosing how long you want your Pomodoro to last.")
                        .foregroundColor(.white)
                        .montserrat(.semiBold, Device.isSmall ? 14 : 16)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)

                    VStack(alignment: .leading, spacing: 3) {

                        benefitItem(
                            rest: "Select the desired duration for your work interval."
                        )

                        benefitItem(
                            rest: "You can adjust the minutes to create a session that fits your workflow."
                        )

                        benefitItem(
                            rest: "Once you’ve chosen the time, press Start to begin your Pomodoro."
                        )
                    }

                    Text("Take control of your productivity - set the time that works best for you!")
                        .foregroundColor(.white)
                        .montserrat(.semiBold, Device.isSmall ? 14 : 16)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom)

               
                    TimeCapsuleRow(
                        placeholder: "Type your focus time (minutes)",
                        value: $focusTime,
                        options: [15, 25, 45]
                    )

                
                    TimeCapsuleRow(
                        placeholder: "Type your pause time (minutes)",
                        value: $pauseTime,
                        options: [5, 10, 15]
                    )

                    
                    TimeCapsuleRow(
                        placeholder: "Type your rest time (minutes)",
                        value: $restTime,
                        options: [15, 30, 45]
                    )

                    Spacer()
                    Spacer()
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .top
                )
                .padding(.horizontal, 20)
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



struct TimeCapsuleRow: View {
    let placeholder: String
    @Binding var value: Int
    let options: [Int]

    @State private var showDialog = false

    var body: some View {
        Button {
            showDialog = true
        } label: {
            HStack {
                Text(rowText)
                    .foregroundColor(Color(hex: "#00A3FF"))
                    .montserrat(.regular, Device.isSmall ? 14 : 16)
                Spacer()
            }
            .frame(height: 44)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 26)
                    .fill(Color.black.opacity(0.3))
            )
        }
        .buttonStyle(.plain)
        .confirmationDialog("Select time", isPresented: $showDialog, titleVisibility: .visible) {
            ForEach(options, id: \.self) { option in
                Button("\(option) minutes") {
                    value = option
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }


    private var rowText: String {
        if let range = placeholder.range(of: "(minutes)") {
            var s = placeholder
            s.replaceSubrange(range, with: "\(value) minutes")
            return s
        } else {
            return "\(placeholder) \(value) minutes"
        }
    }
}

#Preview {
    SetTime()
}
