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

    @State private var keyboardOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            
            Image(systemName: "info.circle.fill")
                .font(.title)
                .foregroundStyle(.black)
            
            Text("To save an article for later, please sign in or register for an account.")
                .frame(maxWidth: 300, maxHeight: .infinity)
                .multilineTextAlignment(.center)
//                .padding()
                
            
            TextField("Name", text: $autorizationViewModel.name)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.trailing, 15)
                .padding(.leading, 15)

            
            TextField("Email", text: $autorizationViewModel.email)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .keyboardType(.emailAddress)
                .padding(.trailing, 15)
                .padding(.leading, 15)
            
            TextField("Password", text: $autorizationViewModel.password)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.trailing, 15)
                .padding(.leading, 15)
            
            Button {
                autorizationViewModel.isLoading = true
                autorizationViewModel.firebaseManager.registerUser(name: autorizationViewModel.name, email: autorizationViewModel.email, password: autorizationViewModel.password) { success in
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
                        .background(Color.black)
                        .padding(.trailing, 15)
                        .padding(.leading, 15)                }
            }
            
            
            Button {
                autorizationViewModel.firebaseManager.loginUser(email: autorizationViewModel.email, password: autorizationViewModel.password) { success in
                    if success {
//                        autorizationViewModel.firebaseManager.isUserLoggedIn = true
                        dismiss()
                    } else {
                        autorizationViewModel.alertMessage = "Login error"
                        autorizationViewModel.showAlert = true
                        print("Ошибка входа")
                    }
                }
            } label: {
                Text("Sign in")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                    .cornerRadius(10)
                    .border(Color.black, width: 2)
                    .padding(.trailing, 15)
                    .padding(.leading, 15)
            }
            
            Spacer()
            
            .padding(.horizontal, 20)
            .padding(.bottom, keyboardOffset)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color.gray)
            .alert(autorizationViewModel.alertMessage, isPresented: $autorizationViewModel.showAlert) {
                Button("OK", role: .cancel) {
                    
                }
            }
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                            .foregroundStyle(.red)
                    }
                }
            }
            .onAppear {
                setupKeyboardListeners()
            }
            .onDisappear {
                removeKeyboardListeners()
            }
        }
        
        
        
    }
    
        private func setupKeyboardListeners() {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    keyboardOffset = keyboardFrame.height
                }
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                keyboardOffset = 0
            }
        }

        private func removeKeyboardListeners() {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
}

#Preview {
    NavigationStack {
        AutorizationView()
    }
}
