//
//  CollectionService.swift
//  QuoteVault
//
//  Created by Claude Code
//

import Foundation
import Supabase

class CollectionService {
    private let client = SupabaseService.shared.client

    // MARK: - Create Collection
    func createCollection(userId: UUID, name: String) async throws -> QuoteCollection {
        let collection: [String: String] = [
            "user_id": userId.uuidString,
            "name": name
        ]

        let response = try await client
            .from("collections")
            .insert(collection)
            .select()
            .single()
            .execute()

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let newCollection = try decoder.decode(QuoteCollection.self, from: response.data)
        return newCollection
    }

    // MARK: - Fetch Collections
    func fetchCollections(userId: UUID) async throws -> [QuoteCollection] {
        let response = try await client
            .from("collections")
            .select("""
                id,
                name,
                user_id,
                created_at,
                collection_quotes (count)
            """)
            .eq("user_id", value: userId.uuidString)
            .order("created_at", ascending: false)
            .execute()

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        // Custom decoding to handle count
        var collections = try decoder.decode([QuoteCollection].self, from: response.data)
        return collections
    }

    // MARK: - Delete Collection
    func deleteCollection(collectionId: UUID) async throws {
        // Delete collection quotes first
        try await client
            .from("collection_quotes")
            .delete()
            .eq("collection_id", value: collectionId.uuidString)
            .execute()

        // Delete collection
        try await client
            .from("collections")
            .delete()
            .eq("id", value: collectionId.uuidString)
            .execute()
    }

    // MARK: - Add Quote to Collection
    func addQuoteToCollection(collectionId: UUID, quoteId: UUID) async throws {
        let collectionQuote: [String: String] = [
            "collection_id": collectionId.uuidString,
            "quote_id": quoteId.uuidString
        ]

        try await client
            .from("collection_quotes")
            .insert(collectionQuote)
            .execute()
    }

    // MARK: - Remove Quote from Collection
    func removeQuoteFromCollection(collectionId: UUID, quoteId: UUID) async throws {
        try await client
            .from("collection_quotes")
            .delete()
            .eq("collection_id", value: collectionId.uuidString)
            .eq("quote_id", value: quoteId.uuidString)
            .execute()
    }

    // MARK: - Fetch Quotes in Collection
    func fetchQuotesInCollection(collectionId: UUID) async throws -> [Quote] {
        // First get quote IDs in collection
        let response = try await client
            .from("collection_quotes")
            .select("quote_id")
            .eq("collection_id", value: collectionId.uuidString)
            .order("added_at", ascending: false)
            .execute()

        let decoder = JSONDecoder()
        let collectionQuotes = try decoder.decode([[String: String]].self, from: response.data)

        let quoteIds = collectionQuotes.compactMap { UUID(uuidString: $0["quote_id"] ?? "") }

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
        let quotes = try decoder.decode([Quote].self, from: quotesResponse.data)

        return quotes
    }

    // MARK: - Check if Quote is in Collection
    func isQuoteInCollection(collectionId: UUID, quoteId: UUID) async throws -> Bool {
        let response = try await client
            .from("collection_quotes")
            .select("id")
            .eq("collection_id", value: collectionId.uuidString)
            .eq("quote_id", value: quoteId.uuidString)
            .limit(1)
            .execute()

        return !response.data.isEmpty
    }

    // MARK: - Update Collection Name
    func updateCollectionName(collectionId: UUID, name: String) async throws {
        try await client
            .from("collections")
            .update(["name": name])
            .eq("id", value: collectionId.uuidString)
            .execute()
    }
}
