//
//  NotificationService.swift
//  QuoteVault
//
//  Created by Claude Code
//

import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()

    private init() {}

    // MARK: - Request Permission
    func requestAuthorization() async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
        return granted
    }

    // MARK: - Schedule Daily Quote Notification
    func scheduleDailyQuoteNotification(at time: Date, quote: Quote) async throws {
        let center = UNUserNotificationCenter.current()

        // Remove existing notifications
        center.removePendingNotificationRequests(withIdentifiers: [Constants.Notifications.dailyQuoteIdentifier])

        let content = UNMutableNotificationContent()
        content.title = "Quote of the Day"
        content.body = "\"\(quote.text)\" - \(quote.author)"
        content.sound = .default
        content.categoryIdentifier = Constants.Notifications.categoryIdentifier

        // Create date components for the time
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: Constants.Notifications.dailyQuoteIdentifier,
            content: content,
            trigger: trigger
        )

        try await center.add(request)
    }

    // MARK: - Cancel Daily Notification
    func cancelDailyNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [Constants.Notifications.dailyQuoteIdentifier])
    }

    // MARK: - Check Notification Status
    func checkNotificationStatus() async -> UNAuthorizationStatus {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        return settings.authorizationStatus
    }
}
