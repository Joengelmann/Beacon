import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class AlertsManager: ObservableObject {
    @Published private(set) var alerts: [Alert] = []
    let db = Firestore.firestore()

    init() {
        getAlerts()
    }

    func getAlerts() {
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
}