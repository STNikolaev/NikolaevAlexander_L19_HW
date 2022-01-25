//
//  BirthdayEntity.swift
//  BirthdayReminder
//
//  Created by Max Bystryk on 11.11.2021.
//

import UIKit

struct BirthdayEntity: Equatable, Codable {
    let name: String
    let date: Date
    let icon: Data?

    
    var formattedDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    
}

