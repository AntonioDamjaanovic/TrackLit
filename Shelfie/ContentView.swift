//
//  ContentView.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 19.04.2026..
//

import SwiftUI

struct ContentView: View {
    
    @State private var myBooksViewModel = MyBooksViewModel()
    
    var body: some View {
        TabView {
            Tab("My Books", systemImage: "books.vertical.fill") {
                MyBooksScreen(myBooksViewModel: myBooksViewModel)
            }
            
            Tab("Stats", systemImage: "apple.books.pages.fill") {
                
            }
            
            Tab("Settings", systemImage: "gear") {
                
            }
            
            Tab(role: .search) {
                SearchScreen(myBooksViewModel: myBooksViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
