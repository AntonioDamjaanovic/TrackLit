//
//  MyBooksViewModel.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 20.05.2026..
//

import Foundation
import Observation
import FirebaseFirestore
import FirebaseAuth

@Observable
class MyBooksViewModel {
    
    var state: LoadingState<ShelfState> = .idle
    
    var wantToRead: [Book] = []
    var read: [Book] = []
    var currentlyReading: [Book] = []
    var didNotFinish: [Book] = []
    
    private let db = Firestore.firestore()
    
    func fetchUserBooks() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            let bookDocuments = try await db.collection("users")
                .document(uid)
                .collection("books")
                .getDocuments()
            
            let books = try bookDocuments.documents.compactMap { document in
                try document.data(as: Book.self)
            }
            
            filterBooksByShelf(books: books)
            print("Fetch succesfull")
        } catch {
            self.state = .error(error.localizedDescription)
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func updateBookProgress(bookId: String, onPage: Int) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            try await db.collection("users")
               .document(uid)
               .collection("books")
               .document(bookId)
               .updateData(["onPage": onPage])
            
            await fetchUserBooks()
        } catch {
            self.state = .error(error.localizedDescription)
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func fetchUserBookState(bookId: String) async -> (shelf: ShelfState, rating: Int)? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        
        do {
            let document = try await db.collection("users")
                .document(uid)
                .collection("books")
                .document(bookId)
                .getDocument()
            
            let rating = document.get("userRating") as? Int ?? 0
            
            let shelfString = document.get("shelf") as? String
            let shelfState = ShelfState(rawValue: shelfString ?? "notOnShelf") ?? .notOnShelf
            
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
        
        self.state = .loading
        
        do {
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
            
            await fetchUserBooks()
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
            
            await fetchUserBooks()
            print("Save succesfull")
        } catch {
            self.state = .error(error.localizedDescription)
            print("Update failed: \(error.localizedDescription)")
        }
    }
    
    func finishBook(book: Book, rating: Int) async {
        guard let total = book.pages else { return }
        
        await updateBookProgress(bookId: book.id, onPage: total)
        await saveToShelf(to: .read, book: book, onPage: total)
        await updateBookRating(bookId: book.id, rating: rating)
    }
    
    private func filterBooksByShelf(books: [Book]) {
        self.wantToRead = books.filter { $0.shelf == .wantToRead }
        self.read = books.filter { $0.shelf == .read }
        self.currentlyReading = books.filter { $0.shelf == .currentlyReading }
        self.didNotFinish = books.filter { $0.shelf == .didNotFinish }
    }
    
    func books(for shelf: ShelfState) -> [Book] {
        switch shelf {
            case .wantToRead: return wantToRead
            case .read: return read
            case .currentlyReading: return currentlyReading
            case .didNotFinish: return didNotFinish
            case .notOnShelf: return []
        }
    }
    
    static var example: MyBooksViewModel {
        let vm = MyBooksViewModel()
        vm.currentlyReading = [.example, .example2]
        vm.read = [.example, .example2]
        vm.wantToRead = [.example, .example2]
        vm.didNotFinish = [.example, .example2]
        return vm
    }
}
