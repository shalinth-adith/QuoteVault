//
//  HomeViewModel.swift
//  QuoteVault
//
//  MVVM Architecture - ViewModel for Home
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var quotes: [Quote] = []
    @Published var dailyQuote: Quote?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasMoreQuotes = true

    private let quoteService = QuoteService()
    private var currentPage = 0
    private let pageSize = 20

    init() {
        Task {
            await loadInitialData()
        }
    }

    // MARK: - Load Initial Data
    func loadInitialData() async {
        await loadDailyQuote()
        await loadQuotes()
    }

    // MARK: - Load Daily Quote
    func loadDailyQuote() async {
        do {
            dailyQuote = try await quoteService.fetchDailyQuote()
        } catch {
            print("Failed to load daily quote: \(error)")
        }
    }

    // MARK: - Load Quotes
    func loadQuotes() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            let newQuotes = try await quoteService.fetchQuotes(page: currentPage, limit: pageSize)

            if newQuotes.isEmpty {
                hasMoreQuotes = false
            } else {
                quotes.append(contentsOf: newQuotes)
                currentPage += 1
            }
        } catch {
            errorMessage = "Failed to load quotes. Please try again."
            print("Error loading quotes: \(error)")
        }

        isLoading = false
    }

    // MARK: - Refresh
    func refresh() async {
        currentPage = 0
        quotes = []
        hasMoreQuotes = true
        await loadInitialData()
    }

    // MARK: - Load More
    func loadMoreIfNeeded(currentQuote: Quote) async {
        let thresholdIndex = quotes.index(quotes.endIndex, offsetBy: -5)
        if let currentIndex = quotes.firstIndex(where: { $0.id == currentQuote.id }),
           currentIndex >= thresholdIndex {
            await loadQuotes()
        }
    }
}
