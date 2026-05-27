//
//  SettingsScreen.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 26.05.2026..
//

import SwiftUI

struct SettingsScreen: View {
    
    @State private var viewModel = SettingsViewModel()
    
    @AppStorage(UserDefaultsKeys.appearanceTheme)
    private var appearanceTheme: AppearanceTheme = .system
    
    @AppStorage(UserDefaultsKeys.notificationsEnabled)
    private var notificationsEnabled: Bool = true
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    accountContent
                }
                
                Section("Appearance") {
                    Picker("Appearance", selection: $appearanceTheme) {
                        ForEach(AppearanceTheme.allCases) { theme in
                            Text(theme.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.automatic)
                }
                
                Section("Preferences") {
                    Toggle("Enable notifications", isOn: $notificationsEnabled)
                }
                
                Section {
                    Button(role: .destructive) {
                        resetDefaults()
                    } label: {
                        Text("Reset to Defaults")
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        viewModel.logout()
                    } label: {
                        Text("Sign out")
                    }
                }
            }
            .navigationTitle("Settings")
            .task {
                await viewModel.fetchUserData()
            }
        }
    }
    
    @ViewBuilder
    private var accountContent: some View {
        switch viewModel.state {
            case .idle, .loading:
                HStack {
                    Text("Loading...")
                        .foregroundStyle(.secondary)
                    Spacer()
                    ProgressView()
                }

            case .loaded(let user):
                LabeledContent("Name", value: user.name)
                LabeledContent("Email", value: user.email)
                LabeledContent("Joined", value: Date(timeIntervalSince1970: user.joined)
                    .formatted(date: .abbreviated, time: .omitted))
                
            case .error(let error):
                Text(error)
                    .foregroundStyle(.pink)
                    .font(.footnote)
        }
    }
    
    func resetDefaults() {
        appearanceTheme = .system
        notificationsEnabled = true
    }
}

// MARK: - data model for appearance
enum AppearanceTheme: String, Identifiable, CaseIterable {
    case system
    case dark
    case light
    var id: Self { return self }
}

// MARK: - helper to save user defaults keys and keep them unique
enum UserDefaultsKeys {
    static let appearanceTheme = "appearanceTheme"
    static let notificationsEnabled = "notificationsEnabled"
}

#Preview {
    SettingsScreen()
}
