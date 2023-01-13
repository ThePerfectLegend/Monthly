//
//  MonthlyWidgets.swift
//  MonthlyWidgets
//
//  Created by Nizami Tagiyev on 13.01.2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> ()) {
        let entry = DayEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DayEntry] = []
        
        let currentStartOfDate = Calendar.current.startOfDay(for: Date())
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentStartOfDate)!
            let entry = DayEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DayEntry: TimelineEntry {
    let date: Date
}

struct MonthlyWidgetsEntryView : View {
    let entry: DayEntry
    let config: MonthConfig
    
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
                        .font(.title)
                    Text(entry.date.formatted(.dateTime.weekday(.wide)))
                        .font(.title3)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.6)
                        .foregroundColor(config.weekdayTextColor)
                }
                Text(entry.date.formatted(.dateTime.day()))
                    .font(.system(size: 80, weight: .heavy))
                    .foregroundColor(config.dayTextColor)
            }
            .padding()
        }
    }
}

struct MonthlyWidgets: Widget {
    let kind: String = "MonthlyWidgets"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MonthlyWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Monthly Style Widgets")
        .description("The theme of the widget based on month.")
        .supportedFamilies([.systemSmall])
    }
}

struct MonthlyWidgets_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyWidgetsEntryView(entry: DayEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
