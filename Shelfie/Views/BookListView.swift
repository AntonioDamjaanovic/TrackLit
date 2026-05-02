//
//  BookListView.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 30.04.2026..
//

import SwiftUI

struct BookListView: View {
    
    let books: [Book]
    
    var body: some View {
        List(books) { book in
            BookRow(book: book)
        }
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
                
                Text("Rating: \(String(format: "%.2f", book.rating ?? 0.0))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    BookListView(books: [Book.example, Book.example, Book.example])
}
