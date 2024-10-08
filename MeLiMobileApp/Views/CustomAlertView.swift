//
//  CustomAlertView.swift
//  MeLiMobileApp
//
//  Created by David Andres Mejia Lopez on 8/10/24.
//

import SwiftUI

struct CustomAlertView: View {
    var title: String
    var message: String
    var buttonTitle: String
    var buttonAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundStyle(.yellow)
            
            Text(title)
                .font(.headline)
                .foregroundStyle(.black)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .lineLimit(3)
                .multilineTextAlignment(.center)
            
            Button(action: buttonAction) {
                Text(buttonTitle)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .frame(maxWidth: 300)
    }
}
