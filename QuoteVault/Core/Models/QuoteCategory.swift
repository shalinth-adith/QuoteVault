//
//  QuoteCategory.swift
//  QuoteVault
//
//  Created by Claude Code
//

import Foundation
import SwiftUI

enum QuoteCategory: String, Codable, CaseIterable, Identifiable {
    case motivation = "Motivation"
    case love = "Love"
    case success = "Success"
    case wisdom = "Wisdom"
    case humor = "Humor"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .motivation: return "flame.fill"
        case .love: return "heart.fill"
        case .success: return "star.fill"
        case .wisdom: return "brain.head.profile"
        case .humor: return "face.smiling"
        }
    }

    var color: Color {
        switch self {
        case .motivation: return .orange
        case .love: return .pink
        case .success: return .green
        case .wisdom: return .purple
        case .humor: return .yellow
        }
    }
}
