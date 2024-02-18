//
//  User.swift
//  Beacon
//
//  Created by Jordan Bouret on 2/17/24.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var name: String
    var friends: [String]
}
