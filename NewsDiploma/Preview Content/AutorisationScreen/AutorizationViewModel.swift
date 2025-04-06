//
//  UserDataModel.swift
//  NewsDiploma
//
//  Created by Alena  on 1.04.25.
//

import SwiftUI

final class AutorizationViewModel: ObservableObject {
    private var firebaseManager = FirebaseManager()

    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    
    @Published var showAlert = false
    var alertMessage = ""
    @Published var isLoading = false

    func registerUserAction(dismiss: @escaping () -> Void) {
        Task {
            do {
                try await firebaseManager.registerUser(
                    name: name,
                    email: email,
                    password: password)
                await MainActor.run {
                    isLoading = false
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    showAlert = true
                    alertMessage = "Register error: \(error.localizedDescription)"
                }
                print("Ошибка регистрации")
            }
        }
    }
    
    func loginUserAction(dismiss: @escaping () -> Void) {
        Task {
            do {
                try await firebaseManager.loginUser(
                    email: email,
                    password: password)
                await MainActor.run {
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    alertMessage = "Login error"
                    showAlert = true
                }
                print("Ошибка входа")
            }
        }
    }
}



