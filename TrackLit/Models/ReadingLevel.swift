//
//  ReadingLevel.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 06.06.2026..
//

import Foundation

enum ReadingLevel: String, Codable, CaseIterable, Comparable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"

    init(pagesRead: Int) {
        switch pagesRead {
            case ..<2_500: self = .beginner
            case ..<10_000: self = .intermediate
            case ..<20_000: self = .advanced
            default: self = .expert
        }
    }

    static func < (lhs: ReadingLevel, rhs: ReadingLevel) -> Bool {
        guard let lhsIndex = allCases.firstIndex(of: lhs),
              let rhsIndex = allCases.firstIndex(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }
}
