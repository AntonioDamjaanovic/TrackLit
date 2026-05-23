//
//  MockHardcoverService.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 19.04.2026..
//

import Foundation

struct MockHardcoverService: HardcoverService {
    
    func fetchBook(by id: String) async throws -> Book {
        return Book.example
    }
    
    func searchBook(for searchTerm: String) async throws -> [Book] {
        return [Book.example, Book.example]
    }
}
