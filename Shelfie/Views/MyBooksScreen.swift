//
//  ShelvesScreen.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 13.05.2026..
//

import SwiftUI

struct MyBooksScreen: View {
    
    let myBooksViewModel: MyBooksViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(ShelfState.allCases, id: \.self) { shelf in
                    if shelf != .notOnShelf {
                        Section {
                            NavigationLink(value: ShelfDestination.shelf(shelf)) {
                                ShelfView(
                                    books: myBooksViewModel.books(for: shelf),
                                    title: shelf.displayName
                                )
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: ShelfDestination.self) { destination in
                if case .shelf(let shelf) = destination {
                    ShelfBooksListView(viewModel: myBooksViewModel, shelf: shelf)
                }
            }
            .navigationDestination(for: Book.self) { book in
                BookDetailScreen(book: book)
            }
            .navigationTitle("My Books")
            .listSectionSpacing(14)
            .task {
                await myBooksViewModel.fetchUserBooks()
            }
        }
    }
}

private struct ShelfView: View {
    
    let books: [Book]
    let title: String
    
    var body: some View {
        HStack(alignment: .top) {
            Group {
                if books.isEmpty {
                    emptyCover
                } else {
                    BookImageView(url: books.first?.image?.url)
                }
            }
            .frame(width: 80, height: 100)
            
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                
                Text("\(books.count) books")
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var emptyCover: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(.secondary.opacity(0.15))
            .overlay(
                Image(systemName: "books.vertical")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            )
    }
}

private enum ShelfDestination: Hashable {
    case shelf(ShelfState)
}

#Preview("My Books Screen") {
    MyBooksScreen(myBooksViewModel: MyBooksViewModel())
}

#Preview("Shelf View") {
    ShelfView(books: [Book.example, Book.example2], title: "Want to read")
}
