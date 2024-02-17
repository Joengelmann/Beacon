//
//  ContentView.swift
//  Beacon
//
//  Created by Jonah Engelmann on 2/17/24.
//

import SwiftUI
struct ContentView: View {

    @StateObject var alertsManager = AlertsManager()
    var alertsArray = ["Hi"]

    



    var body: some View {
        ForEach(alertsManager.alerts, id: \.id) {
            print("Dick")
        }
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
        }, label: {
            Text("Alert")
                .padding()
                .padding(.horizontal, 95)
                .padding(.vertical,105)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(1000)
                .font(.system(size: 60))
        })
    }
}

struct NetworkView: View {
    var body: some View {
        Text("Network")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
