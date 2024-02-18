//
//  BeaconApp.swift
//  Beacon
//
//  Created by Jonah Engelmann on 2/17/24.
//

import SwiftUI
import Firebase

@main
struct YourAppNameApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
