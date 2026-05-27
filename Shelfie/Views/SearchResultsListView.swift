//
//  SearchResultsListView.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 27.05.2026..
//

import SwiftUI

struct SearchResultsListView: View {
    
    let books: [Book]
    
    var body: some View {
        List(books) { book in
            NavigationLink(value: book) {
                BookRow(book: book)
            }
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
    }
}

#Preview {
    SearchResultsListView(books: [.example, .example2])
}
