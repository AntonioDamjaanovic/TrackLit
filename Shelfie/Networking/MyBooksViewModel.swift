//
//  MyBooksViewModel.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 20.05.2026..
//

import Foundation
import Observation
import FirebaseFirestore

@Observable
class MyBooksViewModel {
    
    var state: LoadingState<[UserBook]> = .idle
    var selectedBook: Book? = nil
    
    var wantToRead: [UserBook] = []
    var read: [UserBook] = []
    var currentlyReading: [UserBook] = []
    var didNotFinish: [UserBook] = []
    
    private let db = Firestore.firestore()
    private let service: HardcoverService
    
    init(service: HardcoverService = DefaultHardcoverService()) {
        self.service = service
    }
    
    func fetchSelectedBook(by id: String) async throws {
        self.state = .loading
        
        do {
            let book = try await service.fetchBook(by: id)
            self.selectedBook = book
            print("Fetch succesfull")
        } catch {
            self.state = .error(error.localizedDescription)
            print("Fetch failed")
        }
    }
    
    func fetchUserBooks() async {
        self.state = .loading
        
        do {
            let bookDocuments = try await db.collection("users")
                .document("UJtzihxBn0wFLWAj4MI9")
                .collection("books")
                .getDocuments()
            
            let books = try bookDocuments.documents.compactMap { document in
                try document.data(as: UserBook.self)
            }
            
            filterBooksByShelf(books: books)
            self.state = .loaded(books)
            print("Fetch succesfull")
        } catch {
            self.state = .error(error.localizedDescription)
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    private func filterBooksByShelf(books: [UserBook]) {
        self.wantToRead = books.filter { $0.shelf == .wantToRead }
        self.read = books.filter { $0.shelf == .read }
        self.currentlyReading = books.filter { $0.shelf == .currentlyReading }
        self.didNotFinish = books.filter { $0.shelf == .didNotFinish }
    }
}
