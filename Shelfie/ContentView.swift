//
//  ContentView.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 19.04.2026..
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            Tab("Shelf", systemImage: "books.vertical.fill") {
                
            }
            
            Tab("Stats", systemImage: "apple.books.pages.fill") {
                
            }
            
            Tab("Settings", systemImage: "gear") {
                
            }
            
            Tab(role: .search) {
                SearchScreen()
            }
        }
    }
}

#Preview {
    ContentView()
}
