//
//  ContentView.swift
//  BottomBar
//
//  
//

import SwiftUI
import CallKit
import UserNotifications
class CallObserver: NSObject, CXCallObserverDelegate {
     
    let callObserver = CXCallObserver()
    var latestMissedCall: CXCall?
    
    override init() {
        super.init()
        callObserver.setDelegate(self, queue: nil)
    }
    
    
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.hasConnected {
            print("Call was answered")
            // Reset latestMissedCall if a call was answered
            latestMissedCall = nil
        } else if call.hasEnded {
            print("Call was rejected or unanswered")
            // Set latestMissedCall if a call was rejected or unanswered
            latestMissedCall = call
            // Send a notification to appear in the Notification Centre after 10 minutes
            sendNotification()
        }
    }
    
    func sendNotification() {
        // Code to send a notification to appear in the Notification Centre
        let content = UNMutableNotificationContent()
        content.title = "Remind me later"
        content.body = "You have a missed call"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // 10 minutes
        let request = UNNotificationRequest(identifier: "callnotconn", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

struct ContentView: View {
    let callObserver = CallObserver() // Create an instance of CallObserver to start observing call events
    
    @State var contact : ContactInfo = ContactInfo(firstName: "Vijay", lastName: "Mali")
    @ObservedObject var todolistviewmodel = TodoListViewModel()
    
    @State var selectedTab:BottomBarSelectedTab = .home
    var notification = NotificationManager.instance
    
    
    
  
    
    
    
    
    var body: some View {
        VStack {
            
            if selectedTab == .home{
                TodoListView()
            
//                Text("Home")
            }
            
//            if selectedTab == .search{
//                ContactView(contactObj: $contact)
////                Text("Search")
//            }
            
            if selectedTab == .plus{
                AddView( todo: Task(type: 1, contact: ContactInfo(firstName: "name", lastName: "name")), todolistviewmodel: todolistviewmodel,contact: ContactInfo(firstName: "", lastName: ""),  selectedTab: $selectedTab)
                Text("Add")
            }
//            if selectedTab == .notification{
//                MissedCallsView()
//            }
            if selectedTab == .profile{
                ProfileView()
//                Text("Profile")
            }
            Spacer()
            BottomBar(selectedTab: $selectedTab)
        }
        .environmentObject(todolistviewmodel)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            notification.requestAuth()
        }
    }
}
