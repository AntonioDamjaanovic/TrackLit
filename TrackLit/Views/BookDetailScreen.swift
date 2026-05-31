//
//  BookDetailScreen.swift
//  TrackLit
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
                
                BookTagSection(title: "GENRES", items: book.genres, tagColor: .green)
                Divider()
                
                BookTagSection(title: "MOODS", items: book.moods, tagColor: .yellow)
                Divider()
                
                BookTagSection(title: "CONTENT WARNINGS", items: book.contentWarnings, tagColor: .red)
            }
        }
        .navigationTitle(book.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
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
                        Task {
                            await viewModel.saveToShelf(to: newShelf, book: book, rating: selectedRating)
                        }
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
                        Task {
                            await viewModel.updateBookRating(bookId: book.id, rating: newRating)
                        }
                    }
                ))
                .disabled(viewModel.state == .loading || viewModel.state.data == .notOnShelf)
            }
        }
        .padding(.horizontal)
        .task {
            if let userBookState = await viewModel.fetchUserBookState(bookId: book.id) {
                selectedShelf = userBookState.shelf
                selectedRating = userBookState.rating
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

private struct BookTagSection: View {
    
    let title: String
    let items: [String]?
    let tagColor: Color
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .bold()
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .padding(.top),
                alignment: .bottom
            )
        
        if let elements = items {
            let columns = [GridItem(.adaptive(minimum: 80))]
            
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(elements, id: \.self) { item in
                    Text(item)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(tagColor.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
        } else {
            Text("No data")
        }
    }
}

#Preview {
    NavigationStack {
        BookDetailScreen(book: .example)
    }
}
