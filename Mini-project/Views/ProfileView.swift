import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct ProfileView: View {
    @State private var name = ""
    @State private var contact = ""
    @State private var appleID = ""
    @State private var profileImageURL: URL?
    @State private var hovering = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Spacer()
        VStack(spacing: 30.0) {
            VStack() {
                if let profileImageURL = profileImageURL {
                    AsyncImage(url: profileImageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                Text("Profile")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .shadow(radius: 10)
                
                VStack {
                    Text("Hello,")
                        .font(.title)
                        .bold()
                    Text(name)
                        .font(.title)
                        .bold()
                }
                
                VStack(spacing: 20.0) {
                   
                    HStack {
                        Spacer()
                        Image(systemName: "envelope")
                            .font(.title)
                        Text("AppleID: " + appleID)
                            .font(.caption) 
                        Spacer()
                    }
                }
                
                Button(action: {
                    logout()
                }) {
                    Text("Logout")
                        .foregroundColor(.red)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color.red.opacity(0.1))
                                        .opacity(.init(self.hovering ? 1 : 0))
                                )
                        )
                        .shadow(color: Color.red.opacity(0.5), radius: 5, x: 0, y: 2)
                }
                .onHover { hovering in
                    self.hovering = hovering
                }
            }
            .padding(.all)
            Spacer()
        }
        .padding()
        .onAppear {
            // Retrieve user information from Firebase Authentication
            if let user = Auth.auth().currentUser {
                self.name = user.displayName ?? "N/A"
                self.contact = user.phoneNumber ?? "N/A"
                self.appleID = user.email ?? "N/A"
                
                // Fetch user's profile image URL from Google
                if let googleUser = GIDSignIn.sharedInstance.currentUser,
                   let profileImageUrl = googleUser.profile?.imageURL(withDimension: 50) {
                    self.profileImageURL = profileImageUrl
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            dismiss.self()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        print("Logged out")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
