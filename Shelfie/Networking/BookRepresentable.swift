//
//  BookRepresentable.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 21.05.2026..
//

import Foundation

protocol BookRepresentable: Identifiable, Hashable {
    var id: String { get }
    var title: String? { get }
    var image: RemoteImage? { get }
    var contributions: [Contribution]? { get }
    var rating: Double? { get }
}
