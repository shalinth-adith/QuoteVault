//
//  ShareSheet.swift
//  QuoteVault
//
//  Share functionality for quotes
//

import SwiftUI

struct ShareSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager

    let quote: Quote
    @State private var showStylePicker = false
    @State private var showActivityView = false
    @State private var shareItem: Any?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Quote Preview
                VStack(alignment: .leading, spacing: 12) {
                    Text("\"\(quote.text)\"")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)

                    HStack {
                        Text("— \(quote.author)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .italic()
                        Spacer()
                        CategoryBadge(category: quote.category)
                    }
                }
                .padding()
                .background(themeManager.secondaryBackgroundColor)

                // Share Options
                List {
                    Section("Share Options") {
                        Button(action: {
                            shareAsText()
                        }) {
                            HStack {
                                Image(systemName: "text.quote")
                                    .foregroundColor(themeManager.primaryColor)
                                    .frame(width: 30)

                                VStack(alignment: .leading) {
                                    Text("Share as Text")
                                        .font(.headline)
                                    Text("Plain text format")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .foregroundColor(.primary)
                        }

                        Button(action: {
                            showStylePicker = true
                        }) {
                            HStack {
                                Image(systemName: "photo")
                                    .foregroundColor(themeManager.primaryColor)
                                    .frame(width: 30)

                                VStack(alignment: .leading) {
                                    Text("Share as Image")
                                        .font(.headline)
                                    Text("Choose from beautiful card styles")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
            }
            .navigationTitle("Share Quote")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showStylePicker) {
                QuoteCardStylePicker(quote: quote)
            }
            .sheet(item: $shareItem) { item in
                if let activityItem = item as? ActivityItem {
                    ActivityViewController(activityItems: activityItem.items)
                }
            }
        }
    }

    // MARK: - Share as Text
    private func shareAsText() {
        let text = "\"\(quote.text)\"\n\n— \(quote.author)"
        shareItem = ActivityItem(items: [text])
    }
}

// MARK: - Activity Item Wrapper
struct ActivityItem: Identifiable {
    let id = UUID()
    let items: [Any]
}

// MARK: - UIKit Activity View Controller
struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ShareSheet(
        quote: Quote(
            text: "The only way to do great work is to love what you do.",
            author: "Steve Jobs",
            category: .motivation
        )
    )
    .environmentObject(ThemeManager())
}
