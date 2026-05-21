//
//  ShelvesScreen.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 13.05.2026..
//

import SwiftUI

struct MyBooksScreen: View {
    
    let viewModel: MyBooksViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        BookListView(books: viewModel.currentlyReading, title: ShelfState.currentlyReading.displayName)
                    } label: {
                        ShelfView(books: viewModel.currentlyReading, title: ShelfState.currentlyReading.displayName)
                    }
                }
                
                Section {
                    NavigationLink {
                        BookListView(books: viewModel.wantToRead, title: ShelfState.wantToRead.displayName)
                    } label: {
                        ShelfView(books: viewModel.wantToRead, title: ShelfState.wantToRead.displayName)
                    }
                }
                
                Section {
                    NavigationLink {
                        BookListView(books: viewModel.read, title: ShelfState.read.displayName)
                    } label: {
                        ShelfView(books: viewModel.read, title: ShelfState.read.displayName)
                    }
                }
                
                Section {
                    NavigationLink {
                        BookListView(books: viewModel.didNotFinish, title: ShelfState.didNotFinish.displayName)
                    } label: {
                        ShelfView(books: viewModel.didNotFinish, title: ShelfState.didNotFinish.displayName)
                    }
                }
            }
            .navigationTitle("My Books")
            .listSectionSpacing(14)
        }
        .onAppear {
            Task {
                await viewModel.fetchUserBooks()
            }
        }
    }
}

private struct ShelfView: View {
    
    let books: [any BookRepresentable]
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

#Preview("My Books Screen") {
    MyBooksScreen(viewModel: MyBooksViewModel())
}

#Preview("Shelf View") {
    ShelfView(books: [Book.example, Book.example2], title: "Want to read")
}
