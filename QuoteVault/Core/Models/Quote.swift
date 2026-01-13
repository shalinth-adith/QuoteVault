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
}
