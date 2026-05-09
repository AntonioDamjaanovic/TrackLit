//
//  Config.swift
//  Shelfie
//
//  Created by Antonio Damjanović on 19.04.2026..
//

import Foundation

enum Config {
    static var hardcoverAPIKey: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let key = dict["HardcoverAPIKey"] as? String else {
            fatalError("Config.plist missing or HardcoverAPIKey not found")
        }
        
        return key
    }
}
