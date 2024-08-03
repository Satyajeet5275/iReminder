import SwiftUI

struct MainView: View {
    var body: some View {
//        WindowGroup {
            ZStack {
//                GeometryReader { proxy in
//                    Color.clear.onAppear {
//                        safeAreaInsets = (proxy.safeAreaInsets.top, proxy.safeAreaInsets.bottom)
//                    }
//                }
                
                ContentView()
                Spacer()
//                    .environment(\.safeAreaInsets, safeAreaInsets)
            }
        }
//        VStack {
//            TabView {
//                TodoListView()
//                    .tabItem { VStack {
//                        Image(systemName: "house").font(.largeTitle)
//                        Text("Home").font(.headline)
//                    } }
//
//                ProfileView()
//                    .tabItem { VStack {
//                        Image(systemName: "person").font(.largeTitle)
//                        Text("Profile").font(.headline)
//                    } }
//            }
//        }
//
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
