import SwiftUI
import FirebaseAuth

struct LoginSignUpView: View {
    @StateObject private var viewModel = LoginSignUpViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.path){
            ZStack {
                
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [
                        Color(red: 123/255, green: 147/255, blue: 169/255),
                        Color(red: 31/255, green: 72/255, blue: 109/255)
                    ]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                    
                    VStack {
                        Spacer().frame(width: 0, height: 130)
                        
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 361, height: 602)
                            .foregroundColor(Color.white.opacity(0.2))
                    }
                    
                    ScrollView {
                        VStack {
                            Spacer().frame(width: 0, height: 95)
                            
                            Image("icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 160)
                                .foregroundColor(.white)
                            
                            Text("Login Account")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center) // Center-align the text
                                .accessibilityLabel("Login Account Title")
                            
                            Text("Hello, you must login first to be able to use the")
                                .font(.footnote)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 20)
                                .padding(.vertical, -5)
                                .multilineTextAlignment(.center) // Center-align the text
                            
                            Text("application and enjoy all the features.")
                                .font(.footnote)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 20)
                                .multilineTextAlignment(.center) // Center-align the text
                            
                            Spacer()
                        }
                        
                        
                        VStack {
                            HStack {
                                VStack {
                                    HStack {
                                        Image(systemName: "phone.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 13, height: 13)
                                            .foregroundColor(.white)
                                        
                                        Text("Phone Number")
                                            .foregroundColor(.white)
                                            .font(.footnote)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 28)
                                    .padding(.top, 20)
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Picker(selection: $viewModel.selectedCountryCode, label: Text("")) {
                                            ForEach(viewModel.countryCodes, id: \.self) { code in
                                                Text(code)
                                            }
                                        }
                                        .pickerStyle(MenuPickerStyle())
                                        .foregroundColor(.white)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .foregroundColor(Color.white.opacity(0.3))
                                                .frame(width: 83, height: 50)
                                        )
                                        
                                        TextField("Phone Number", text: $viewModel.phoneNumber)
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .foregroundColor(Color.white.opacity(0.3))
                                            )
                                            .foregroundColor(.white)
                                            .font(.footnote)
                                            .frame(width: 260, height: 50)
                                            .keyboardType(.numberPad)
                                            .toolbar {
                                                ToolbarItem(placement: .keyboard) {
                                                    Spacer()
                                                }
                                                ToolbarItem(placement: .keyboard) {
                                                    Button("Done") {
                                                        // Dismiss the keyboard when the "Done" button is tapped
                                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                                    }
                                                    .foregroundColor(.black)
                                                }
                                            }
                                        
                                        Spacer()
                                    }
                                    
                                    Button(action: {
                                        viewModel.signIn()
                                    }) {
                                        Text("Sign In")
                                            .frame(width: 339, height: 50)
                                            .background(Color.white.opacity(0.5))
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 20, weight: .bold, design: .default))
                                            .cornerRadius(10)
                                    }
                                    .padding(.vertical, 15)
                                    
                                    HStack {
                                        Divider()
                                            .frame(width: 140, height: 1)
                                            .overlay(Color.white)
                                        
                                        Text("OR")
                                            .foregroundColor(.white)
                                        Divider()
                                            .frame(width: 140, height: 1)
                                            .overlay(Color.white)
                                    }.padding()
                                    
                                    Button(action: {
                                        viewModel.signInWithApple()
                                    }) {
                                        AppButton(text: "Sign In With Apple",
                                                  image: "applelogo",
                                                  textColor: Color.white,
                                                  bgColor: Color.black)
                                    }
                                    
                                    Button(action: {
                                        viewModel.signInWithGoogle()
                                        
                                        
                                    }) {
                                        HStack {
                                            Image("googleicon")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 10)
                                            Text("Sign In With Google")
                                                .foregroundColor(Color.black)
                                                .font(.system(size: 20, weight: .bold, design: .default))
                                                .cornerRadius(10)
                                                .padding(.horizontal, 10)
                                        }
                                        .frame(width: 339, height: 50)
                                        .background(Color.white.opacity(0.6))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                }
                .ignoresSafeArea()
                .navigationDestination(for: String.self){
                    view in
                    if view == "MainView"{
                        MainView()
                    }
                }
                .onAppear(){
                    if Auth.auth().currentUser != nil{
                        print("Already Logged in")
                        viewModel.path.append("MainView")
                    }
                }
            }
        }
    }
}

struct LoginSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignUpView()
    }
}
