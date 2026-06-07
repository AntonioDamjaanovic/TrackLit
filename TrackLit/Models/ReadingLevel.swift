//
//  ReadingLevel.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 06.06.2026..
//

import Foundation

enum ReadingLevel: String, Codable {
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
}
