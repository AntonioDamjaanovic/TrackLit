//
//  FeaturedSeries.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 24.04.2026..
//

import Foundation

struct FeaturedSeries: Codable, Identifiable, Equatable, Hashable {
    let id: Int?
    let position: Int?
    let unreleased: Bool?
    let series: BookSeries?
}
