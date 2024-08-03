import SwiftUI
import ContactsUI



struct AddView: View {
    var reminderTypes = ["Birthday", "Meeting", "Call", "Custom"]
    @State var selectedReminderType = 0
    @State var todo: Task
    @ObservedObject var todolistviewmodel : TodoListViewModel
    @State var contact: ContactInfo
    @Binding var selectedTab : BottomBarSelectedTab
    @Environment(\.presentationMode) var presentationMode
    

    @State private var keyboardHeight: CGFloat = 0
    
var body: some View {
    
    
    
    VStack(spacing: 0) {
            HStack {
                Text("Add ToDo")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom, keyboardHeight)
                .edgesIgnoringSafeArea(.bottom)
                .navigationBarTitleDisplayMode(.inline)

        ScrollView(){
            // Picker for selecting reminder type
            Picker(selection: $selectedReminderType, label: Text("Reminder Type")) {
                
                ForEach(0..<reminderTypes.count) {
                    Text(self.reminderTypes[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .onChange(of: selectedReminderType) { newValue in
                            // Update the 'type' property of 'data' based on the selected reminder type
                            switch newValue {
                            case 0: // Birthday Reminder
                                todo.type = 1

                            case 1: // Meeting Reminder
                                todo.type = 2

                            case 2: // Call Reminder
                                todo.type = 3

                            case 3: // Custom Reminder
                                todo.type = 4

                            default:
                                todo.type = 0 // Set default value if needed
                            }
                        }
            .onAppear(){
                switch selectedReminderType {
                case 0: // Birthday Reminder
                    todo.type = 1

                case 1: // Meeting Reminder
                    todo.type = 2

                case 2: // Call Reminder
                    todo.type = 3

                case 3: // Custom Reminder
                    todo.type = 4

                default:
                    todo.type = 0 // Set default value if needed
                }
            }

            // Specific input fields based on selected reminder type
            
            switch todo.type {
            case 1: // Birthday Reminder{
                BirthdayReminderInputView(todo: $todo,contact: $contact)

            case 2: // Meeting Reminder
                MeetingReminderInputView(todo: $todo,contact: $contact)

            case 3: // Call Reminder
                CallReminderInputView(todo: $todo,contact: $contact)

            case 4: // Custom Reminder
                CustomReminderInputView(todo: $todo)

            default:
                Text("Invalid reminder type")
            }


            Spacer()

            Button(action: {
                // Add your action here
                print("Yeahhhh!!")
                print(todo.type)
                todo.contact = contact
                print(contact)
                todolistviewmodel.addTask(todo)
                //                    print("after adding",todo)
                //                    // Save tasks through the view model
                                    todolistviewmodel.saveTasks()
//                print(todo.contact)
//                todolistviewmodel.addTask(todo)
                
                if selectedTab == .plus{
                    selectedTab = .home
                }
                else{
                    presentationMode.wrappedValue.dismiss()
                }
                
            }) {
                Text("Add ToDo Item")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .font(.headline)
            }
            .padding(.horizontal)

            Spacer()
        }
        }
           
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BirthdayReminderInputView: View {
    @Binding var todo: Task // Add this line
    @State var selectedDate = Date()
    @Binding var contact : ContactInfo
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Birthday Person Name")
                .font(.headline)
                .foregroundColor(.blue)

            TextField("Name", text: $todo.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Text("Contact Details:")
                .font(.headline)
                .foregroundColor(.blue)
            
          
            
            ContactSelectionButton(contact: $contact)// Pass the todo binding

            DatePicker("Date of Birth", selection: $selectedDate,in: Date()..., displayedComponents: [.date , .hourAndMinute])
                .onChange(of: selectedDate) { newValue in
                    // Update the reminderDate when the selected date changes
                    todo.reminderDate = newValue
                }
        }
        .padding(.horizontal)
    }
}

struct MeetingReminderInputView: View {
    @Binding var todo: Task // Add this line
    @State var selectedDate = Date()
    @Binding var contact : ContactInfo
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Meeting Title")
                .font(.headline)
                .foregroundColor(.blue)

            TextField("Title", text: $todo.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Text("Meeting Link")
                .font(.headline)
                .foregroundColor(.blue)

            TextField("Link", text: $todo.link)

            Text("Contact Details:")
                .font(.headline)
                .foregroundColor(.blue)

            ContactSelectionButton(contact: $contact)

            TextField("Email", text: $todo.mail)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            DatePicker("Date of Meeting:", selection: $selectedDate, in: Date()..., displayedComponents: [.date , .hourAndMinute])
                .onChange(of: selectedDate) { newValue in
                    // Update the reminderDate when the selected date changes
                    todo.reminderDate = newValue
                }
        }
        .padding(.horizontal)
    }
}

struct CallReminderInputView: View {
    @Binding var todo: Task // Add this line
    @State var selectedDate = Date()
    @Binding var contact : ContactInfo
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Call Title")
                .font(.headline)
                .foregroundColor(.blue)
            TextField("Title", text: $todo.title)
            
            Text("Contact Details:")
                .font(.headline)
                .foregroundColor(.blue)

            ContactSelectionButton(contact: $contact)

            Text("Description")
                .font(.headline)
                .foregroundColor(.blue)

            TextField("Description", text: $todo.description)

            DatePicker("Select Date:", selection: $selectedDate, in: Date()..., displayedComponents: [.date , .hourAndMinute])
                .onChange(of: selectedDate) { newValue in
                    // Update the reminderDate when the selected date changes
                    todo.reminderDate = newValue
                }
        }
        .padding(.horizontal)
    }
}

struct CustomReminderInputView: View {
    @Binding var todo: Task // Add this line
    @State var selectedDate = Date()
   
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Reminder Title")
                .font(.headline)
                .foregroundColor(.blue)

            TextField("Title", text: $todo.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Text("Description")
                .font(.headline)
                .foregroundColor(.blue)

            TextField("Description", text: $todo.description)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Text("Event Link")
                .font(.headline)
                .foregroundColor(.blue)

            TextField("Link", text: $todo.link)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            DatePicker("Select Date:", selection: $selectedDate, in: Date()..., displayedComponents: [.date , .hourAndMinute])
                .onChange(of: selectedDate) { newValue in
                    // Update the reminderDate when the selected date changes
                    todo.reminderDate = newValue
                }
        }
        .padding(.horizontal)
    }
}

struct ContactSelectionButton: View {
    @State private var isContactPickerPresented = false
    @Binding var contact : ContactInfo
    
    var body: some View {
        HStack {
            Spacer()
            if !((contact.phoneNumber?.stringValue) == nil) {
                HStack{
                    Spacer()
                    VStack(alignment: .leading, spacing: 10) {
                        
                        HStack{
                            Spacer()
                            Text("Contact Information")
                                .font(.headline).underline()
                            Spacer()
                        }
                        
                        if(contact.firstName.isEmpty)
                        {
                            Text("No contact")
                        }
                        else{
                            Text("First Name: \(contact.firstName)")
                            Text("Last Name: \(contact.lastName)")
                        }
                        if let phoneNumber = contact.phoneNumber?.stringValue {
                            Text("Phone Number: \(phoneNumber)")
                        }
                        Button("Click here to edit contact"){
                            isContactPickerPresented.toggle()
                        }.sheet(isPresented: $isContactPickerPresented){
                            ContactView(contactObj:$contact)
                        }
//                        NavigationLink("Click here to edit contact", destination: ContactView(contactObj:$contact))
//                            .padding(.horizontal)
                            
                    }
                    .padding().background(Color(red: 255/255.0, green: 246/255.0, blue: 233/255.0)).cornerRadius(7.0)
                Spacer()
                }
                
            } else{
                Button(action: {
                    isContactPickerPresented.toggle()
                    
                }) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.largeTitle)
                    Text("Select Contact")
                }
                .foregroundColor(.blue)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .sheet(isPresented: $isContactPickerPresented) {
                    ContactView(contactObj:$contact)
                }
                Spacer()
            }
        }
    }
}

struct ContactPickerView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Update logic (if needed)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented)
    }
    
    class Coordinator: NSObject, CNContactPickerDelegate {
        @Binding var isPresented: Bool
        
        init(isPresented: Binding<Bool>) {
            _isPresented = isPresented
        }
        
        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            isPresented = false
        }
    }
}
