//
//  NotificationService.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 01.06.2026..
//

import Foundation
import UserNotifications

final class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationService()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }
    
    // this is needed to to send notification if the app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.banner, .sound]
    }
}

extension NotificationService {
    private static let dailyReminderIdentifier = "dailyReadingReminder"

    func scheduleDailyReadingReminder(hour: Int = 20, minute: Int = 0) async {
        guard UserDefaults.standard.bool(forKey: UserDefaultsKeys.notificationsEnabled) else { return }

        let settings = await UNUserNotificationCenter.current().notificationSettings()
        guard settings.authorizationStatus == .authorized else { return }

        let content = UNMutableNotificationContent()
        content.title = "📚 Time to read"
        content.body = "Don't forget to read for a few minutes today."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: Self.dailyReminderIdentifier,
            content: content,
            trigger: trigger
        )

        // this disables duplicate notifications scheduling
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [Self.dailyReminderIdentifier])

        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Failed to schedule daily reminder: \(error)")
        }
    }

    func cancelDailyReadingReminder() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [Self.dailyReminderIdentifier])
    }

    func sendBookFinishedNotification(bookTitle: String) async {
        guard UserDefaults.standard.bool(forKey: UserDefaultsKeys.notificationsEnabled) else { return }
        
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        guard settings.authorizationStatus == .authorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "📚 finished"
        content.body = "Congrats on finishing \(bookTitle)! Ready for next one?"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Failed to schedule notification: \(error)")
        }
    }
}
