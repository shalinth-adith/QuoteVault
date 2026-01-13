//
//  FavoriteService.swift
//  QuoteVault
//
//  Created by Claude Code
//

import Foundation
import Supabase

class FavoriteService {
    private let client = SupabaseService.shared.client

    // MARK: - Add Favorite
    func addFavorite(userId: UUID, quoteId: UUID) async throws {
        let favorite: [String: String] = [
            "user_id": userId.uuidString,
            "quote_id": quoteId.uuidString
        ]

        try await client
            .from("user_favorites")
            .insert(favorite)
            .execute()
    }

    // MARK: - Remove Favorite
    func removeFavorite(userId: UUID, quoteId: UUID) async throws {
        try await client
            .from("user_favorites")
            .delete()
            .eq("user_id", value: userId.uuidString)
            .eq("quote_id", value: quoteId.uuidString)
            .execute()
    }

    // MARK: - Check if Favorited
    func isFavorited(userId: UUID, quoteId: UUID) async throws -> Bool {
        let response = try await client
            .from("user_favorites")
            .select("id")
            .eq("user_id", value: userId.uuidString)
            .eq("quote_id", value: quoteId.uuidString)
            .limit(1)
            .execute()

        return !response.data.isEmpty
    }

    // MARK: - Fetch User Favorites
    func fetchFavorites(userId: UUID) async throws -> [Quote] {
        // First get favorite IDs
        let favoritesResponse = try await client
            .from("user_favorites")
            .select("quote_id")
            .eq("user_id", value: userId.uuidString)
            .order("created_at", ascending: false)
            .execute()

        let decoder = JSONDecoder()
        let favorites = try decoder.decode([[String: String]].self, from: favoritesResponse.data)

        let quoteIds = favorites.compactMap { UUID(uuidString: $0["quote_id"] ?? "") }

        if quoteIds.isEmpty {
            return []
        }

        // Fetch quotes
        let quotesResponse = try await client
            .from("quotes")
            .select()
            .in("id", values: quoteIds.map { $0.uuidString })
            .execute()

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        var quotes = try decoder.decode([Quote].self, from: quotesResponse.data)

        // Mark as favorited
        quotes = quotes.map { quote in
            var updatedQuote = quote
            updatedQuote.isFavorited = true
            return updatedQuote
        }

        return quotes
    }

    // MARK: - Get Favorite IDs
    func fetchFavoriteIds(userId: UUID) async throws -> Set<UUID> {
        let response = try await client
            .from("user_favorites")
            .select("quote_id")
            .eq("user_id", value: userId.uuidString)
            .execute()

        let decoder = JSONDecoder()
        let favorites = try decoder.decode([[String: String]].self, from: response.data)

        let quoteIds = favorites.compactMap { UUID(uuidString: $0["quote_id"] ?? "") }
        return Set(quoteIds)
    }
}
