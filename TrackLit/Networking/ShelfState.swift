//
//  ShelfState.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 04.05.2026..
//

import Foundation

enum ShelfState: String, Equatable, CaseIterable, Identifiable, Codable {
    case notOnShelf = "notOnShelf"
    case currentlyReading = "currentlyReading"
    case wantToRead = "wantToRead"
    case read = "read"
    case didNotFinish = "didNotFinish"
    var id: Self { self }
    
    var displayName: String {
        switch self {
            case .notOnShelf:
                "Not on shelf"
            case .currentlyReading:
                "Currenlty reading"
            case .wantToRead:
                "Want to read"
            case .read:
                "Read"
            case .didNotFinish:
                "Did not finish"
        }
    }
}
