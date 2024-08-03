import Foundation

import UserNotifications



class NotificationManager {

    static let instance = NotificationManager()

    

    func requestAuth() {

        let options: UNAuthorizationOptions = [.alert, .badge, .sound]

        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in

            if let error = error {

                print(error.localizedDescription)

            } else {

                print("Authorization granted: \(success)")

            }

        }

    }

    

    func scheduleNotification(title: String, body: String, date: Date, id: UUID,task : Task) {

        let content = UNMutableNotificationContent()

        content.title = title

        content.body = body

        content.sound = UNNotificationSound.default
        
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(task) else {
            fatalError("Failed to encode custom object")
        }
//        guard let userInfo = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
//            fatalError("Failed to convert data to NSDictionary")
//        }
//        
        content.userInfo = ["customData": data]


        

        let snooze = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])

        let open = UNNotificationAction(identifier: "Open App", title: "Open App", options: [])
        var identifier: String
        if task.type == 1 {
            identifier = "Birthday"
        }
        if task.type == 2 {
            identifier = "Meet"
        }
        if task.type == 3 {
            identifier = "Call"
        }
        else{
            identifier = "Custom"
        }

        let category = UNNotificationCategory(identifier: identifier, actions: [snooze, open], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)

        

        let calendar = Calendar.current

        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        

        let notificationCenter = UNUserNotificationCenter.current()

        notificationCenter.setNotificationCategories([category])

        notificationCenter.add(request) { error in

            if let error = error {

                print("Error scheduling notification: \(error.localizedDescription)")

            } else {

                print("Notification scheduled successfully")

            }

        }

    }

}

func handleNotification (userInfo: [AnyHashable: Any])  -> Task? {
    if let data = userInfo["customData"] as? Data {
        let decoder = JSONDecoder()
        do {
            // Decode the data back to your custom struct
            let customStruct = try decoder.decode(Task.self, from: data)
            // Now you have your custom struct object
            print("Received Custom Data: \(customStruct)")
            return customStruct;
        } catch {
            print("Error decoding custom struct: \(error)")
        }
    }
    return nil
}



//for in app interaction





// NotificationDelegate.swift

import Foundation

import UserNotifications



class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.badge, .banner, .sound])

    }

}
