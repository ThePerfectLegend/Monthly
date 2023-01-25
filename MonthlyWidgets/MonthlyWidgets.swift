//
//  MonthlyWidgets.swift
//  MonthlyWidgets
//
//  Created by Nizami Tagiyev on 13.01.2023.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    func getSnapshot(for configuration: ChangeFontIntent, in context: Context, completion: @escaping (DayEntry) -> Void) {
        let entry = DayEntry(date: Date(), showFunFont: false)
        completion(entry)
    }
    
    func getTimeline(for configuration: ChangeFontIntent, in context: Context, completion: @escaping (Timeline<DayEntry>) -> Void) {
        var entries: [DayEntry] = []
        
        let showFunFont = configuration.funFont == 1
        
        let currentStartOfDate = Calendar.current.startOfDay(for: Date())
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentStartOfDate)!
            let entry = DayEntry(date: entryDate, showFunFont: showFunFont)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date(), showFunFont: false)
    }
}

struct DayEntry: TimelineEntry {
    let date: Date
    let showFunFont: Bool
}

struct MonthlyWidgetsEntryView : View {
    let entry: DayEntry
    let config: MonthConfig
    let funFont = "Chalkduster"
    
    init(entry: DayEntry) {
        self.entry = entry
        self.config = MonthConfig.determineConfig(from: entry.date)
    }
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(config.backgroundColor.gradient)
            VStack {
                HStack(spacing: 4) {
                    Text(config.emojiText)
                        .font(.title2)
                    Text(entry.date.formatted(.dateTime.weekday(.wide)))
                        .font(entry.showFunFont ? .custom(funFont, size: 24) : .title3)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.4)
                        .foregroundColor(config.weekdayTextColor)
                }
                Text(entry.date.formatted(.dateTime.day()))
                    .font(entry.showFunFont ? .custom(funFont, size: 80) : .system(size: 80, weight: .heavy))
                    .foregroundColor(config.dayTextColor)
            }
            .padding()
        }
    }
}

struct MonthlyWidgets: Widget {
    let kind: String = "MonthlyWidgets"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ChangeFontIntent.self, provider: Provider()) { entry in
            MonthlyWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Monthly Style Widgets")
        .description("The theme of the widget based on month.")
        .supportedFamilies([.systemSmall])
    }
}
