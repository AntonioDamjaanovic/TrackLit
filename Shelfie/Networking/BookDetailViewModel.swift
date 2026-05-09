//
//  BookDetailViewModel.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 04.05.2026..
//

import Foundation
import Observation
import FirebaseFirestore

@MainActor
@Observable
class BookDetailViewModel {
    
    var state: LoadingState<ShelfState> = .idle
    private let db = Firestore.firestore()
    private var saveTask: Task<Void, Never>?
    
    func fetchShelfState(bookId: String) async -> ShelfState? {
        self.state = .loading
        
        do {
            let document = try await db.collection("users")
                .document("UJtzihxBn0wFLWAj4MI9")
                .collection("books")
                .document(bookId)
                .getDocument()
            
            let shelfString = document.get("shelf") as? String
            let shelfState = ShelfState(rawValue: shelfString ?? "notOnShelf") ?? .notOnShelf
            
            self.state = .loaded(shelfState)
            print("Fetch succesfull")
            return shelfState
        } catch {
            self.state = .error(error.localizedDescription)
            print("Fetch failed: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveToShelf(to shelf: ShelfState, book: Book) {
        saveTask?.cancel()
        
        saveTask = Task {
            do {
                self.state = .loading

                let bookRef = db.collection("users")
                    .document("UJtzihxBn0wFLWAj4MI9")
                    .collection("books")
                    .document(book.id)
                
                if shelf == .notOnShelf {
                    try await bookRef.delete()
                } else {
                    try await bookRef.setData(UserBook(book: book, shelf: shelf).asDictionary())
                }
                
                self.state = .loaded(shelf)
                print("Save succesfull")
            } catch is CancellationError {
                // intentionally cancelled, do nothing
            } catch {
                self.state = .error(error.localizedDescription)
                print("Save failed: \(error.localizedDescription)")
            }
        }
    }
}
