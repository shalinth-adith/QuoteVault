//
//  NotificationManager.swift
//  QuoteVault
//
//  Manages local push notifications for daily quotes
//

import Foundation
import UserNotifications
import Combine

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published var notificationsEnabled = false
    @Published var notificationTime = Date()

    private let notificationCenter = UNUserNotificationCenter.current()

    private init() {
        loadSettings()
        Task {
            await checkAuthorizationStatus()
        }
    }

    // MARK: - Request Permission
    func requestPermission() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            notificationsEnabled = granted

            if granted {
                await scheduleDailyNotification()
            }

            return granted
        } catch {
            print("Error requesting notification permission: \(error)")
            return false
        }
    }

    // MARK: - Check Authorization Status
    func checkAuthorizationStatus() async {
        let settings = await notificationCenter.notificationSettings()
        notificationsEnabled = settings.authorizationStatus == .authorized
    }

    // MARK: - Schedule Daily Notification
    func scheduleDailyNotification() async {
        // Cancel existing notifications
        notificationCenter.removeAllPendingNotificationRequests()

        guard notificationsEnabled else { return }

        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Your Daily Quote"
        content.body = "Discover today's inspiring quote in QuoteVault"
        content.sound = .default
        content.badge = 1

        // Create date components from notification time
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: notificationTime)

        // Create trigger (repeats daily)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        // Create request
        let request = UNNotificationRequest(
            identifier: "dailyQuote",
            content: content,
            trigger: trigger
        )

        // Schedule notification
        do {
            try await notificationCenter.add(request)
            print("Daily notification scheduled for \(components.hour ?? 9):\(components.minute ?? 0)")
        } catch {
            print("Error scheduling notification: \(error)")
        }
    }

    // MARK: - Update Notification Time
    func updateNotificationTime(_ newTime: Date) async {
        notificationTime = newTime
        saveSettings()
        await scheduleDailyNotification()
    }

    // MARK: - Enable/Disable Notifications
    func setNotificationsEnabled(_ enabled: Bool) async {
        if enabled {
            let granted = await requestPermission()
            if granted {
                notificationsEnabled = true
                await scheduleDailyNotification()
            }
        } else {
            notificationsEnabled = false
            notificationCenter.removeAllPendingNotificationRequests()
        }

        saveSettings()
    }

    // MARK: - Persistence
    private func saveSettings() {
        UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        UserDefaults.standard.set(notificationTime, forKey: "notificationTime")
    }

    private func loadSettings() {
        notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")

        if let savedTime = UserDefaults.standard.object(forKey: "notificationTime") as? Date {
            notificationTime = savedTime
        } else {
            // Default to 9:00 AM
            let calendar = Calendar.current
            notificationTime = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
        }
    }

    // MARK: - Cancel All Notifications
    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
    }
}
