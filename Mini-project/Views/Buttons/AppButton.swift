//
//  AppButton.swift
//  Mini-project
//
//  Created by Mini Project on 10/02/24.
//

import SwiftUI


struct AppButton: View {
    
   
    let text: String
    let image: String
    let textColor: Color
    let bgColor: Color
    
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .resizable() // Make the image resizable
                .scaledToFit() // Scale the image to fit the available space
                .frame(width: 30, height: 30) // Set your desired image size
                .foregroundColor(.white)
                .padding(.horizontal, 10)
            Text(text)
                .foregroundColor(textColor)
                .font(.system(size: 20, weight: .bold, design: .default))
                .cornerRadius(10)
                .padding(.horizontal, 10)
        }
        .frame(width: 339, height: 50)
        .background(bgColor)
        .cornerRadius(8)
    }
}

#Preview {
    AppButton(text: "test", image: "applelogo", textColor: Color.white, bgColor: Color.black)
}
