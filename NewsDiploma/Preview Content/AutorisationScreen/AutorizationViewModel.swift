//
//  UserDataModel.swift
//  NewsDiploma
//
//  Created by Alena  on 1.04.25.
//

import SwiftUI

final class AutorizationViewModel: ObservableObject {
    @Published var firebaseManager = FirebaseManager()

    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    
    var showAlert = false
    var alertMessage = ""
    @Published var isLoading = false
}

