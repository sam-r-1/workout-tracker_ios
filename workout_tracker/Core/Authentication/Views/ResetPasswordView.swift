//
//  ResetPasswordView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 12/8/22.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    let onResetRequested: (String) -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Spacer()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Close")
                }
            }
            
            Spacer()
            
            Text("Enter the email address associated with your account to reset your password.")
                .fontWeight(.semibold)
            
            CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
            
            Button {
                onResetRequested(email)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Send Reset Link")
            }
            .disabled(email.isEmpty)
            .buttonStyle(.bordered)

            Spacer()
        }
        .padding(.horizontal)
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView { email in
            print("DEBUG: \(email)")
        }
    }
}
