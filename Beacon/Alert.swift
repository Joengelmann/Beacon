//
//  Alert.swift
//  Beacon
//
//  Created by Jordan Bouret on 2/17/24.
//

import Foundation

struct Alert: Identifiable, Codable {
    var id: String
    var userID: String
    var timestamp: Date
    var message: String
    
}
