//
//  QuoteWidget.swift
//  QuoteVault
//
//  iOS Widget for displaying daily quotes
//
//  SETUP INSTRUCTIONS:
//  1. In Xcode, go to File > New > Target
//  2. Select "Widget Extension"
//  3. Name it "QuoteVaultWidget"
//  4. Replace the generated widget code with this file
//  5. Add this file to the Widget Extension target
//  6. Ensure WidgetKit and SwiftUI are imported
//

import WidgetKit
import SwiftUI

// MARK: - Widget Entry
struct QuoteEntry: TimelineEntry {
    let date: Date
    let quote: SimpleQuote
}

// MARK: - Simple Quote Model (for Widget)
struct SimpleQuote: Codable {
    let text: String
    let author: String
    let category: String

    static let placeholder = SimpleQuote(
        text: "The only way to do great work is to love what you do.",
        author: "Steve Jobs",
        category: "Motivation"
    )
}

// MARK: - Widget Timeline Provider
struct QuoteProvider: TimelineProvider {
    func placeholder(in context: Context) -> QuoteEntry {
        QuoteEntry(date: Date(), quote: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> Void) {
        let entry = QuoteEntry(date: Date(), quote: .placeholder)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> Void) {
        // Fetch daily quote (in a real implementation, this would call your API)
        let currentDate = Date()
        let entry = QuoteEntry(date: currentDate, quote: .placeholder)

        // Update widget once per day at midnight
        let midnight = Calendar.current.startOfDay(for: Date().addingTimeInterval(86400))
        let timeline = Timeline(entries: [entry], policy: .after(midnight))

        completion(timeline)
    }
}

// MARK: - Widget View
struct QuoteWidgetView: View {
    @Environment(\.widgetFamily) var family
    let entry: QuoteEntry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            MediumWidgetView(entry: entry)
        }
    }
}

// MARK: - Small Widget (Compact)
struct SmallWidgetView: View {
    let entry: QuoteEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Quote of the Day")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.8))

            Spacer()

            Text("\"\(entry.quote.text)\"")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .lineLimit(4)

            Text("— \(entry.quote.author)")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(1)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

// MARK: - Medium Widget (Balanced)
struct MediumWidgetView: View {
    let entry: QuoteEntry

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 60, height: 60)

                Image(systemName: "quote.bubble.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }

            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text("Quote of the Day")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.8))

                Text("\"\(entry.quote.text)\"")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .lineLimit(3)

                Text("— \(entry.quote.author)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

// MARK: - Large Widget (Full Quote)
struct LargeWidgetView: View {
    let entry: QuoteEntry

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: "sun.max.fill")
                    .foregroundColor(.yellow)
                Text("Quote of the Day")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            .foregroundColor(.white)

            Spacer()

            // Quote
            VStack(spacing: 12) {
                Text("\"\(entry.quote.text)\"")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(5)

                Text("— \(entry.quote.author)")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .italic()
            }

            Spacer()

            // Category Badge
            HStack {
                Spacer()
                Text(entry.quote.category.uppercased())
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple, Color.pink]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

// MARK: - Widget Configuration
@main
struct QuoteWidget: Widget {
    let kind: String = "QuoteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuoteProvider()) { entry in
            QuoteWidgetView(entry: entry)
        }
        .configurationDisplayName("Daily Quote")
        .description("Get inspired with a new quote every day.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Widget Preview
struct QuoteWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            QuoteWidgetView(entry: QuoteEntry(date: Date(), quote: .placeholder))
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            QuoteWidgetView(entry: QuoteEntry(date: Date(), quote: .placeholder))
                .previewContext(WidgetPreviewContext(family: .systemMedium))

            QuoteWidgetView(entry: QuoteEntry(date: Date(), quote: .placeholder))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
