//
//  MockHardcoverService.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 19.04.2026..
//

import Foundation

struct MockHardcoverService: HardcoverService {
    func searchBook(for searchTerm: String) async throws -> [Book] {
        return [Book.example, Book.example]
    }
}
