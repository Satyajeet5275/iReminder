//
//  ContactView.swift
//  Mini-project
//
//  Created by mini project on 08/02/24.
//

import SwiftUI
import Contacts

struct ContactView: View {
    @State private var contacts = [ContactInfo.init(firstName: "", lastName: "", phoneNumber: nil)]
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    @Binding var contactObj : ContactInfo
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            HStack {
                  HStack {
                     //search bar magnifying glass image
                     Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                              
                     //search bar text field
                     TextField("search", text: self.$searchText, onEditingChanged: { isEditing in
                     self.showCancelButton = true
                     })
                     
                     // x Button
                     Button(action: {
                         self.searchText = ""
                     }) {
                         Image(systemName: "xmark.circle.fill")
                              .foregroundColor(.secondary)
                                .opacity(self.searchText == "" ? 0 : 1)
                        }
              }
               .padding(8)
               .background(Color(.secondarySystemBackground))
               .cornerRadius(8)
                          
                // Cancel Button
                if self.showCancelButton  {
                    Button("Cancel") {
                       UIApplication.shared.endEditing(true)
                       self.searchText = ""
                       self.showCancelButton = false
                 }
               }
             }
              .padding([.leading, .trailing,.top])
        }
        
        
        List {
                       ForEach (self.contacts.filter({ (cont) -> Bool in
                           self.searchText.isEmpty ? true :
                               "\(cont)".lowercased().contains(self.searchText.lowercased())
                       })) { contact in
                           ContactRow(contact: contact)
                               .onTapGesture(perform: { print(contact)
                                   contactObj.firstName = contact.firstName
                                   contactObj.lastName  = contact.lastName
                                   contactObj.phoneNumber = contact.phoneNumber
                                   print("Contact Obj" , contactObj)
                                   presentationMode.wrappedValue.dismiss()
                                    
                               })
                       }
                   }.onAppear() {
                       self.requestAccess()
                   }
    }
    
    
    func getContacts() {
            DispatchQueue.main.async {
                self.contacts = FetchContacts().fetchingContacts()
            }
        }
    
    
    
    func requestAccess() {
            let store = CNContactStore()
            switch CNContactStore.authorizationStatus(for: .contacts) {
            case .authorized:
                self.getContacts()
            case .denied:
                store.requestAccess(for: .contacts) { granted, error in
                    if granted {
                        self.getContacts()
                    }
                }
            case .restricted, .notDetermined:
                store.requestAccess(for: .contacts) { granted, error in
                    if granted {
                        self.getContacts()
                    }
                }
            @unknown default:
                print("error")
            }
        }
    
    
    }





struct ContactRow: View {
    var contact: ContactInfo
    var body: some View {
        Text("\(contact.firstName) \(contact.lastName)").foregroundColor(.primary)
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}




//#Preview {
//    @State var contact = ContactInfo(firstName: "Hello", lastName: "World")
//    ContactView(contactObj:$ contact)
//}
