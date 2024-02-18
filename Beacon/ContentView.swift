
import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit
import MapKit



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
    @State private var buttonColor: Color = Color(hex: "#584467")
    @State private var buttonText: String = "Beacon"
    @State private var isPressed: Bool = false
    @State private var textSize: CGFloat = 40.0
    @State var userfound: Bool = false
    
    @StateObject var usersManager = UsersManager()
    let vendorIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
    
    var body: some View {
        let userList = usersManager.getUsers()
        
        if(!login(userslist: userList)){
            
        }
        
        Button(action: {
            if(!isPressed){
                textSize = 20
                buttonText = "About to alert, tap again to cancel"
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if (textSize == 20){
                        buttonColor = Color.red
                        sendAlert(userList: usersManager.getUsers())
                        buttonText = "Alerted Friends"
                    }
                    else{
                        buttonColor = Color(hex: "#584467")
                    }
                }
            }
            else{
                textSize = 40
                buttonColor = Color(hex: "#584467")
                buttonText = "Beacon"
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
    
    @StateObject var userManager = UsersManager()
    
    let vendorIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
        
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
                        Text("").fontWeight(.bold)
                        Spacer()
                        Text("").fontWeight(.bold)
                    }) {
                        let userList = userManager.getUsers()
                        
                            
                        ForEach(userList.indices, id: \.self) { index in
                            if(vendorIdentifier == userList[index].id){
                                ForEach(userList[index].friends.indices, id: \.self) { index2 in
                                    HStack {
                                        Text(getName(id: userList[index].friends[index2],userList: userList))
                                    }
                                }
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
            pass.placeholder = "Name"
        }
        //Action Buttons...
        let Add = UIAlertAction(title: "Add", style: .default){(_) in
            let userList = userManager.getUsers()
            var Name = ""
            var Friends:[String] = []
            var inlistalready = false
            
            for index in userList.indices { //find your username and friends
                if userList[index].id == vendorIdentifier {
                    Name = userList[index].name
                    Friends = userList[index].friends
                }
            }
           
            for index in userList.indices {
                if(userList[index].name == alert.textFields![0].text!){
                    for i in Friends{
                        if i == userList[index].id{
                            inlistalready = true
                            break
                        }
                    }
                    if(!inlistalready){
                        Friends.append(userList[index].id)
                    }
                }
            }
            
            userManager.uploadUser(_name: Name, _id: vendorIdentifier, _friendsList: Friends)
            
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
    @StateObject var userManager = UsersManager()
    
    let vendorIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
    
    var body: some View {
        let alertList = alertsManager.getAlerts()
        let userList = userManager.getUsers()
        //TO DO
        //Has all the alerts when we only want certain ones
        NavigationView{
        VStack{
            List {
                Section(header: HStack {
                    Spacer()
                    Text("Alert").fontWeight(.bold)
                    Spacer()
                }) {
                    ForEach(alertList.indices, id: \.self) { index in
                        ForEach(getFriendslist(id: vendorIdentifier,userList: userList).indices, id: \.self) { index2 in
                            if(getFriendslist(id: vendorIdentifier,userList: userList)[index2] == alertList[index].vendorID){
                                
                                    HStack {
                                        NavigationLink(destination: MapView(), label:{
                                            Text("\(alertList[index].username) at \(alertList[index].timestamp)")
                                                .padding()
                                                .padding(.horizontal, 50)
                                                .padding(.vertical, 1)
                                                .background(Color(hex: "#85799E"))
                                                .foregroundColor(Color(hex: "#EFE8FD"))
                                                .cornerRadius(30)
                                                .font(.system(size: 20))
                                        })

                                        }
                                }
                            
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }

struct MapView: View {
  @StateObject private var viewModel = MapViewModel()
  @State var camera: MapCameraPosition = .automatic
  var body: some View {
    Map(position: $camera){
      Annotation("You", coordinate: viewModel.region1.center){
        Image(systemName: "circle.fill")
        .foregroundColor(.blue)      }
      Annotation("Friend", coordinate: viewModel.region2.center){
        Image(systemName: "circle.fill")
          .foregroundColor(.red)
      }
    }
    .ignoresSafeArea()
    .onAppear {
      viewModel.checkLocationEnabled()
    }
  }
  }
struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    MapView()
  }
}
final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
  @Published var region2 = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.348884 , longitude: -121.938375), span: MKCoordinateSpan())
  @Published var region1 = MKCoordinateRegion()
  var locationManager: CLLocationManager?
  func checkLocationEnabled() {
    if CLLocationManager.locationServicesEnabled() {
      locationManager = CLLocationManager()
      locationManager?.desiredAccuracy = kCLLocationAccuracyBest
      locationManager!.delegate = self
      checkLocationAuthorization()
    } else {
      print("Must turn on location services")
    }
  }
  private func checkLocationAuthorization() {
    guard let locationManager = locationManager else { return }
    switch locationManager.authorizationStatus {
        case .notDetermined :
          locationManager.requestWhenInUseAuthorization()
        case .restricted:
          print("Location is restricted, likely due to parental controls.")
        case .denied:
          print("You have denied this app location permission. Go into settings and change it.")
        case .authorizedWhenInUse, .authorizedAlways:
          locationManager.startUpdatingLocation()
        @unknown default:
          break
        }
  }
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkLocationAuthorization()
  }
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      region1 = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan())
    }
  }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func sendAlert(userList: [User]){ // send a broadcast to the firebase server
    let vendorIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
    let db = Firestore.firestore()
    do{
        let newAlert = Alert(id:"1",vendorID:vendorIdentifier,username: getName(id: vendorIdentifier, userList: userList),timestamp: Date(),message:"HELP!")
        try db.collection("Alerts").document().setData(from: newAlert)
    }
    catch{
        print("Error adding alert to Firestore: \(error)")
    }
    
}

func getName(id: String, userList: [User]) -> String{
    for index in userList.indices{
        if(userList[index].id == id){
            return userList[index].name
        }
    }
    return ""
}

func getFriendslist(id: String, userList: [User]) -> [String]{
    for index in userList.indices{
        if(userList[index].id == id){
            return userList[index].friends
        }
    }
    return [""]
}

func login(userslist: [User]) -> Bool{
    let vendorIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
    var founduser = false
    if(userslist.count == 0) {return true}
    for index in userslist.indices {
        if(vendorIdentifier == userslist[index].id){
            return true
        }
    }
    loginPop()
    return(founduser)
}

func loginPop(){
    @StateObject var usersManager = UsersManager()
    let vendorIdentifier = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
    
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

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: Double(a) / 255)
    }
}
