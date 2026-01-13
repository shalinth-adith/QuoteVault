//
//  Collection.swift
//  QuoteVault
//
//  Created by Claude Code
//

import Foundation

struct QuoteCollection: Identifiable, Codable {
    let id: UUID
    let name: String
    let userId: UUID
    var quoteCount: Int
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case userId = "user_id"
        case quoteCount = "quote_count"
        case createdAt = "created_at"
    }

    init(id: UUID = UUID(), name: String, userId: UUID, quoteCount: Int = 0, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.userId = userId
        self.quoteCount = quoteCount
        self.createdAt = createdAt
    }
}

struct CollectionQuote: Codable {
    let collectionId: UUID
    let quoteId: UUID
    let addedAt: Date

    enum CodingKeys: String, CodingKey {
        case collectionId = "collection_id"
        case quoteId = "quote_id"
        case addedAt = "added_at"
    }
}
