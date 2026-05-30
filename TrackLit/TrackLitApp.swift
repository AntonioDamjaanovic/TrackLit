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
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
