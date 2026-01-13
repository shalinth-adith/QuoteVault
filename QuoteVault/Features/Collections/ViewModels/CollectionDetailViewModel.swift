//
//  CollectionDetailViewModel.swift
//  QuoteVault
//
//  MVVM Architecture - ViewModel for Collection Detail
//

import Foundation
import Combine

@MainActor
class CollectionDetailViewModel: ObservableObject {
    @Published var quotes: [Quote] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let collectionService = CollectionService()
    let collection: QuoteCollection

    init(collection: QuoteCollection) {
        self.collection = collection
    }

    // MARK: - Load Quotes
    func loadQuotes() async {
        isLoading = true
        errorMessage = nil

        do {
            quotes = try await collectionService.fetchQuotesInCollection(collectionId: collection.id)
        } catch {
            errorMessage = "Failed to load quotes. Please try again."
            print("Error loading collection quotes: \(error)")
        }

        isLoading = false
    }

    // MARK: - Remove Quote
    func removeQuote(_ quote: Quote) async {
        do {
            try await collectionService.removeQuoteFromCollection(collectionId: collection.id, quoteId: quote.id)
            quotes.removeAll { $0.id == quote.id }
        } catch {
            errorMessage = "Failed to remove quote. Please try again."
            print("Error removing quote: \(error)")
        }
    }
}
