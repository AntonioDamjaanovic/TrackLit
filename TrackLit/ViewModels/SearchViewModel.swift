//
//  SearchViewModel.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 19.04.2026..
//

import Foundation
import Observation

@Observable
class SearchViewModel {
    
    var state: LoadingState<[Book]> = .idle
    private var currentSearchTerm: String = ""
    
    private let service: HardcoverService
    
    init(service: HardcoverService = DefaultHardcoverService()) {
        self.service = service
    }
    
    func fetch(for searchTerm: String) async {
        self.currentSearchTerm = searchTerm
        
        guard !searchTerm.isEmpty else {
            self.state = .idle
            return
        }
        
        self.state = .loading
        
        try? await Task.sleep(for: .milliseconds(500))
        guard !Task.isCancelled else { return }
        
        do {
            let books = try await service.searchBook(for: searchTerm)
            self.state = .loaded(books)
        } catch {
            setError(error, for: searchTerm)
        }
    }
    
    func setError(_ error: Error, for searchTerm: String) {
        guard searchTerm == currentSearchTerm else { return }
        
        if let error = error as? APIError {
            self.state = .error(error.localizedDescription)
        } else {
            self.state = .error("Unknown error")
        }
    }
    
    static var example: SearchViewModel {
        let vm = SearchViewModel(service: MockHardcoverService())
        vm.state = .loaded([Book.example])
        return vm
    }
}
