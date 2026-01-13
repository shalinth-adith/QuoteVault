//
//  CollectionDetailView.swift
//  QuoteVault
//
//  MVVM Architecture - View for Collection Detail
//

import SwiftUI

struct CollectionDetailView: View {
    @StateObject private var viewModel: CollectionDetailViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showDeleteAlert = false
    @State private var quoteToDelete: Quote?

    init(collection: QuoteCollection) {
        _viewModel = StateObject(wrappedValue: CollectionDetailViewModel(collection: collection))
    }

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.quotes.isEmpty {
                // Empty State
                VStack(spacing: 20) {
                    Image(systemName: "tray")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)

                    Text("No Quotes Yet")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Add quotes to this collection from your favorites or browse")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            } else {
                // Quotes List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.quotes) { quote in
                            CollectionQuoteCard(
                                quote: quote,
                                onRemove: {
                                    quoteToDelete = quote
                                    showDeleteAlert = true
                                }
                            )
                        }
                    }
                    .padding()
                }
            }

            // Error Message
            if let errorMessage = viewModel.errorMessage {
                VStack {
                    Spacer()
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
        .navigationTitle(viewModel.collection.name)
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.loadQuotes()
        }
        .alert("Remove Quote", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                if let quote = quoteToDelete {
                    Task {
                        await viewModel.removeQuote(quote)
                    }
                }
            }
        } message: {
            Text("Are you sure you want to remove this quote from the collection?")
        }
    }
}

// MARK: - Collection Quote Card
struct CollectionQuoteCard: View {
    let quote: Quote
    let onRemove: () -> Void
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Quote Text
            Text(quote.text)
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(4)

            HStack {
                // Author
                Text("— \(quote.author)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .italic()

                Spacer()

                // Category Badge
                CategoryBadge(category: quote.category)
            }

            Divider()

            // Actions
            HStack {
                Spacer()

                Button(action: onRemove) {
                    HStack(spacing: 4) {
                        Image(systemName: "trash")
                            .font(.caption)
                        Text("Remove")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(themeManager.secondaryBackgroundColor)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    NavigationStack {
        CollectionDetailView(collection: QuoteCollection(
            id: UUID(),
            userId: UUID(),
            name: "Inspirational",
            quoteCount: 5,
            createdAt: Date()
        ))
        .environmentObject(ThemeManager())
    }
}
