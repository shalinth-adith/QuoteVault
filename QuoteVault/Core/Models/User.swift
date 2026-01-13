//
//  User.swift
//  QuoteVault
//
//  Created by Claude Code
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    let email: String
    var name: String?
    var avatarURL: String?
    var settings: UserSettings

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case avatarURL = "avatar_url"
        case settings
    }

    init(id: UUID, email: String, name: String? = nil, avatarURL: String? = nil, settings: UserSettings = UserSettings()) {
        self.id = id
        self.email = email
        self.name = name
        self.avatarURL = avatarURL
        self.settings = settings
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL)

        // Try to decode settings, use default if it fails
        if let settingsData = try? container.decode(UserSettings.self, forKey: .settings) {
            settings = settingsData
        } else {
            settings = UserSettings()
        }
    }
}

struct UserSettings: Codable {
    var theme: AppTheme = .system
    var fontSize: FontSize = .medium
    var notificationsEnabled: Bool = true
    var notificationTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()

    enum AppTheme: String, Codable, CaseIterable {
        case light = "Light"
        case dark = "Dark"
        case system = "System"
        case ocean = "Ocean"
        case sunset = "Sunset"
    }

    enum FontSize: String, Codable, CaseIterable {
        case small = "Small"
        case medium = "Medium"
        case large = "Large"
        case extraLarge = "Extra Large"

        var scale: CGFloat {
            switch self {
            case .small: return 0.9
            case .medium: return 1.0
            case .large: return 1.15
            case .extraLarge: return 1.3
            }
        }
    }
}
