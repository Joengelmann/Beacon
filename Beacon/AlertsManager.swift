import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class AlertsManager: ObservableObject {
    @Published private(set) var alerts: [Alert] = []
    let db = Firestore.firestore()

    init() {
        downloadAlerts()
    }

    func downloadAlerts() {
        db.collection("Alerts").addSnapshotListener {querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }

            self.alerts = documents.compactMap {document -> Alert? in
                do {
                    return try document.data(as: Alert.self)
                } catch {
                    print("Error decoding document into Alert \(error)")
                    return nil
                }
            }

        }
    }
    func sendAlert(message: String){ // send a broadcast to the firebase server
        do{
            let newAlert = Alert(id:"420",userID:"69",timestamp: Date(),message:"HELP!")
            try db.collection("Alerts").document().setData(from: newAlert)
        }
        catch{
            print("Error adding alert to Firestore: \(error)")
        }
        
    }
    
    
    func getAlertString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Set your desired date format
        
        var output = ""
        for currAlert in alerts {
                let dateString = dateFormatter.string(from: currAlert.timestamp)
                output += "\(currAlert.id)\n\(currAlert.userID)\n\(dateString)\n\(currAlert.message)\n\n"
            }
        return output
    }
}
