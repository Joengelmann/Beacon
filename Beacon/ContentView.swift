
import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct ContentView: View {
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
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                    
                }
        }
    }
}

struct MainView: View {
    @State private var buttonColor: Color = Color.black
    @State private var buttonText: String = "Alert"
    @State private var isPressed: Bool = false
    @State private var textSize: CGFloat = 40.0
    
    var body: some View {
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
}

struct NetworkView: View {
    @State var customAlert = false
    @State var HUD = false
    @State var FriendID = ""
    @State private var friendIDs: [String] = []
    @State private var friendList: [String] = [] // New v
    
    var body: some View {
        ZStack{
            VStack(spacing:25){
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

struct SettingsView: View {
    @StateObject var alertsManager = AlertsManager()
    
    var body: some View {
        Text(alertsManager.getAlertString())
        
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
