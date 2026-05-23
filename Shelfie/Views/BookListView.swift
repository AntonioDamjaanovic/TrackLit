//
//  BookListView.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 30.04.2026..
//

import SwiftUI

struct BookListView: View {
    
    let books: [any BookRepresentable]
    let title: String
    
    var selectedBook: Binding<Book?>? = nil
    var onUserBookTapped: ((UserBook) async -> Book?)? = nil
    
    var body: some View {
        List {
            ForEach(books, id: \.id) { book in
                if let userBook = book as? UserBook {
                    Button {
                        Task {
                            let book = await onUserBookTapped?(userBook)
                            selectedBook?.wrappedValue = book
                        }
                    } label: {
                        BookRow(book: book)
                    }
                    .buttonStyle(.plain)
                    
                } else if let book = book as? Book {
                    NavigationLink(value: book) {
                        BookRow(book: book)
                    }
                }
            }
        }
        .navigationDestination(for: Book.self) { book in
            BookDetailScreen(book: book)
        }
        .navigationDestination(item: selectedBook ?? .constant(nil)) { book in
            BookDetailScreen(book: book)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
    }
}

private struct BookRow: View {
    
    let book: any BookRepresentable
    
    var body: some View {
        HStack(alignment: .top) {
            BookImageView(url: book.image?.url)
                .frame(width: 80, height: 100)
            
            VStack(alignment: .leading) {
                Text(book.title ?? "Book has no title")
                    .bold()
                
                Text("by \(Text(book.contributions?.first?.author.name ?? "").bold())")
                    .padding(.bottom)
                
                Text("Rating: \(String(format: "%.2f", book.rating ?? 0.0))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedBook: Book? = nil
    
    NavigationStack {
        BookListView(
            books: [Book.example, Book.example, Book.example],
            title: "Books",
            selectedBook: $selectedBook,
            onUserBookTapped: nil)
    }
}
