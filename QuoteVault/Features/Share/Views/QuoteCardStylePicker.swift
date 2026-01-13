//
//  QuoteCardStylePicker.swift
//  QuoteVault
//
//  Quote card style picker for image sharing
//

import SwiftUI

enum QuoteCardStyle: String, CaseIterable, Identifiable {
    case gradient = "Gradient"
    case minimal = "Minimal"
    case elegant = "Elegant"
    case bold = "Bold"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .gradient:
            return "Colorful gradient background"
        case .minimal:
            return "Clean and simple"
        case .elegant:
            return "Classic serif typography"
        case .bold:
            return "High contrast with bold colors"
        }
    }
}

struct QuoteCardStylePicker: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager

    let quote: Quote
    @State private var selectedStyle: QuoteCardStyle = .gradient
    @State private var isGenerating = false
    @State private var generatedImage: UIImage?
    @State private var showShareSheet = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Style Preview
                ScrollView {
                    VStack(spacing: 16) {
                        Text("Choose a Style")
                            .font(.headline)
                            .padding(.top)

                        // Preview Card
                        cardView(for: selectedStyle)
                            .frame(maxWidth: 350)
                            .aspectRatio(1.0, contentMode: .fit)
                            .padding(.horizontal)

                        // Style Options
                        VStack(spacing: 12) {
                            ForEach(QuoteCardStyle.allCases) { style in
                                Button(action: {
                                    selectedStyle = style
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(style.rawValue)
                                                .font(.headline)
                                            Text(style.description)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }

                                        Spacer()

                                        if selectedStyle == style {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(themeManager.primaryColor)
                                        } else {
                                            Image(systemName: "circle")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .foregroundColor(.primary)
                                    .padding()
                                    .background(themeManager.secondaryBackgroundColor)
                                    .cornerRadius(12)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // Share Button
                Button(action: {
                    generateAndShare()
                }) {
                    HStack {
                        if isGenerating {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Image")
                        }
                    }
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.primaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(isGenerating)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Quote Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                if let image = generatedImage {
                    ActivityViewController(activityItems: [image])
                }
            }
        }
    }

    // MARK: - Card View Generator
    @ViewBuilder
    private func cardView(for style: QuoteCardStyle) -> some View {
        switch style {
        case .gradient:
            GradientQuoteCard(quote: quote)
        case .minimal:
            MinimalQuoteCard(quote: quote)
        case .elegant:
            ElegantQuoteCard(quote: quote)
        case .bold:
            BoldQuoteCard(quote: quote)
        }
    }

    // MARK: - Generate and Share
    private func generateAndShare() {
        isGenerating = true

        let cardView = cardView(for: selectedStyle)
            .frame(width: 800, height: 800)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let renderer = ImageRenderer(content: cardView)
            renderer.scale = 3.0

            if let image = renderer.uiImage {
                generatedImage = image
                isGenerating = false
                showShareSheet = true
            } else {
                isGenerating = false
            }
        }
    }
}

// MARK: - Gradient Card Style
struct GradientQuoteCard: View {
    let quote: Quote

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 16) {
                Text("\"\(quote.text)\"")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)

                Text("— \(quote.author)")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white.opacity(0.9))
                    .italic()
            }
            .padding(40)

            Spacer()

            HStack {
                Image(systemName: quote.category.icon)
                    .font(.caption)
                Text(quote.category.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white.opacity(0.8))
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    quote.category.color,
                    quote.category.color.opacity(0.7)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

// MARK: - Minimal Card Style
struct MinimalQuoteCard: View {
    let quote: Quote

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 20) {
                Text("\"\(quote.text)\"")
                    .font(.system(size: 28, weight: .regular))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)

                Text("— \(quote.author)")
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(.black.opacity(0.7))
                    .italic()
            }
            .padding(40)

            Spacer()

            Rectangle()
                .fill(quote.category.color)
                .frame(width: 60, height: 4)
                .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

// MARK: - Elegant Card Style
struct ElegantQuoteCard: View {
    let quote: Quote

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Image(systemName: "quote.opening")
                    .font(.system(size: 40))
                    .foregroundColor(quote.category.color)

                Text(quote.text)
                    .font(.system(size: 26, weight: .regular, design: .serif))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .italic()

                Text(quote.author)
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .foregroundColor(.black.opacity(0.8))
                    .tracking(2)
            }
            .padding(40)

            Spacer()

            HStack(spacing: 20) {
                Rectangle()
                    .fill(quote.category.color)
                    .frame(width: 40, height: 2)

                Text(quote.category.rawValue.uppercased())
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.black.opacity(0.6))
                    .tracking(2)

                Rectangle()
                    .fill(quote.category.color)
                    .frame(width: 40, height: 2)
            }
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.98, green: 0.97, blue: 0.95))
    }
}

// MARK: - Bold Card Style
struct BoldQuoteCard: View {
    let quote: Quote

    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Image(systemName: quote.category.icon)
                    .font(.title2)
                Text(quote.category.rawValue.uppercased())
                    .font(.system(size: 16, weight: .bold))
                    .tracking(2)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(quote.category.color)

            Spacer()

            // Quote Content
            VStack(spacing: 24) {
                Text(quote.text)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)

                Text(quote.author)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
                    .tracking(1)
            }
            .padding(40)

            Spacer()

            // Footer
            Text("QuoteVault")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

#Preview {
    QuoteCardStylePicker(
        quote: Quote(
            text: "The only way to do great work is to love what you do.",
            author: "Steve Jobs",
            category: .motivation
        )
    )
    .environmentObject(ThemeManager())
}
