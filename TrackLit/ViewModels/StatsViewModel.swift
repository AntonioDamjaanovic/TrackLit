//
//  StatsViewModel.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 06.06.2026..
//

import Foundation
import Observation
import FirebaseFirestore
import FirebaseAuth

@MainActor
@Observable
class StatsViewModel {
    
    var state: LoadingState<ReadingStats> = .idle
    
    func fetchUserStats() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.state = .loading
        
        do {
            let bookDocuments = try await Firestore.firestore()
                .collection("users")
                .document(uid)
                .collection("books")
                .getDocuments()
            
            let books = try bookDocuments.documents.compactMap { document in
                try document.data(as: Book.self)
            }
            
            self.state = .loaded(computeStats(from: books))
            print("Fetch succesfull")
        } catch {
            self.state = .error(error.localizedDescription)
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    private func computeStats(from books: [Book]) -> ReadingStats {
        let booksRead = books.filter { $0.shelf == .read }
        let currentlyReading = books.filter { $0.shelf == .currentlyReading }
        
        let pagesRead = (booksRead + currentlyReading)
            .reduce(0) { $0 + ($1.onPage ?? 0) }
        
        let ratings = booksRead.compactMap(\.userRating)
        let averageRating = ratings.isEmpty ? 0 : Double(ratings.reduce(0, +)) / Double(ratings.count)
        
        let genreCounts = Dictionary(
            grouping: booksRead.flatMap { $0.genres ?? [] },
            by: { $0 })
            .map { GenreCount(genre: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
        
        
        return ReadingStats(
            booksRead: booksRead.count,
            pagesRead: pagesRead,
            averageRating: averageRating,
            genreCounts: genreCounts
        )
    }
    
    static var example: StatsViewModel {
        let vm = StatsViewModel()
        let readingStats = ReadingStats(
            booksRead: 9,
            pagesRead: 5678,
            averageRating: 4.1,
            genreCounts: [
                GenreCount(genre: "Fantasy", count: 5),
                GenreCount(genre: "Science Fiction", count: 4),
                GenreCount(genre: "Mystery", count: 3),
                GenreCount(genre: "Literary Fiction", count: 2),
                GenreCount(genre: "Horror", count: 1)
            ]
        )
        vm.state = .loaded(readingStats)
        return vm
    }
}
