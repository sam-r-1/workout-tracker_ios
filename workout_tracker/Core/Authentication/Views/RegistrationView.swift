//
//  RegistrationView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/12/22.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Spacer()
           
            // Registration Card
            VStack {
                // header view
                AuthHeaderView(logoImage: "bell", line1Text: "Create an account")
                
                // input fields
                VStack(spacing: 40) {
                    CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
                    
                    CustomInputField(imageName: "lock", placeholderText: "Password", isSecureField: true, text: $password)
                }
                .padding(32)
                
                Button {
                     viewModel.register(withEmail: email, password: password)
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 250, height: 50)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 30)
                
                Button {
                    
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    HStack {
                        Text("Already have an account?")
                            .font(.footnote)
                        
                        Text("Login")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom, 32)
                .foregroundColor(Color(.systemBlue))
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 50))
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .background(Color(.systemGray2))
        .navigationBarHidden(true)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}

