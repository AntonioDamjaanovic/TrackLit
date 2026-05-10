//
//  BookDetailScreen.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 02.05.2026..
//

import SwiftUI

struct BookDetailScreen: View {
    
    let book: Book
    @State private var viewModel = BookDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                BookImageView(url: book.image?.url)
                    .frame(height: 250)
                    .containerRelativeFrame(.horizontal)
                
                BookInfoView(book: book)
                
                Divider()
                
                BookRatingView(book: book, viewModel: viewModel)
                
                Divider()
                
                BookDescriptionView(description: book.description)
                
                Divider()
                
                BookGenresView(genres: book.genres)
                
                Divider()
                
                BookSeriesView(featuredBooks: [.example, .example2])
                
                Divider()
                
                BooksByAuthorView(books: [.example, .example2])
            }
        }
    }
}

private struct BookInfoView: View {
    
    let book: Book
    
    var body: some View {
        VStack(spacing: 8) {
            Text(book.title ?? "")
                .font(.title3)
                .bold()
            
            if let author = book.contributions?.first?.author.name {
                Text("by \(author)")
            }
            
            HStack(spacing: 16) {
                if let rating = book.rating {
                    StarRatingView(rating: rating)
                    
                    Text("\(String(format: "%.2f", rating))")
                }
                
                if let ratingsCount = book.ratingsCount {
                    Text("\(ratingsCount) ratings")
                }
                
                if let reviewsCount = book.reviewsCount {
                    Text("\(reviewsCount) reviews")
                }
            }
            .font(.caption)
        }
    }
}

private struct BookRatingView: View {
    
    let book: Book
    let viewModel: BookDetailViewModel
    
    @State private var selectedShelf: ShelfState = .notOnShelf
    @State private var selectedRating: Int = 0
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("On which shelf")
                
                Spacer()
                
                Picker("On which shelf", selection: Binding(
                    get: { selectedShelf },
                    set: { newShelf in
                        selectedShelf = newShelf
                        if newShelf == .notOnShelf { selectedRating = 0 }
                        viewModel.saveToShelf(to: newShelf, book: book, rating: selectedRating)
                    }
                )) {
                    ForEach(ShelfState.allCases) { shelf in
                        Text(shelf.displayName)
                    }
                }
                .pickerStyle(.menu)
                .disabled(viewModel.state == .loading)
                .alert("Error", isPresented: $showError) {
                    Button("OK") { showError = false }
                } message: {
                    Text(errorMessage)
                }
            }
            
            HStack {
                Text("Your rating")
                
                Spacer()
                
                InteractiveStarRatingView(rating: Binding(
                    get: { selectedRating },
                    set: { newRating in
                        selectedRating = newRating
                        viewModel.updateBookRating(bookId: book.id, rating: newRating)
                    }
                ))
                .disabled(viewModel.state == .loading || viewModel.state.data == .notOnShelf)
            }
        }
        .padding(.horizontal)
        .onAppear {
            Task {
                if let userBookState = await viewModel.fetchUserBookState(bookId: book.id) {
                    selectedShelf = userBookState.shelf
                    selectedRating = userBookState.rating
                }
            }
        }
        .onChange(of: viewModel.state) {
            if case .error(let message) = viewModel.state {
                errorMessage = message
                showError = true
            }
        }
    }
}

private struct BookDescriptionView: View {
    
    let description: String?
    
    var body: some View {
        Text("BOOK DESCRIPTION")
            .font(.subheadline)
            .bold()
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .padding(.top),
                alignment: .bottom
            )
        
        if let description = description {
            Text(description)
                .padding(.horizontal)
        } else {
            Text("No description available")
        }
    }
}

private struct BookGenresView: View {
    
    let genres: [String]?
    
    var body: some View {
        Text("GENRES")
            .font(.subheadline)
            .bold()
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .padding(.top),
                alignment: .bottom
            )
        
        if let genres = genres {
            let columns = [GridItem(.adaptive(minimum: 80))]
            
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(genres, id: \.self) { genre in
                    Text(genre)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.green.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
        } else {
            Text("Genres unknown")
        }
    }
}

private struct BookSeriesView: View {
    
    let featuredBooks: [Book]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(featuredBooks) { book in
                    VStack {
                        BookImageView(url: book.image?.url)
                            .frame(height: 60)
                        
                        Text(book.title ?? "Unknown title")
                            .bold()
                            .font(.footnote)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

private struct BooksByAuthorView: View {
    
    let books: [Book]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 18) {
                ForEach(books) { book in
                    VStack {
                        BookImageView(url: book.image?.url)
                            .frame(height: 60)
                        
                        Text(book.title ?? "Unknown title")
                            .bold()
                            .font(.footnote)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}


#Preview {
    NavigationStack {
        BookDetailScreen(book: .example)
    }
}
