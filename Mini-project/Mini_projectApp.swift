import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import UserNotifications
import Contacts

@main
struct Mini_projectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
   
    init() {
            FirebaseApp.configure()
        
        }
    var body: some Scene {
        WindowGroup {
            LoginSignUpView()
            
            
            
            
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    let todolistviewmodel = TodoListViewModel()
    @State var selectedTab: BottomBarSelectedTab = .profile

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
       // FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self // Set the delegate for handling notifications
        return true
    }


    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

    // Implement delegate method to handle notifications when the app is in the foreground
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let identifier = notification.request.identifier
//
//        if identifier == "callnotconn" {
//            print("Notification Title: \(notification.request.content.title)")
//        }
//        
//
//        completionHandler([.banner, .sound, .badge]) // You can adjust the options based on your requirements
//    }
//    
    
    // Search for contact with the given name
      func findContact(withName name: String) -> ContactInfo? {
          let contactStore = CNContactStore()
          let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
          let predicate = CNContact.predicateForContacts(matchingName: name)
          
          do {
              let contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keys)
              if let contact = contacts.first {
                  let firstName = contact.givenName
                  let lastName = contact.familyName
                  let phoneNumber = contact.phoneNumbers.first?.value.stringValue
                  return ContactInfo(firstName: firstName, lastName: lastName, phoneNumber: PhoneNumber(stringValue: phoneNumber ?? ""))
              }
          } catch {
              print("Error fetching contact: \(error.localizedDescription)")
          }
          
          return nil
      }



    
    
    // Implement delegate method to handle user's interaction with notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.notification.request.identifier
        let task = response.notification.request.content.userInfo
        let contactName = response.notification.request.content.userInfo["contact"] as? String
        
        let receivedContact = findContact(withName: contactName ?? "Anna Haro")
        
        
        
     

        switch identifier {
        case "keyboardReminder_meet":
            print("User clicked on keyboardReminder_meet notification")
            // Code to open MeetingReminderInputView
            let rootViewController = UIApplication.shared.windows.first?.rootViewController
            let addView = AddView(selectedReminderType: 1, todo: Task(type: 2, contact: receivedContact), todolistviewmodel: todolistviewmodel, contact: receivedContact!, selectedTab: $selectedTab)
            rootViewController?.present(UIHostingController(rootView: addView), animated: true)

        case "keyboardReminder_call":
            print("User clicked on keyboardReminder_call notification")
            // Code to open CallReminderInputView
            let rootViewController = UIApplication.shared.windows.first?.rootViewController
            let addView = AddView(selectedReminderType: 2,todo: Task(type: 3, contact: receivedContact), todolistviewmodel: todolistviewmodel,contact: receivedContact!, selectedTab: $selectedTab)
            rootViewController?.present(UIHostingController(rootView: addView), animated: true)

        case "keyboardReminder_birthday":
            print("User clicked on keyboardReminder_birthday notification")
            // Code to open BirthdayReminderInputView
            let rootViewController = UIApplication.shared.windows.first?.rootViewController
            let addView = AddView(selectedReminderType: 0,todo: Task(type: 1, contact: receivedContact), todolistviewmodel: todolistviewmodel,contact: receivedContact!, selectedTab: $selectedTab)
            rootViewController?.present(UIHostingController(rootView: addView), animated: true)
            
        case "Call":
            print("User clicked on call notification")
            // Code to open BirthdayReminderInputView
            let rootViewController = UIApplication.shared.windows.first?.rootViewController
            if let task1 = handleNotification(userInfo: task){
//
                if let phoneNumber = task1.contact?.phoneNumber?.stringValue, !phoneNumber.isEmpty {
                    guard let number = URL(string: "tel://" + phoneNumber) else { return }
                    UIApplication.shared.open(number)
                }
//                let url = URL(string: "whatsapp://send?phone=\(task1.contact?.phoneNumber)&text=Hello")!
//                if UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                } else {
//                    // WhatsApp is not installed
//                    // You can handle this case as per your app's requirement
//                    print("WhatsApp is not installed on this device.")
//                }
            }
            else {
                print("Error in fetching the task from notifiaction")
            }
            
        case "Birthday":
            print("User clicked on call notification")
            // Code to open BirthdayReminderInputView
            let rootViewController = UIApplication.shared.windows.first?.rootViewController
            if let task1 = handleNotification(userInfo: task){
                
                let addView = TaskDetailView(task: task1)
                rootViewController?.present(UIHostingController(rootView: addView), animated: true)
            }
            else {
                print("Error in fetching the task from notifiaction")
            }
            
        case "Meet":
            print("User clicked on call notification")
            // Code to open BirthdayReminderInputView
            let rootViewController = UIApplication.shared.windows.first?.rootViewController
            if let task1 = handleNotification(userInfo: task){
                
                let addView = MeetingView(task: task1)
                
            }
            else {
                print("Error in fetching the task from notifiaction")
            }
        case "Custom":
            print("User clicked on call notification")
            // Code to open BirthdayReminderInputView
            let rootViewController = UIApplication.shared.windows.first?.rootViewController
            if let task1 = handleNotification(userInfo: task){
                
                let addView = TaskDetailView(task: task1)
                rootViewController?.present(UIHostingController(rootView: addView), animated: true)
                rootViewController?.modalPresentationStyle = .fullScreen
            }
            else {
                print("Error in fetching the task from notifiaction")
            }
            
            
        

        default:
            print("User clicked on a notification with an unrecognized identifier")
        }

        // Call the completion handler when finished processing the notification
        completionHandler()
    }
}
