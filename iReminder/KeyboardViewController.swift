//
//  KeyboardViewController.swift

import KeyboardKit
import SwiftUI
import Contacts
import UserNotifications
import EventKit
import Toast

struct ContactListView: View {
    var contacts: [String] // Assuming contacts are represented by strings
    var didSelectContact: (String) -> Void // Callback to handle contact selection

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(contacts, id: \.self) { contact in
                    Button(action: {
                        didSelectContact(contact)
                    }) {
                        Text(contact)
                            .padding(8)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }
}



class KeyboardViewController: KeyboardInputViewController, FakeAutocompleteProviderDelegate {
    @State var showemojikeyboard = false
    var contacts = [String]() // Will hold the fetched contacts data
    var searchText = ""
    var typetext = ""

    
    

    
    private func scheduleBirthdayReminder(for contact: String) {
        let reminderStore = EKEventStore()

        reminderStore.requestAccess(to: .reminder) { (granted, error) in
            if granted {
                let reminder = EKReminder(eventStore: reminderStore)
                reminder.title = "\(contact)'s Birthday"
                reminder.notes = "Birthday reminder"

                var dateComponents = DateComponents()
                dateComponents.year = Calendar.current.dateComponents([.year], from: Date()).year! + 1
                dateComponents.month = Calendar.current.dateComponents([.month], from: Date()).month
                dateComponents.day = Calendar.current.dateComponents([.day], from: Date()).day
                reminder.dueDateComponents = dateComponents
                
                
                // Create a recurrence rule to repeat annually
                            let recurrenceRule = EKRecurrenceRule(recurrenceWith: .yearly, interval: 1, end: nil)
                            reminder.recurrenceRules = [recurrenceRule]

                reminder.calendar = reminderStore.defaultCalendarForNewReminders()

                do {
                    try reminderStore.save(reminder, commit: true)
                    print("Birthday reminder saved successfully.")

                    // Show a toast message
                    DispatchQueue.main.async {
                        var style = ToastStyle()
                                
                                // Customize the toast appearance
                                style.messageFont = .systemFont(ofSize: 16, weight: .semibold)
                                style.messageColor = .white
                                style.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.4, alpha: 1.0)
                                style.cornerRadius = 20
                                style.verticalPadding = 16
                                style.horizontalPadding = 20


                        self.view.makeToast("Birthday reminder for \(contact) has been added to the Reminders app.", duration: 3.0, position: .bottom, style: style)
                    }
                } catch {
                    print("Error saving birthday reminder: \(error.localizedDescription)")
                }
            } else {
                if let error = error {
                    print("Access to Reminders denied: \(error.localizedDescription)")
                } else {
                    print("Access to Reminders denied.")
                }
            }
        }
    }
    
    
    func didChangeText(_ searchText: String) {
        var filteredSearchText = searchText
        var contactsToDisplay: [String] = []

        if filteredSearchText.lowercased().starts(with: "call@") {
            typetext = String(filteredSearchText.dropLast(filteredSearchText.count - 4))
            filteredSearchText = String(filteredSearchText.dropFirst(5))
        }
        if filteredSearchText.lowercased().starts(with: "meet@") {
            typetext = String(filteredSearchText.dropLast(filteredSearchText.count - 4))
            filteredSearchText = String(filteredSearchText.dropFirst(5))
        }
        if filteredSearchText.lowercased().starts(with: "birthday@") {
            typetext = String(filteredSearchText.dropLast(filteredSearchText.count - 8))
            filteredSearchText = String(filteredSearchText.dropFirst(9))
            if !filteredSearchText.isEmpty {
                contactsToDisplay = [filteredSearchText]
            }
        }
        if filteredSearchText.lowercased().starts(with: "@") {
            typetext = String(filteredSearchText.dropLast(filteredSearchText.count - 1))
        }

        self.searchText = filteredSearchText

        if !contactsToDisplay.isEmpty {
            contacts = contactsToDisplay
        } else {
            do {
                contacts = try getMatchingContacts(searchText: filteredSearchText)
            } catch {
                print("Error fetching matching contacts: \(error.localizedDescription)")
            }
        }

        print(searchText)
        print("typetext\(typetext)")
        print(contacts)
    }
    
    func requestNotificationAuthorization() {
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
             if granted {
                 print("Notification authorization granted.")
             } else {
                 print("Notification authorization denied.")
             }
         }
     }
    
    func scheduleNotification(type: String, contact: String) {
        switch type {
        case "call":
            scheduleCallReminder(for: contact)
        case "meet":
            scheduleMeetingReminder(for: contact)
        case "birthday":
            scheduleBirthdayReminder(for: contact)
        default:
            break
        }
    }

    private func scheduleCallReminder(for contact: String) {
        let content = UNMutableNotificationContent()
        content.title = "iReminder"
        content.userInfo = ["contact": contact]
        content.body = "Call \(contact)?"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = "keyboardReminder_call"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }

    private func scheduleMeetingReminder(for contact: String) {
        let content = UNMutableNotificationContent()
        content.title = "iReminder"
        content.userInfo = ["contact": contact]
        content.body = "Meeting with \(contact)?"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = "keyboardReminder_meet"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }

    private func findContact(withName name: String) -> String? {
        let contactStore = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let predicate = CNContact.predicateForContacts(matchingName: name)
        
        do {
            let contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keys)
            if let contact = contacts.first {
                if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                    return phoneNumber
                }
            }
        } catch {
            print("Error fetching contact: \(error.localizedDescription)")
        }
        
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(contacts)
        requestNotificationAuthorization()
        
        services.actionHandler = DemoActionHandler(
            controller: self,
            keyboardContext: state.keyboardContext,
            keyboardBehavior: services.keyboardBehavior,
            autocompleteContext: state.autocompleteContext,
            feedbackConfiguration: state.feedbackConfiguration,
            spaceDragGestureHandler: services.spaceDragGestureHandler
        )
        
        services.autocompleteProvider = FakeAutocompleteProvider(context: state.autocompleteContext)
       
        
        services.calloutActionProvider = StandardCalloutActionProvider(
            keyboardContext: state.keyboardContext,
            baseProvider: DemoCalloutActionProvider()
        )
        
        services.layoutProvider = DemoLayoutProvider()
        services.styleProvider = DemoStyleProvider(keyboardContext: state.keyboardContext)
        
        state.keyboardContext.setLocale(.english)
        state.keyboardContext.localePresentationLocale = .current
        state.keyboardContext.locales = []
        state.keyboardContext.keyboardDictationReplacement = .character("😀")
        state.keyboardContext.spaceLongPressBehavior = .moveInputCursor
        
        state.feedbackConfiguration.isHapticFeedbackEnabled = true
        state.feedbackConfiguration.audio.actions = [
            .init(action: .character("🙂"), feedback: .none)
        ]
        
        super.viewDidLoad()
        
        let autocompleteProvider = FakeAutocompleteProvider(context: state.autocompleteContext)
        autocompleteProvider.delegate = self
        services.autocompleteProvider = autocompleteProvider
    }
    
    private func getMatchingContacts(searchText: String) throws -> [String] {
        var matchingContacts: [String] = []
        var count = 0

        let predicate = CNContact.predicateForContacts(matchingName: searchText)
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]

        let contactStore = CNContactStore()
        let contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)

        for contact in contacts {
            if count < 10 {
                let fullName = "\(contact.givenName) \(contact.familyName)"
                matchingContacts.append(fullName)
                count += 1
            } else {
                break // Stops iteration once 10 matching contacts are fetched
            }
        }

        return matchingContacts
    }

    override func viewWillSetupKeyboard() {
        super.viewWillSetupKeyboard()

        setup { controller in
            SystemKeyboard(
                state: controller.state,
                services: controller.services,
                buttonContent: { $0.view },
                buttonView: { $0.view.scaleEffect(0.70) },
                emojiKeyboard: { $0.view },
                toolbar: { _ in
                    HStack {
                        Button(action: {
                            self.presentEmojiKeyboard()
                        }) {
                            Text("🙂")
                        }
                        Spacer()
                        ContactListView(contacts: self.contacts) { [self] contact in
                            if !typetext.isEmpty {
                                if typetext == "@" {
                                    textDocumentProxy.deleteBackward(times: 50)
                                    if let phoneNumber = findContact(withName: contact) {
                                        textDocumentProxy.insertText(phoneNumber)
                                    }
                                } else {
                                    scheduleNotification(type: typetext.lowercased(), contact: contact)
                                    print("Selected contact: \(contact)")
                                }
                            }
                        }
                    }
                    .padding(5)
                }
            )
        }
    }
}
