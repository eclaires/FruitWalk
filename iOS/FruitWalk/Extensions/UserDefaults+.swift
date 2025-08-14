//
//  UserDefaults+.swift
//  FruitWalk
//
//  Created by Claire S on 3/12/25.
//

import Foundation

extension UserDefaults {

    public enum Keys {
        static let suppressFavoritesAlert = "suppress_favorites_alert"
        static let suppressHiddenAlert = "suppress_hidden_alert"
        static let lastMapSearch = "last_map_search"
        static let favorites = "favorites"
        static let hidden = "hidden"
        static let welcomeAccepted = "welcome_accepted"
    }
    
    var welcomeAccepted: Bool {
        set {
            set(newValue, forKey: Keys.welcomeAccepted)
        }
        get {
            return bool(forKey: Keys.welcomeAccepted)
        }
    }

    var suppressFavoritesAlert: Bool {
        set {
            set(newValue, forKey: Keys.suppressFavoritesAlert)
        }
        get {
            return bool(forKey: Keys.suppressFavoritesAlert)
        }
    }
    
    var suppressHiddenAlert: Bool {
        set {
            set(newValue, forKey: Keys.suppressHiddenAlert)
        }
        get {
            return bool(forKey: Keys.suppressHiddenAlert)
        }
    }
    
    var lastMapSearch: String? {
        set {
            set(newValue, forKey: Keys.lastMapSearch)
        }
        get {
            return string(forKey: Keys.lastMapSearch)
        }
    }
    
    var favorites: [Int: FruitLocation] {
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                set(encoded, forKey: Keys.favorites)
            }
        }
        get {
            if let data = object(forKey:Keys.favorites) as? Data,
               let favorites = try? JSONDecoder().decode([Int: FruitLocation].self, from: data) {
                return favorites
            } else {
                return [Int: FruitLocation]()
            }
        }
    }
}
