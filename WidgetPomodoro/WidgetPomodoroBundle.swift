//
//  WidgetPomodoroBundle.swift
//  WidgetPomodoro
//
//  Created by VLAD_OS on 10.11.2025.
//

import WidgetKit
import SwiftUI

@main
struct WidgetPomodoroBundle: WidgetBundle {
    var body: some Widget {
        WidgetPomodoro()
        WidgetPomodoroLiveActivity()
    }
}
