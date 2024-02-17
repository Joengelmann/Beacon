//
//  ContentView.swift
//  Beacon
//
//  Created by Jonah Engelmann on 2/17/24.
//

import SwiftUI
struct ContentView: View {
    var body: some View {
        TabView {
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            MainView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            NetworkView()
                .tabItem {
                    Image(systemName: "network")
                    Text("Network")
                }
        }
    }
}
struct SettingsView: View {
    var body: some View {
        Text("Settings")
    }
}
struct MainView: View {
    var body: some View {
        Button(action: {
            print("Button pressed!")
        }) {
            Text("Press Me")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(100)
                .frame(width: 200, height: 200)
        }
    }
}
struct NetworkView: View {
    var body: some View {
        Text("Network")
    }
}

