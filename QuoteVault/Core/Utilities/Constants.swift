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
        static let url = "https://evfuwssmwjmkvsunzsjn.supabase.co"
        static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV2ZnV3c3Ntd2pta3ZzdW56c2puIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgzMDQ3NjMsImV4cCI6MjA4Mzg4MDc2M30.ckTr2cEUEODLEANaQmcrjZuRj8MvCRVDsgIhXfXCF10"
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
