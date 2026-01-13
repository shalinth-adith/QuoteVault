//
//  QuoteService.swift
//  QuoteVault
//
//  Created by Claude Code
//

import Foundation
import Supabase

class QuoteService {
    private let client = SupabaseService.shared.client

    // MARK: - Fetch Quotes
    func fetchQuotes(page: Int = 0, limit: Int = 20) async throws -> [Quote] {
        let from = page * limit
        let to = from + limit - 1

        let response = try await client
            .from("quotes")
            .select()
            .order("created_at", ascending: false)
            .range(from: from, to: to)
            .execute()

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let quotes = try decoder.decode([Quote].self, from: response.data)
        return quotes
    }

    // MARK: - Fetch Quotes by Category
    func fetchQuotesByCategory(_ category: QuoteCategory, page: Int = 0, limit: Int = 20) async throws -> [Quote] {
        let from = page * limit
        let to = from + limit - 1

        let response = try await client
            .from("quotes")
            .select()
            .eq("category", value: category.rawValue)
            .order("created_at", ascending: false)
            .range(from: from, to: to)
            .execute()

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let quotes = try decoder.decode([Quote].self, from: response.data)
        return quotes
    }

    // MARK: - Search Quotes
    func searchQuotes(query: String) async throws -> [Quote] {
        let response = try await client
            .from("quotes")
            .select()
            .or("text.ilike.%\(query)%,author.ilike.%\(query)%")
            .execute()

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let quotes = try decoder.decode([Quote].self, from: response.data)
        return quotes
    }

    // MARK: - Search by Author
    func searchQuotesByAuthor(author: String) async throws -> [Quote] {
        let response = try await client
            .from("quotes")
            .select()
            .ilike("author", pattern: "%\(author)%")
            .execute()

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let quotes = try decoder.decode([Quote].self, from: response.data)
        return quotes
    }

    // MARK: - Get Quote by ID
    func fetchQuote(id: UUID) async throws -> Quote {
        let response = try await client
            .from("quotes")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let quote = try decoder.decode(Quote.self, from: response.data)
        return quote
    }

    // MARK: - Get Random Quote
    func fetchRandomQuote() async throws -> Quote {
        let response = try await client
            .from("quotes")
            .select()
            .limit(1)
            .execute()

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let quotes = try decoder.decode([Quote].self, from: response.data)

        guard let quote = quotes.first else {
            throw QuoteError.noQuotesFound
        }

        return quote
    }

    // MARK: - Get Daily Quote
    func fetchDailyQuote() async throws -> Quote {
        let today = Calendar.current.startOfDay(for: Date())
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]
        let todayString = dateFormatter.string(from: today)

        // Try to get today's daily quote
        do {
            let response = try await client
                .from("daily_quotes")
                .select("quote_id")
                .eq("date", value: todayString)
                .limit(1)
                .execute()

            let decoder = JSONDecoder()
            let dailyQuotes = try decoder.decode([[String: String]].self, from: response.data)

            if let firstQuote = dailyQuotes.first,
               let quoteIdString = firstQuote["quote_id"],
               let quoteId = UUID(uuidString: quoteIdString) {
                return try await fetchQuote(id: quoteId)
            }
        } catch {
            // No daily quote found, continue to create one
        }

        // No daily quote for today, select a random one and insert it
        let randomQuote = try await fetchRandomQuote()

        let dailyQuote: [String: String] = [
            "quote_id": randomQuote.id.uuidString,
            "date": todayString
        ]

        try? await client
            .from("daily_quotes")
            .insert(dailyQuote)
            .execute()

        return randomQuote
    }
}

// MARK: - Quote Errors
enum QuoteError: LocalizedError {
    case noQuotesFound
    case fetchFailed
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .noQuotesFound:
            return "No quotes found."
        case .fetchFailed:
            return "Failed to fetch quotes."
        case .invalidResponse:
            return "Invalid response from server."
        }
    }
}
