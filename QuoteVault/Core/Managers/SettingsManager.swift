//
//  SettingsManager.swift
//  QuoteVault
//
//  Created by Claude Code
//

import Foundation
import Combine

class SettingsManager: ObservableObject {
    @Published var notificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        }
    }

    @Published var notificationTime: Date {
        didSet {
            UserDefaults.standard.set(notificationTime, forKey: "notificationTime")
        }
    }

    init() {
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")

        if let savedTime = UserDefaults.standard.object(forKey: "notificationTime") as? Date {
            self.notificationTime = savedTime
        } else {
            // Default to 9:00 AM
            self.notificationTime = Calendar.current.date(
                bySettingHour: 9,
                minute: 0,
                second: 0,
                of: Date()
            ) ?? Date()
        }
    }

    func syncSettings(with userSettings: UserSettings) {
        notificationsEnabled = userSettings.notificationsEnabled
        notificationTime = userSettings.notificationTime
    }

    func getUserSettings() -> UserSettings {
        return UserSettings(
            notificationsEnabled: notificationsEnabled,
            notificationTime: notificationTime
        )
    }
}
