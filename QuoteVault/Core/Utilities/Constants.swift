//
//  Constants.swift
//  QuoteVault
//
//  Created by Claude Code
//

import Foundation

enum Constants {
    // MARK: - Supabase Configuration
    enum Supabase {
        static let url = "YOUR_SUPABASE_URL"
        static let anonKey = "YOUR_SUPABASE_ANON_KEY"
    }

    // MARK: - App Configuration
    enum App {
        static let name = "QuoteVault"
        static let quotesPerPage = 20
        static let maxCollectionNameLength = 50
    }

    // MARK: - UserDefaults Keys
    enum UserDefaultsKeys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
        static let lastDailyQuoteDate = "lastDailyQuoteDate"
        static let dailyQuoteId = "dailyQuoteId"
        static let cachedQuotes = "cachedQuotes"
    }

    // MARK: - Notification Identifiers
    enum Notifications {
        static let dailyQuoteIdentifier = "com.quotevault.dailyquote"
        static let categoryIdentifier = "com.quotevault.category"
    }

    // MARK: - Widget
    enum Widget {
        static let kind = "QuoteWidget"
        static let displayName = "Daily Quote"
        static let description = "Display your daily inspirational quote"
    }
}
