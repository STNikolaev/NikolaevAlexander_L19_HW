//
//  UserDefaultManager.swift
//  BirthdayReminder
//
//  Created by Ales Krot on 21.11.21.
//

import Foundation

class UserDefaultManager {
    static let shared = UserDefaultManager()
    
    enum Key: String {
        case allEntities
    }
    
    private init() {}
    
    func save(array: [BirthdayEntity], forKey key: Key) {
        let data = try! JSONEncoder().encode(array)
        save(value: data, forKey: key)
    }
    
    func array(forKey key: Key) -> [BirthdayEntity]? {
        guard let data = value(forKey: key) as? Data else { return nil }
        return try? JSONDecoder().decode([BirthdayEntity].self, from: data)
    }
    
    func save(value: Any?, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func value(forKey key: Key) -> Any? {
        UserDefaults.standard.value(forKey: key.rawValue)
    }
    
    func remove(forKey key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
