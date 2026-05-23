//
//  BookListView.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 30.04.2026..
//

import SwiftUI

struct BookListView: View {
    
    let books: [Book]
    let title: String
    
    var body: some View {
        List {
            ForEach(books, id: \.id) { book in
                NavigationLink(value: book) {
                    BookRow(book: book)
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
    }
}

private struct BookRow: View {
    
    let book: Book
    
    var body: some View {
        HStack(alignment: .top) {
            BookImageView(url: book.image?.url)
                .frame(width: 80, height: 100)
            
            VStack(alignment: .leading) {
                Text(book.title ?? "Book has no title")
                    .bold()
                
                Text("by \(Text(book.contributions?.first?.author.name ?? "").bold())")
                    .padding(.bottom)
                
                if let userRating = book.userRating {
                    Text("Rating: \(userRating)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else if let rating = book.rating {
                    Text("Rating: \(String(format: "%.2f", rating))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        BookListView(
            books: [Book.example, Book.example, Book.example],
            title: "Books"
        )
    }
}
