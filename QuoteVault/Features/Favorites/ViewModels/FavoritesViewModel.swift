//
//  FavoritesViewModel.swift
//  QuoteVault
//
//  MVVM Architecture - ViewModel for Favorites
//

import Foundation
import Combine

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favorites: [Quote] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let favoriteService = FavoriteService()
    private var userId: UUID?

    // MARK: - Load Favorites
    func loadFavorites(userId: UUID) async {
        self.userId = userId
        isLoading = true
        errorMessage = nil

        do {
            favorites = try await favoriteService.fetchFavorites(userId: userId)
        } catch {
            errorMessage = "Failed to load favorites. Please try again."
            print("Error loading favorites: \(error)")
        }

        isLoading = false
    }

    // MARK: - Toggle Favorite
    func toggleFavorite(_ quote: Quote, userId: UUID) async {
        do {
            if quote.isFavorited {
                try await favoriteService.removeFavorite(userId: userId, quoteId: quote.id)

                // Remove from local list
                favorites.removeAll { $0.id == quote.id }
            } else {
                try await favoriteService.addFavorite(userId: userId, quoteId: quote.id)

                // Add to local list
                var updatedQuote = quote
                updatedQuote.isFavorited = true
                favorites.insert(updatedQuote, at: 0)
            }
        } catch {
            errorMessage = "Failed to update favorite. Please try again."
            print("Error toggling favorite: \(error)")
        }
    }

    // MARK: - Refresh
    func refresh(userId: UUID) async {
        await loadFavorites(userId: userId)
    }
}
