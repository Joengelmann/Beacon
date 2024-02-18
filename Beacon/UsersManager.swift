//
//  UsersManager.swift
//  Beacon
//
//  Created by Jordan Bouret on 2/17/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class UsersManager: ObservableObject {
    @Published private(set) var users: [User] = []
    let db = Firestore.firestore()
    
    init() {
        downloadUsers()
    }
    func downloadUsers() {
        db.collection("Users").addSnapshotListener {querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            self.users = documents.compactMap {document -> User? in
                do {
                    return try document.data(as: User.self)
                } catch {
                    print("Error decoding document into User \(error)")
                    return nil
                }
            }
        }
    }
    func uploadUser(_name: String, _id: String, _friendsList: [String] ) {
        do{
            let newUser = User(id: _id, name: _name, friends: _friendsList)
            try db.collection("Users").document(newUser.id).setData(from: newUser)
        }
        catch{
            print("Error adding user to Firestore: \(error)")
        }
    }
    
    func getUsers() -> [User]{
            return users
    }
}
