//
//  ShelvesScreen.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 13.05.2026..
//

import SwiftUI

struct MyBooksScreen: View {
    
    let viewModel: MyBooksViewModel
    
    var body: some View {
        NavigationStack {
            BookCarouselView(viewModel: viewModel)
            
            List {
                ForEach(ShelfState.allCases, id: \.self) { shelf in
                    if shelf != .notOnShelf && shelf != .currentlyReading {
                        Section {
                            NavigationLink(value: ShelfDestination.shelf(shelf)) {
                                ShelfView(
                                    books: viewModel.books(for: shelf),
                                    title: shelf.displayName
                                )
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: ShelfDestination.self) { destination in
                if case .shelf(let shelf) = destination {
                    ShelfBooksListView(viewModel: viewModel, shelf: shelf)
                }
            }
            .navigationDestination(for: Book.self) { book in
                BookDetailScreen(book: book, viewModel: viewModel)
            }
            .navigationTitle("My Books")
            .listSectionSpacing(14)
            .task {
                await viewModel.fetchUserBooks()
            }
        }
    }
}

private struct BookCarouselView: View {

    let viewModel: MyBooksViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Reading:")
                .font(.title3.bold())
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)

            if viewModel.currentlyReading.isEmpty {
                emptyState
            } else {
                carousel
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "book.closed")
                .font(.system(size: 32))
                .foregroundStyle(.secondary)

            Text("No books in progress")
                .font(.headline)

            Text("Add a book to your Currently Reading shelf to start tracking your progress.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(Color(.secondarySystemBackground),
                    in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }

    private var carousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(viewModel.currentlyReading) { book in
                    NavigationLink(value: book) {
                        CurrentlyReadingView(book: book, viewModel: viewModel)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 12)
                    }
                    .tint(.primary)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .contentMargins(.horizontal, 16)
        .frame(height: 160)
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
    MyBooksScreen(viewModel: .example)
}

#Preview("Shelf View") {
    ShelfView(books: [Book.example, Book.example2], title: "Want to read")
}
