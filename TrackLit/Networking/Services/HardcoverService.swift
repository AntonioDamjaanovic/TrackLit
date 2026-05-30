//
//  HardcoverService.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 19.04.2026..
//

import Foundation

protocol HardcoverService: Sendable {
    func searchBook(for searchTerm: String) async throws -> [Book]
    func fetchBook(by id: String) async throws -> Book
}
