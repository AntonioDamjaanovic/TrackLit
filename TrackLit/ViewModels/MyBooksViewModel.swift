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
    
    var state: LoadingState<[Book]> = .idle
    
    var wantToRead: [Book] = []
    var read: [Book] = []
    var currentlyReading: [Book] = []
    var didNotFinish: [Book] = []
    
    private let db = Firestore.firestore()
    
    func updateBookProgress(bookId: String, onPage: Int) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.state = .loading
        
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
    
    func fetchUserBooks() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.state = .loading
        
        do {
            let bookDocuments = try await db.collection("users")
                .document(uid)
                .collection("books")
                .getDocuments()
            
            let books = try bookDocuments.documents.compactMap { document in
                try document.data(as: Book.self)
            }
            
            filterBooksByShelf(books: books)
            self.state = .loaded(books)
            print("Fetch succesfull")
        } catch {
            self.state = .error(error.localizedDescription)
            print("Fetch failed: \(error.localizedDescription)")
        }
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
