//
//  BookDetailViewModel.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 04.05.2026..
//

import Foundation
import Observation
import FirebaseFirestore
import FirebaseAuth

@MainActor
@Observable
class BookDetailViewModel {
    
    var state: LoadingState<ShelfState> = .idle
    
    private let db = Firestore.firestore()
    
    func fetchUserBookState(bookId: String) async -> (shelf: ShelfState, rating: Int)? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        
        self.state = .loading
        
        do {
            let document = try await db.collection("users")
                .document(uid)
                .collection("books")
                .document(bookId)
                .getDocument()
            
            let rating = document.get("userRating") as? Int ?? 0
            
            let shelfString = document.get("shelf") as? String
            let shelfState = ShelfState(rawValue: shelfString ?? "notOnShelf") ?? .notOnShelf
            
            self.state = .loaded(shelfState)
            print("Fetch succesfull")
            return (shelf: shelfState, rating: rating)
        } catch {
            self.state = .error(error.localizedDescription)
            print("Fetch failed: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveToShelf(to shelf: ShelfState, book: Book, rating: Int = 0, onPage: Int = 0) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            self.state = .loading

            let bookRef = db.collection("users")
                .document(uid)
                .collection("books")
                .document(book.id)
            
            if shelf == .notOnShelf {
                try await bookRef.delete()
            } else {
                let updatedBook = book.with(userRating: rating, shelf: shelf, onPage: onPage)
                try await bookRef.setData(updatedBook.asDictionary())
            }
            
            self.state = .loaded(shelf)
            print("Save succesfull")
        } catch {
            self.state = .error(error.localizedDescription)
            print("Save failed: \(error.localizedDescription)")
        }
    }
    
    func updateBookRating(bookId: String, rating: Int) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            try await db.collection("users")
                .document(uid)
                .collection("books")
                .document(bookId)
                .updateData(["userRating": rating])
            
        } catch {
            self.state = .error(error.localizedDescription)
            print("Update failed: \(error.localizedDescription)")
        }
    }
}
