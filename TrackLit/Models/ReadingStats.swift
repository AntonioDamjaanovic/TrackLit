//
//  ReadingStats.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 06.06.2026..
//

import Foundation

struct ReadingStats: Equatable {
    let booksRead: Int
    let pagesRead: Int
    let averageRating: Double
    let genreCounts: [GenreCount]
}
