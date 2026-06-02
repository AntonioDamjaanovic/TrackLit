//
//  TrackLitApp.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 19.04.2026..
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct TrackLitApp: App {
    
    init() {
        FirebaseApp.configure()
        UserDefaults.standard.register(defaults: [
            UserDefaultsKeys.notificationsEnabled: true
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
