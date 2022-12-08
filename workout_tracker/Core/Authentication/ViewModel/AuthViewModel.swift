//
//  AuthViewModel.swift
//  workout_tracker
//
//  Created by Sam Rankin on 8/12/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

enum AuthMode {
    case login, signup
    
    // The header text
    var headerText: String {
        switch self {
        case .login: return "Login"
        case .signup: return "Create an account"
        }
    }
    
    // The button text
    var buttonText: String {
        switch self {
        case .login: return "Sign In"
        case .signup: return "Sign Up"
        }
    }
    
    // The text to toggle to the other auth mode
    var toggleText: [String] {
        switch self {
        case .login: return ["Don't have an account?", "Sign Up"]
        case .signup: return ["Already have an account?", "Log In"]
        }
    }
    
    mutating func toggle() {
        switch self {
        case .login:
            self = .signup
        case .signup:
            self = .login
        }
    }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser = false
    @Published var currentUser: User?
    
    private let service = UserService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        self.fetchUser()
    }
    
    // Login the user and set the user session
    func login(withEmail email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to login with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            self.fetchUser()
        }
    }
    
    // Register a user with email and password
    func register(withEmail email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            
            let data = ["email": email]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(data) { _ in
                    self.didAuthenticateUser = true
                }
        }
        
    }
    
    func resetPassword(withEmail email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("DEBUG: Failed to send password reset link with error \(error.localizedDescription)")
            }
        }
    }
    
    // Sign the user out locally and on the backend
    func signOut() {
        userSession = nil
        
        try? Auth.auth().signOut()
    }
    
    // Fetch the user
    func fetchUser() {
        guard let uid = self.userSession?.uid else { return }
        
        service.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
}
