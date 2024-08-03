import SwiftUI
import MessageUI

struct MessageView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var recipients: [String]

    func makeUIViewController(context: Context) -> UIViewController {
        guard MFMessageComposeViewController.canSendText() else {
            DispatchQueue.main.async {
                self.isPresented = false
            }
            return UIViewController()
        }

        let messageComposeViewController = MFMessageComposeViewController()
        messageComposeViewController.messageComposeDelegate = context.coordinator
        messageComposeViewController.recipients = recipients
        return messageComposeViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller if needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var parent: MessageView

        init(_ parent: MessageView) {
            self.parent = parent
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            parent.isPresented = false
            controller.dismiss(animated: true)
        }
    }
}

struct SendView: View {
    @State private var isPresented = false
    var task : Task
    let recipients = ["3798328"] // Replace with your desired recipients
    
    var body: some View {
        Button("Send Message") {
            if ((task.contact?.phoneNumber?.stringValue.isEmpty) == nil){
                print("not opened")
                return;
            }
            isPresented = true
        }
        .sheet(isPresented: $isPresented) {
            MessageView(isPresented: $isPresented, recipients: recipients)
        }
    }
}



//struct SendView_Previews: PreviewProvider {
//    static var previews: some View {
//        SendView(task: Tas)
//    }
//}
