//
//  CurrentlyReadingView.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 30.05.2026..
//

import SwiftUI

struct CurrentlyReadingView: View {
    
    let book: Book
    let viewModel: MyBooksViewModel
    
    @State private var showingProgressSheet = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            BookImageView(url: book.image?.url)
                .frame(width: 100, height: 120)
            
            VStack(alignment: .leading) {
                Text(book.title ?? "Book has no title")
                    .bold()
                
                Text("by \(Text(book.contributions?.first?.author.name ?? "").bold())")
                    .padding(.bottom, 8)
                Button {
                    showingProgressSheet = true
                } label: {
                    Text("Update progress")
                }
                .buttonStyle(.bordered)
                
                HStack {
                    Text("Progress:")
                    
                    ProgressView(value: progress)
                        .progressViewStyle(.linear)
                    
                    Text("\(Int(progress*100))%")
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .sheet(isPresented: $showingProgressSheet) {
            UpdateBookProgressSheet(viewModel: viewModel, book: book, showingProgressSheet: $showingProgressSheet)
        }
    }
    
    private var progress: Double {
        guard let onPage = book.onPage,
                let total = book.pages,
                total > 0 else { return 0 }
        return Double(onPage) / Double(total)
    }
}

#Preview {
    CurrentlyReadingView(book: .example, viewModel: MyBooksViewModel())
}
