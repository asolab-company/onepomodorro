//
//  WidgetPomodoroLiveActivity.swift
//  WidgetPomodoro
//
//  Created by VLAD_OS on 10.11.2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WidgetPomodoroAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct WidgetPomodoroLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetPomodoroAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WidgetPomodoroAttributes {
    fileprivate static var preview: WidgetPomodoroAttributes {
        WidgetPomodoroAttributes(name: "World")
    }
}

extension WidgetPomodoroAttributes.ContentState {
    fileprivate static var smiley: WidgetPomodoroAttributes.ContentState {
        WidgetPomodoroAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: WidgetPomodoroAttributes.ContentState {
         WidgetPomodoroAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: WidgetPomodoroAttributes.preview) {
   WidgetPomodoroLiveActivity()
} contentStates: {
    WidgetPomodoroAttributes.ContentState.smiley
    WidgetPomodoroAttributes.ContentState.starEyes
}
