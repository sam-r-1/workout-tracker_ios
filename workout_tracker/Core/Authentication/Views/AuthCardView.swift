//
//  AuthCardView.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/12/22.
//

import SwiftUI

struct AuthCardView: View {
    @State private var showResetPasswordView = false
    @State private var showResetRequestedAlert = false
    @State private var authMode = AuthMode.login
    @State private var email = ""
    @State private var password = ""
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            // header view
            AuthHeaderView(logoImage: "lock.shield", line1Text: authMode.headerText)
                .padding(.top)
            
            // email and password fields
            VStack(spacing: 40) {
                CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
                
                CustomInputField(imageName: "lock",
                                 placeholderText: "Password", isSecureField: true, text: $password)
            }
            .padding(.horizontal, 32)
            .padding(.top, 40)
            
            HStack {
                Spacer()
                
                // Reset password link (show only in "login" auth mode)
                switch authMode {
                case .login: Button {
                        showResetPasswordView.toggle()
                    } label: {
                        Text("Forgot Password?")
                            .font(.caption)
                            .foregroundColor(Color(.systemBlue))
                            .fontWeight(.semibold)
                            .padding(.top)
                            .padding(.trailing, 24)
                            .frame(height: 30)
                    }
                        
                // Empty rectangle if auth mode == Sign In
                case .signup: Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 30)
                }
            }
            
            // Sign-in/create account button
            Button {
                switch authMode {
                case .login: viewModel.login(withEmail: email, password: password)
                    
                case .signup: viewModel.register(withEmail: email, password: password)
                }
            } label: {
                Text(authMode.buttonText)
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
                email = ""
                password = ""
            } label: {
                HStack {
                    Text(authMode.toggleText[0])
                        .font(.footnote)
                    
                    Text(authMode.toggleText[1])
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }
            .padding(.bottom, 32)
            .foregroundColor(Color(.systemBlue))
            
        }
        .fullScreenCover(isPresented: $showResetPasswordView, onDismiss: {
            showResetRequestedAlert = true
        }) {
            ResetPasswordView { email in
                viewModel.resetPassword(withEmail: email)
            }
        }
        .alert("An email has been sent with a link to reset your password. Check your spam folder if you cannot find the email at first.", isPresented: $showResetRequestedAlert) {
            Button("Close") { }
        }
    }
}

struct AuthCardView_Previews: PreviewProvider {
    static var previews: some View {
        AuthCardView()
    }
}
