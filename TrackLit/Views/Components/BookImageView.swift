//
//  BookImageView.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 30.04.2026..
//

import SwiftUI

struct BookImageView: View {
    
    let url: URL?
    
    init(url: String?) {
        self.url = URL(string: url ?? "")
    }
    
    init(url: URL?) {
        self.url = url
    }
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
                case .empty:
                    Color(white: 0.8)
                        .overlay {
                            ProgressView()
                                .controlSize(.large)
                        }
                    
                case .success(let image):
                    image
                    .resizable()
                    .scaledToFit()
                    
                case .failure(_):
                    Text("Could not load the image")
                    
                @unknown default:
                    fatalError()
            }
        }
    }
}

#Preview {
    let url = "https://assets.hardcover.app/editions/30426415/8362709973192601-9780441013593-us.jpg"
    
    BookImageView(url: url)
        .frame(height: 200)
}
