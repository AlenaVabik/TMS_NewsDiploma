//
//  AutorisationView.swift
//  NewsDiploma
//
//  Created by Alena  on 1.04.25.
//

import SwiftUI

struct AutorizationView: View {
    @State var name = ""
    @State var email = ""
    @State var password = ""
    let firebaseManager = FirebaseManager()
    @Environment(\.dismiss) private var dismiss
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
//    @StateObject private var detailsViewModel: DetailsViewModel
    @State var isUserLoggedIn = FirebaseManager().isUserLoggedIn()

    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            TextField("Email", text: $email)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            TextField("Password", text: $password)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            Button {
                isLoading = true
                firebaseManager.registerUser(name: name, email: email, password: password) { success in
                    isLoading = false
                    if success {
                        dismiss()
                    } else {
                        alertMessage = "Register error"
                        showAlert = true
                        print("Ошибка регистрации")
                    }
                }
            } label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Register")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            
            
            Button {
                firebaseManager.loginUser(email: email, password: password) { success in
                    if success {
                        isUserLoggedIn = true
                        dismiss()
                    } else {
                        alertMessage = "Login error"
                        showAlert = true
                        print("Ошибка входа")
                    }
                }
            } label: {
                Text("Login")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            .padding(.horizontal, 20)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray)
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                    
                }
            }
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.black.opacity(0.5))
                    }
                }
            }
        }
        
        
        
    }
}

#Preview {
    NavigationStack {
        AutorizationView()
    }
}
