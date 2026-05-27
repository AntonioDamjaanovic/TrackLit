//
//  SearchScreen.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 30.04.2026..
//

import SwiftUI

struct SearchScreen: View {
    
    @State private var text: String = ""
    @State private var searchViewModel: SearchViewModel
    
    let myBooksViewModel: MyBooksViewModel
    
    init(service: HardcoverService = DefaultHardcoverService(), myBooksViewModel: MyBooksViewModel) {
        self.searchViewModel = SearchViewModel(service: service)
        self.myBooksViewModel = myBooksViewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                switch searchViewModel.state {
                    case .idle:
                        Text("Your search results will be shown here.")
                            .foregroundStyle(.secondary)
                        
                    case .loading:
                        ProgressView()
                        
                    case .loaded(let books):
                        SearchResultsListView(books: books)
                        
                    case .error(let error):
                        Text(error)
                            .foregroundStyle(.pink)
                }
            }
            .navigationDestination(for: Book.self) { book in
                BookDetailScreen(book: book)
            }
            .navigationTitle("Search Books")
            .searchable(text: $text)
            .task(id: text) {
                await searchViewModel.fetch(for: text)
            }
        }
    }
}

#Preview {
    SearchScreen(myBooksViewModel: MyBooksViewModel())
}
