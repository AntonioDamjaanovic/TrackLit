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
                Section {
                    NavigationLink(value: ShelfDestination.shelf(.currentlyReading)) {
                        ShelfView(books: myBooksViewModel.currentlyReading, title: ShelfState.currentlyReading.displayName)
                    }
                }
                
                Section {
                    NavigationLink(value: ShelfDestination.shelf(.wantToRead)) {
                        ShelfView(books: myBooksViewModel.wantToRead, title: ShelfState.wantToRead.displayName)
                    }
                }
                
                Section {
                    NavigationLink(value: ShelfDestination.shelf(.read)) {
                        ShelfView(books: myBooksViewModel.read, title: ShelfState.read.displayName)
                    }
                }
                
                Section {
                    NavigationLink(value: ShelfDestination.shelf(.didNotFinish)) {
                        ShelfView(books: myBooksViewModel.didNotFinish, title: ShelfState.didNotFinish.displayName)
                    }
                }
            }
            .navigationDestination(for: ShelfDestination.self) { destination in
                if case .shelf(let shelf) = destination {
                    BookListView(
                        myBooksViewModel: myBooksViewModel,
                        books: myBooksViewModel.books(for: shelf),
                        title: shelf.displayName
                    )
                }
            }
            .navigationDestination(for: Book.self) { book in
                BookDetailScreen(book: book)
            }
            .navigationTitle("My Books")
            .listSectionSpacing(14)
        }
        .onAppear {
            Task {
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
            BookImageView(url: books.first?.image?.url)
                .frame(width: 80, height: 100)
            
            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                
                Text("\(books.count) books")
                    .foregroundStyle(.secondary)
            }
        }
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
