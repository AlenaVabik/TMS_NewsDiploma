//
//  AutorisationView.swift
//  NewsDiploma
//
//  Created by Alena  on 1.04.25.
//

import SwiftUI

struct AutorizationView: View {
    @StateObject private var autorizationViewModel = AutorizationViewModel()

    @Environment(\.dismiss) private var dismiss
    


    var body: some View {
        VStack {
            TextField("Name", text: $autorizationViewModel.name)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            TextField("Email", text: $autorizationViewModel.email)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            TextField("Password", text: $autorizationViewModel.password)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            Button {
                autorizationViewModel.isLoading = true
                autorizationViewModel.registerUser { success in
                    autorizationViewModel.isLoading = false
                    if success {
                        dismiss()
                    } else {
                        autorizationViewModel.alertMessage = "Register error"
                        autorizationViewModel.showAlert = true
                        print("Ошибка регистрации")
                    }
                }
            } label: {
                if autorizationViewModel.isLoading {
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
                autorizationViewModel.loginUser { success in
                    if success {
                        dismiss()
                    } else {
                        autorizationViewModel.alertMessage = "Login error"
                        autorizationViewModel.showAlert = true
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
            .alert(autorizationViewModel.alertMessage, isPresented: $autorizationViewModel.showAlert) {
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
