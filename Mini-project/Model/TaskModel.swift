import Foundation
import Contacts
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

struct Task: Identifiable, Codable {
    var id: String
    var type: Int
    var title: String
    var description: String
    var link: String
    var mail: String
    var dueDate: Date
    var isCompleted: Bool
    var reminderDate: Date?
    var contact: ContactInfo?
    var firebaseId: String? // Add this property to store the Firebase ID

    init(
        id: String = UUID().uuidString, // Generate a new UUID string for id
        type: Int = 0,
        title: String = "",
        description: String = "",
        link: String = "",
        mail: String = "",
        dueDate: Date = Date(),
        isCompleted: Bool = false,
        reminderDate: Date? = nil,
        contact: ContactInfo? = nil,
        firebaseId: String? = nil // Add this parameter for Firebase ID
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.reminderDate = reminderDate
        self.contact = contact
        self.type = type
        self.link = link
        self.mail = mail
        self.firebaseId = firebaseId // Assign the Firebase ID
    }
}

struct PhoneNumber: Codable, Equatable, Hashable {
    var stringValue: String

    init(stringValue: String) {
        self.stringValue = stringValue
    }
}

struct ContactInfo: Identifiable, Codable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var phoneNumber: PhoneNumber?

    init(firstName: String, lastName: String, phoneNumber: PhoneNumber? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
    }
}
