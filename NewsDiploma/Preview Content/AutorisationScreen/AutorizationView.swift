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
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack {
            
            Image(systemName: "info.circle.fill")
                .font(.title)
                .foregroundStyle(.black)
            
            Text("To save an article for later, please sign in or register for an account.")
                .frame(maxWidth: 300, maxHeight: .infinity)
                .multilineTextAlignment(.center)
                
            
            TextField("Name", text: $autorizationViewModel.name)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.trailing, 15)
                .padding(.leading, 15)
                .focused($isTextFieldFocused)
            
            TextField("Email", text: $autorizationViewModel.email)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .keyboardType(.emailAddress)
                .padding(.trailing, 15)
                .padding(.leading, 15)
                .focused($isTextFieldFocused)
            
            TextField("Password", text: $autorizationViewModel.password)
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.trailing, 15)
                .padding(.leading, 15)
                .focused($isTextFieldFocused)
            
            Button {
                autorizationViewModel.isLoading = true
                autorizationViewModel.registerUserAction { dismiss() }

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
                        .padding(.leading, 15)
                }
            }
            
            
            Button {
                autorizationViewModel.loginUserAction { dismiss() }

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
            
            
            .padding(.horizontal, 20)
            .padding(.bottom, keyboardOffset)
            .onChange(of: isTextFieldFocused) {
                withAnimation {
                    keyboardOffset = isTextFieldFocused ? 300 : 0
                }
            }
            .animation(.easeInOut, value: keyboardOffset)
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
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
        }
        
        
        
    }
}

#Preview {
    NavigationStack {
        AutorizationView()
    }
}
