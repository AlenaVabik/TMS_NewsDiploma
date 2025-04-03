//
//  UserDataModel.swift
//  NewsDiploma
//
//  Created by Alena  on 1.04.25.
//

import SwiftUI

final class AutorizationViewModel: ObservableObject {
    @StateObject private var firebaseManager = FirebaseManager()

    @State var name = ""
    @State var email = ""
    @State var password = ""
    
    @State var showAlert = false
    @State var alertMessage = ""
    @State var isLoading = false
    
    func registerUser(completion: @escaping (Bool) -> Void) {
        firebaseManager.registerUser(name: name, email: email, password: password, completion: completion)
    }
        
    func loginUser(completion: @escaping (Bool) -> Void) {
        firebaseManager.loginUser(email: email, password: password, completion: completion)
    }
}

