
import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit

struct ContentView: View {
    @State var TestText: String = "test11"
    var body: some View {
        
        TabView {
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
            
            AlertsView()
                .tabItem {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("Alerts")
                    
                }
        }
    }
}

struct MainView: View {
    @State private var buttonColor: Color = Color.black
    @State private var buttonText: String = "Alert"
    @State private var isPressed: Bool = false
    @State private var textSize: CGFloat = 40.0
    @State var userfound: Bool = false
    
    @StateObject var usersManager = UsersManager()
    let vendorIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
    
    init(){
        print("hey")
        if(!usersManager.login()){
            loginPop()
        }
    }
    
    var body: some View {
        

        /*
        safeAreaInset(edge: .top) {
            Button(action: {}) {}.onAppear() {
                print("hey")
                //if(!usersManager.login()){
                    //alertView()
                  //}
            }
        }*/
        //let userList = usersManager.getUsers()
        

        
        
        Button(action: {
            if(!isPressed){
                textSize = 20
                buttonText = "About to alert, tap again to cancel"
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if (textSize == 20){
                        buttonColor = Color.red
                        sendAlert()
                        buttonText = "Alerted Friends"
                    }
                    else{
                        buttonColor = Color.black
                    }
                }
            }
            else{
                textSize = 40
                buttonColor = Color.black
                buttonText = "Alert"
                isPressed = false
            }
        }, label: {
            Text(buttonText)
                .padding()
                .padding(.horizontal, 80)
                .padding(.vertical, 80)
                .background(buttonColor)
                .foregroundColor(.white)
                .cornerRadius(1000)
                .font(.system(size: textSize))
        })
    }
    
    func loginPop(){
        let alert = UIAlertController(title: "Login", message: "Enter your name", preferredStyle: .alert)
        alert.addTextField { (pass) in
            pass.placeholder = "Name"
        }
        //Action Buttons...
        let Add = UIAlertAction(title: "login", style: .default){(_) in
            usersManager.uploadUser(_name: alert.textFields![0].text!, _id: vendorIdentifier, _friendsList: [])
        }
        
        alert.addAction(Add)

        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
            
        })
    }
}

struct NetworkView: View {
    @State var customAlert = false
    @State var HUD = false
    @State var FriendID = ""
    @State private var friendIDs: [String] = []
    @State private var friendList: [String] = [] // New v
    
    let vendorIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
        
    var body: some View {
        ZStack{
            VStack(spacing:25){
                Text(vendorIdentifier)
                Button(action: {
                    alertView()
                }) {
                    Text("Add Friend")
                        .padding()
                        .padding(.horizontal, 100)
                        .padding(.vertical, 1)
                        .background(.green)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .font(.system(size: 20))
                }
                Text("Your Friends:")
                    .fontWeight(.bold)
                                
                List {
                    Section(header: HStack {
                        Text("IDs").fontWeight(.bold)
                        Spacer()
                        Text("Names").fontWeight(.bold)
                    }) {
                        ForEach(friendIDs.indices, id: \.self) { index in
                            HStack {
                                Text("\(friendIDs[index])")
                                Spacer()
                                Text("\(friendList[index])")
                            }
                        }
                    }
                }
                Spacer()
            }
            
        }
    }
    
    func alertView(){
        let alert = UIAlertController(title: "Add Friend", message: "Enter their ID", preferredStyle: .alert)
        alert.addTextField { (pass) in
            pass.placeholder = "ID"
        }
        alert.addTextField { (pass) in
            pass.placeholder = "Name"
        }
        //Action Buttons...
        let Add = UIAlertAction(title: "Add", style: .default){(_) in
            friendIDs.append(alert.textFields![0].text!)
            friendList.append(alert.textFields![1].text!)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive){(_) in
            //stuff
        }
        
        alert.addAction(cancel)
        
        alert.addAction(Add)

        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
            
        })
    }
}

struct AlertsView: View {
    @StateObject var alertsManager = AlertsManager()
    
    let vendorIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
    
    var body: some View {
        let alertList = alertsManager.getAlerts()
        //TO DO
        //Has all the alerts when we only want certain ones
        VStack{
            List {
                Section(header: HStack {
                    Text("Name").fontWeight(.bold)
                    Spacer()
                    Text("Time").fontWeight(.bold)
                }) {
                    //let Acount = A.count
                    ForEach(alertList.indices, id: \.self) { index in
                        //let alerts = alertsManager.getAlerts()
                        if(vendorIdentifier == alertList[index].vendorID){
                            HStack {
                                Button(action: {
                                    print("hey") //go to map
                                }) {
                                    Text("\(alertList[index].username) at \(alertList[index].timestamp)")
                                        .padding()
                                        .padding(.horizontal, 50)
                                        .padding(.vertical, 1)
                                        .background(.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(30)
                                        .font(.system(size: 20))
                                }
                            }
                        }
                        
                    }
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func sendAlert(/*message: String*/){ // send a broadcast to the firebase server
    let vendorIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
    let db = Firestore.firestore()
    do{
        let newAlert = Alert(id:"1",vendorID:vendorIdentifier,username:"Jonah",timestamp: Date(),message:"HELP!")
        try db.collection("Alerts").document().setData(from: newAlert)
    }
    catch{
        print("Error adding alert to Firestore: \(error)")
    }
    
}
