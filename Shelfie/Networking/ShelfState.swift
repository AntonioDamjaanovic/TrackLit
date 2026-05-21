//
//  ShelfState.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 04.05.2026..
//

import Foundation

enum ShelfState: String, Equatable, CaseIterable, Identifiable, Codable {
    case notOnShelf = "notOnShelf"
    case wantToRead = "wantToRead"
    case currentlyReading = "currentlyReading"
    case read = "read"
    case didNotFinish = "didNotFinish"
    var id: Self { self }
    
    var displayName: String {
        switch self {
            case .notOnShelf:
                "Not on shelf"
            case .wantToRead:
                "Want to read"
            case .currentlyReading:
                "Currenlty reading"
            case .read:
                "Read"
            case .didNotFinish:
                "Did not finish"
        }
    }
}
