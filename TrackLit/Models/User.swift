//
//  User.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 25.05.2026..
//

import Foundation

struct User: Codable, Equatable, Identifiable {
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
}
