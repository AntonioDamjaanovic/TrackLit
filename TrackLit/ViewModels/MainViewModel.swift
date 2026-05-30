//
//  MainViewModel.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 25.05.2026..
//

import Foundation
import Observation
import FirebaseAuth

@MainActor
@Observable
class MainViewModel {
    
    private(set) var currentUserId: String = ""
    
    var isSignedIn: Bool {
        !currentUserId.isEmpty
    }
    
    @ObservationIgnored
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUserId = user?.uid ?? ""
        }
    }
    
    deinit {
        if let handler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
}
