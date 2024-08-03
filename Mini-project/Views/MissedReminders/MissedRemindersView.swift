//
//  MissedRemindersView.swift
//  Mini-project
//
//  Created by mini project on 14/02/24.
//

import SwiftUI
import Contacts

struct MissedReminder: Identifiable {
    var id = UUID()
    var type: String
    var name: String
    var time: String
    var date: String
    var icon: String
}

struct MissedCallsView: View {
    
   
    var reminders: [MissedReminder] = [
        MissedReminder(type: "Missed Call", name: "Vijay Mali", time: "9:00 am", date: "TODAY, FEB 09 / 2024", icon: "phone.arrow.up.right"),
        MissedReminder(type: "Missed Call", name: "Vijay Mali", time: "9:00 am", date: "TODAY, FEB 09 / 2024", icon: "phone.arrow.up.right"),
        MissedReminder(type: "Missed Call", name: "John Doe", time: "10:30 am", date: "YESTERDAY, FEB 10 / 2024", icon: "phone.arrow.up.right"),
        MissedReminder(type: "New Message", name: "Jane Doe", time: "2:15 pm", date: "YESTERDAY, FEB 08 / 2024", icon: "message.circle.fill"),
        
        MissedReminder(type: "Missed Call", name: "Behen Doe", time: "10:30 am", date: "YESTERDAY, FEB 07 / 2024", icon: "phone.arrow.up.right"),
        MissedReminder(type: "New Message", name: "Jane Doe", time: "2:15 pm", date: "YESTERDAY, FEB 07 / 2024", icon: "message.circle.fill"),
        // Add more reminders as needed
    ]

    var groupedReminders: [String: [MissedReminder]] {
        Dictionary(grouping: reminders, by: { $0.date })
    }
    

    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(red:123/255,green: 147/255,blue: 169/255), Color(red:31/255,green: 72/255,blue: 109/255)]), startPoint: .topLeading, endPoint: .bottomTrailing)
            
            

            
            ScrollView {
                Spacer()
                    .frame(height: 160)
                VStack {
                    
                    
                    Spacer().frame(height: 20) // Add spacing between the bell icon and the existing content
                    
                    ForEach(groupedReminders.keys.sorted(), id: \.self) { date in
                        Text(date)
                            .font(.headline)
                            .padding(10)
                        
                        ForEach(groupedReminders[date]!) { reminder in
                            HStack {
                                
                                Image(systemName: reminder.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.red)
                                    .frame(width: 30, height: 30)
                                
                                Spacer().frame(width: 10)
                                
                                VStack(alignment: .leading) {
                                    Text("\(reminder.type): \(reminder.name)")
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.black)
                                    
                                    Text(reminder.time)
                                }
                                .frame(width: 200, height: 50)
                                
                                Button(action: {
                                    // Retry action
                                }) {

                                    VStack {
                                        Image(systemName: "gobackward")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                        
                                        Text("Retry")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .padding()
                            .frame()
                            .background(Color.gray.opacity(0.6))
                            .cornerRadius(10.0)
                        }
                        
                        Divider() // Add space between lists
                            .background(Color.gray)
                        
                        Spacer().padding()
                    }
                }
                .background(Color.white)
                .cornerRadius(15)
                .padding()
                // Add padding to the VStack
            }.overlay{
                VStack{
                    Spacer()
                        .frame(height: 50)
                   
                    HStack {
                        Image(systemName:"bell.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 30,height: 30)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(50)
                        
                        Spacer().frame(width: 20)
                        
                        Text("Missed Reminders")
                            .font(.title)
                            .fontWeight(.semibold)
                            .textScale(.default)
                    }
                    .frame(width: 364, height: 72)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.top, 20)
                    // Adjust top padding as needed
                    Spacer().frame(width: 100)
                }
            }
            
        }
        .ignoresSafeArea()
        
    }
}


