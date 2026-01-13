//
//  Quote.swift
//  QuoteVault
//
//  Created by Claude Code
//

import Foundation

struct Quote: Identifiable, Codable, Equatable {
    let id: UUID
    let text: String
    let author: String
    let category: QuoteCategory
    let createdAt: Date
    var isFavorited: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case author
        case category
        case createdAt = "created_at"
    }

    init(id: UUID = UUID(), text: String, author: String, category: QuoteCategory, createdAt: Date = Date(), isFavorited: Bool = false) {
        self.id = id
        self.text = text
        self.author = author
        self.category = category
        self.createdAt = createdAt
        self.isFavorited = isFavorited
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        author = try container.decode(String.self, forKey: .author)
        category = try container.decode(QuoteCategory.self, forKey: .category)

        // Try to decode createdAt, use current date if it fails
        if let createdAtString = try? container.decode(String.self, forKey: .createdAt) {
            let formatter = ISO8601DateFormatter()
            createdAt = formatter.date(from: createdAtString) ?? Date()
        } else {
            createdAt = Date()
        }

        // isFavorited is not in the database, always defaults to false
        isFavorited = false
    }
}
