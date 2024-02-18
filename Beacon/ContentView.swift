//
//  ContentView.swift
//  Beacon
//
//  Created by Jonah Engelmann on 2/17/24.
//



import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


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
    @StateObject var alertsManager = AlertsManager()
    
    var body: some View {
        Text(alertsManager.getAlertString())
        
    }
}
struct MainView: View {
    var body: some View {
        Button(action: {
            print("Button pressed!")
            sendAlert()
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

func sendAlert(/*message: String*/){ // send a broadcast to the firebase server
    let db = Firestore.firestore()
    do{
        let newAlert = Alert(id:"420",userID:"69",timestamp: Date(),message:"HELP!")
        try db.collection("Alerts").document().setData(from: newAlert)
    }
    catch{
        print("Error adding alert to Firestore: \(error)")
    }
    
}
