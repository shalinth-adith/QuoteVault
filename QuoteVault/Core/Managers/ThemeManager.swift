//
//  ThemeManager.swift
//  QuoteVault
//
//  Created by Claude Code
//

import Foundation
import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    @Published var currentTheme: UserSettings.AppTheme = .system {
        didSet {
            saveTheme()
        }
    }

    @Published var fontSize: UserSettings.FontSize = .medium {
        didSet {
            saveFontSize()
        }
    }

    init() {
        loadTheme()
        loadFontSize()
    }

    // MARK: - Theme Colors
    var primaryColor: Color {
        switch currentTheme {
        case .light:
            return .blue
        case .dark:
            return .blue
        case .system:
            return .blue
        case .ocean:
            return Color(red: 0.0, green: 0.48, blue: 0.65)
        case .sunset:
            return Color(red: 1.0, green: 0.45, blue: 0.26)
        }
    }

    var backgroundColor: Color {
        switch currentTheme {
        case .light:
            return Color(.systemBackground)
        case .dark:
            return Color(.black)
        case .system:
            return Color(.systemBackground)
        case .ocean:
            return Color(red: 0.95, green: 0.98, blue: 1.0)
        case .sunset:
            return Color(red: 1.0, green: 0.96, blue: 0.93)
        }
    }

    var secondaryBackgroundColor: Color {
        switch currentTheme {
        case .light:
            return Color(.secondarySystemBackground)
        case .dark:
            return Color(red: 0.11, green: 0.11, blue: 0.12)
        case .system:
            return Color(.secondarySystemBackground)
        case .ocean:
            return Color(red: 0.9, green: 0.95, blue: 0.98)
        case .sunset:
            return Color(red: 1.0, green: 0.93, blue: 0.87)
        }
    }

    var textColor: Color {
        switch currentTheme {
        case .light:
            return .primary
        case .dark:
            return .white
        case .system:
            return .primary
        case .ocean:
            return Color(red: 0.0, green: 0.2, blue: 0.3)
        case .sunset:
            return Color(red: 0.3, green: 0.15, blue: 0.05)
        }
    }

    // MARK: - Color Scheme
    var colorScheme: ColorScheme? {
        switch currentTheme {
        case .light, .ocean, .sunset:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }

    // MARK: - Persistence
    private func saveTheme() {
        UserDefaults.standard.set(currentTheme.rawValue, forKey: "selectedTheme")
    }

    private func loadTheme() {
        if let themeString = UserDefaults.standard.string(forKey: "selectedTheme"),
           let theme = UserSettings.AppTheme(rawValue: themeString) {
            currentTheme = theme
        }
    }

    private func saveFontSize() {
        UserDefaults.standard.set(fontSize.rawValue, forKey: "selectedFontSize")
    }

    private func loadFontSize() {
        if let fontSizeString = UserDefaults.standard.string(forKey: "selectedFontSize"),
           let fontSize = UserSettings.FontSize(rawValue: fontSizeString) {
            self.fontSize = fontSize
        }
    }
}
