//
//  BrowseViewModel.swift
//  QuoteVault
//
//  MVVM Architecture - ViewModel for Browse
//

import Foundation
import Combine

@MainActor
class BrowseViewModel: ObservableObject {
    @Published var quotes: [Quote] = []
    @Published var selectedCategory: QuoteCategory?
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let quoteService = QuoteService()
    private var searchTask: Task<Void, Never>?

    init() {
        setupSearchDebounce()
    }

    // MARK: - Search Debounce
    private func setupSearchDebounce() {
        // Debounce search to avoid too many API calls
        Task {
            for await searchText in $searchText.values {
                searchTask?.cancel()

                if searchText.isEmpty && selectedCategory == nil {
                    quotes = []
                    continue
                }

                searchTask = Task {
                    try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
                    if !Task.isCancelled {
                        await performSearch()
                    }
                }
            }
        }
    }

    // MARK: - Select Category
    func selectCategory(_ category: QuoteCategory?) async {
        selectedCategory = category
        searchText = "" // Clear search when selecting category
        await loadQuotesByCategory()
    }

    // MARK: - Load Quotes by Category
    func loadQuotesByCategory() async {
        guard let category = selectedCategory else {
            quotes = []
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            quotes = try await quoteService.fetchQuotesByCategory(category, page: 0, limit: 50)
        } catch {
            errorMessage = "Failed to load quotes. Please try again."
            print("Error loading quotes by category: \(error)")
        }

        isLoading = false
    }

    // MARK: - Perform Search
    func performSearch() async {
        guard !searchText.isEmpty else {
            if selectedCategory == nil {
                quotes = []
            }
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            quotes = try await quoteService.searchQuotes(query: searchText)
        } catch {
            errorMessage = "Failed to search quotes. Please try again."
            print("Error searching quotes: \(error)")
        }

        isLoading = false
    }

    // MARK: - Search by Author
    func searchByAuthor(_ author: String) async {
        searchText = author
        isLoading = true
        errorMessage = nil

        do {
            quotes = try await quoteService.searchQuotesByAuthor(author: author)
        } catch {
            errorMessage = "Failed to search by author. Please try again."
            print("Error searching by author: \(error)")
        }

        isLoading = false
    }

    // MARK: - Clear All
    func clearAll() {
        selectedCategory = nil
        searchText = ""
        quotes = []
    }
}
