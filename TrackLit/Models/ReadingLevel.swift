//
//  ReadingLevel.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 06.06.2026..
//

import Foundation

enum ReadingLevel: String {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"
    
    init(pagesRead: Int) {
        switch pagesRead {
            case ..<1_000: self = .beginner
            case ..<5_000: self = .intermediate
            case ..<10_000: self = .advanced
            default: self = .expert
        }
    }
}
