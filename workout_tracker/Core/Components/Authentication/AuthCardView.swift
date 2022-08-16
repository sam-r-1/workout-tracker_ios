//
//  AuthCardView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/12/22.
//

import SwiftUI

struct AuthCardView: View {
    @State private var authMode = AuthMode.login
    @State private var email = ""
    @State private var password = ""
    let headerText: String
    @State var isLogin: Bool
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            // header view
            AuthHeaderView(logoImage: "bell", line1Text: headerText)
                .padding(.top)
            
            // email and password fields
            VStack(spacing: 40) {
                CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
                
                CustomInputField(imageName: "lock",
                                 placeholderText: "Password", isSecureField: true, text: $password)
            }
            .padding(.horizontal, 32)
            .padding(.top, 44)
            
            HStack {
                Spacer()
                
                // Reset password link
                NavigationLink {
                    Text("Reset Password View")
                } label: {
                    Text("Forgot Password?")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.systemBlue))
                        .padding(.top)
                        .padding(.trailing, 24)
                }
            }
            
            // Sign-in button
            Button {
                 viewModel.login(withEmail: email, password: password)
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 250, height: 50)
                    .background(Color(.systemBlue))
                    .clipShape(Capsule())
                    .padding()
            }
            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
            
            // Empty box for custom spacing
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 30)
            
            // Link to RegistrationView if the user doesn't have an account
            Button {
                authMode.toggle()
            } label: {
                HStack {
                    Text("Don't have an account?")
                        .font(.footnote)
                    
                    Text("Sign Up")
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }
            .padding(.bottom, 32)
            .foregroundColor(Color(.systemBlue))
            
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 50))
    }
}

//struct AuthCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthCardView()
//    }
//}
