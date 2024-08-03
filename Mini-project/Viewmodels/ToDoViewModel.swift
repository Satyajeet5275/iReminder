import Foundation
import FirebaseAuth
import Contacts
import FirebaseCore
import FirebaseDatabase
import UserNotifications

class TodoListViewModel: ObservableObject {
   
    @Published var tasks: [Task] = []
    var notification = NotificationManager.instance
    private var database: DatabaseReference!
    private var remindersRefHandle: DatabaseHandle?
   
    init() {
        database = Database.database().reference()
        loadTasks()
        observeRemindersForUser()
    }
   
    func observeRemindersForUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            // Clear tasks and local storage when user logs out
            tasks = []
            clearLocalStorage()
            return
        }

        let remindersRef = database.child("users").child(userId).child("reminders")
        remindersRefHandle = remindersRef.observe(.value) { [weak self] snapshot in
            guard let self = self else { return }
            self.tasks = [] // Clear the tasks array

            if let snapshotValue = snapshot.value as? [String: Any] {
                for (_, taskData) in snapshotValue {
                    if let taskData = taskData as? [String: Any] {
                        self.handleNewTask(taskData, fromFirebase: true)
                    }
                }
                self.saveTasks() // Save tasks to local storage
            }
        }
    }

    private func clearLocalStorage() {
        let userDefaultsKey = Bundle.main.bundleIdentifier ?? "YourAppIdentifier.Tasks"
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
    func handleNewTask(_ taskData: [String: Any], fromFirebase: Bool) {
        guard let id = taskData["id"] as? String,
              let firebaseId = taskData["firebaseId"] as? String,
              let type = taskData["type"] as? Int,
              let title = taskData["title"] as? String,
              let description = taskData["description"] as? String,
              let link = taskData["link"] as? String,
              let mail = taskData["mail"] as? String,
              let dueDate = taskData["dueDate"] as? TimeInterval,
              let reminderDate = taskData["reminderDate"] as? TimeInterval,
              let isCompleted = taskData["completed"] as? Bool else {
            return
        }
       
        let newTask = Task(
            id: id,
            type: type,
            title: title,
            description: description,
            link: link,
            mail: mail,
            dueDate: Date(timeIntervalSince1970: dueDate),
            isCompleted: isCompleted,
            reminderDate: Date(timeIntervalSince1970: reminderDate),
            firebaseId: firebaseId
        )
       
        if fromFirebase {
            tasks.append(newTask)
        } else {
            // Check if the task already exists in the tasks array
            if let existingIndex = tasks.firstIndex(where: { $0.id == newTask.id }) {
                // Update the existing task
                tasks[existingIndex] = newTask
            } else {
                // Add the new task
                tasks.append(newTask)
            }
        }
    }
   
    func addTask(_ task: Task) {
        let notificationTitle = task.title
        let notificationBody = task.description
       
        if let notificationDate = task.reminderDate {
            if let uuid = UUID(uuidString: task.id) {
                notification.scheduleNotification(title: notificationTitle, body: notificationBody, date: notificationDate, id: uuid, task: task)
            } else {
                print("Failed to create UUID from task.id")
            }
        }
       
        handleNewTask(task.toData(), fromFirebase: false)
        saveTasks()
        saveTaskToFirebase(task)
    }
    func saveTaskToFirebase(_ task: Task) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
       
        let taskData: [String: Any] = task.toData()
       
        let remindersRef = database.child("users").child(userId).child("reminders").child(task.firebaseId ?? task.id)
        remindersRef.setValue(taskData)
    }
   
    func saveTasks() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(tasks)
            UserDefaults.standard.set(data, forKey: Bundle.main.bundleIdentifier ?? "YourAppIdentifier.Tasks")
        } catch {
            print("Error encoding tasks: \(error)")
        }
    }
   
    func removeTasks(at indices: IndexSet) {
        // Get the tasks to be removed
        let tasksToRemove = indices.compactMap { tasks[$0] }
        
        // Remove tasks from Firebase Realtime Database
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let databaseRef = database.child("users").child(userId).child("reminders")
        let tasksToRemoveIds = tasksToRemove.compactMap { $0.firebaseId }
        
        for taskId in tasksToRemoveIds {
            let taskRef = databaseRef.child(taskId)
            taskRef.removeValue { error, _ in
                if let error = error {
                    print("Error removing task from Firebase: \(error.localizedDescription)")
                } else {
                    print("Task removed successfully from Firebase")
                    print(taskId)
                }
            }
        }
        
        // Remove tasks locally
        tasks = tasks.filter { task in
            return !tasksToRemove.contains(where: { $0.id == task.id })
        }
        
        // Save changes to local storage
        saveTasks()
    }
   
    func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: Bundle.main.bundleIdentifier ?? "YourAppIdentifier.Tasks") {
            do {
                let decoder = JSONDecoder()
                let loadedTasks = try decoder.decode([Task].self, from: data)
                tasks = loadedTasks
            } catch {
                print("Error decoding tasks: \(error)")
            }
        }
    }
}

extension Task {
    func toData() -> [String: Any] {
        return [
            "id": id,
            "firebaseId": firebaseId ?? id, // Use firebaseId if available, otherwise use id
            "type": type,
            "title": title,
            "description": description,
            "link": link,
            "mail": mail,
            "dueDate": dueDate.timeIntervalSince1970,
            "reminderDate": reminderDate?.timeIntervalSince1970 ?? 0,
            "completed": isCompleted
        ]
    }
}
