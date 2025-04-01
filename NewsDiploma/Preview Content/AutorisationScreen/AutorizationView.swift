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
//    @State var isLoggedIn: Bool = false
    let firebaseManager = FirebaseManager()
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .padding(10)
                .background()
                .cornerRadius(10)
            
            TextField("Email", text: $email)
                .padding(10)
                .background()
                .cornerRadius(10)
            
            TextField("Password", text: $password)
                .padding(10)
                .background()
                .cornerRadius(10)

            Button {
                firebaseManager.registerUser(userData: UserData(name: name, email: email, password: password))
            } label: {
                Text("Register")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(Color.green)
                    .cornerRadius(10)

            }

        }
        .padding(.horizontal, 20)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray)
    }
}

#Preview {
    AutorizationView()
}
