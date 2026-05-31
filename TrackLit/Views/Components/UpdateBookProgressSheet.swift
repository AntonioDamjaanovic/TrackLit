//
//  UpdateBookProgressSheet.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 30.05.2026..
//

import SwiftUI

struct UpdateBookProgressSheet: View {
    
    let viewModel: MyBooksViewModel
    let book: Book
    @Binding var showingProgressSheet: Bool
    
    @State private var onPage: Int?
    @State private var showingRatingSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    HStack {
                        Text("I'm on page")
                        Spacer()
                        
                        TextField("", value: $onPage, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.secondary.opacity(0.4), lineWidth: 1)
                            )
                            .frame(width: 65)
                    }
                    
                    Button {
                        showingRatingSheet = true
                    } label: {
                        Text("I've finished this book!")
                    }
                    .buttonStyle(.bordered)
                    .tint(.primary)
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(.systemBackground), for: .navigationBar)
            .task(id: book.id) {
                onPage = book.onPage
            }
            .sheet(isPresented: $showingRatingSheet) {
                FinishBookRatingSheet(book: book) { rating in
                    Task {
                        await viewModel.finishBook(book: book, rating: rating)
                        showingRatingSheet = false
                    }
                }
                .presentationDetents([.medium])
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingProgressSheet = false
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if let total = book.pages {
                            guard let onPage, onPage > 0, onPage < total else { return }
                            Task {
                                await viewModel.updateBookProgress(bookId: book.id, onPage: onPage)
                            }
                            showingProgressSheet = false
                        } else {
                            return
                        }
                        
                    } label: {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
}

#Preview {
    UpdateBookProgressSheet(
        viewModel: MyBooksViewModel(),
        book: .example,
        showingProgressSheet: Binding(get: { true }, set: { _ in })
    )
}
