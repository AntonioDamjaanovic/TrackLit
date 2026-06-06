//
//  ContentView.swift
//  TrackLit
//
//  Created by Antonio Damjanović on 19.04.2026..
//

import SwiftUI

struct ContentView: View {
    
    @State private var mainViewModel = MainViewModel()
    @State private var myBooksViewModel = MyBooksViewModel()
    
    var body: some View {
        if mainViewModel.isSignedIn {
            appView
        } else {
            LoginScreen()
        }
    }
    
    private var appView: some View {
        TabView {
            Tab("My Books", systemImage: "books.vertical.fill") {
                MyBooksScreen(viewModel: myBooksViewModel)
            }
            
            Tab("Stats", systemImage: "apple.books.pages.fill") {
                StatsScreen()
            }
            
            Tab("Settings", systemImage: "gear") {
                SettingsScreen()
            }
            
            Tab(role: .search) {
                SearchScreen(myBooksViewModel: myBooksViewModel)
            }
        }
        .setAppearanceTheme()
    }
}

#Preview {
    ContentView()
}
