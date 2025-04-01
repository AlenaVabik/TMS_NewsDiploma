//
//  FirebaseManager.swift
//  NewsDiploma
//
//  Created by Alena  on 1.04.25.
//

import Foundation
import Firebase
import FirebaseAuth

class FirebaseManager {
    
    
    func registerUser(userData: UserData) {
        
        Auth.auth().createUser(withEmail: userData.email, password: userData.password) { result, error in
            
            if let error {
//дописать уведомление об оштбке
                print("Error: \(error.localizedDescription)")
                return
            }
//отсылает письмо на почту для вериыикации
            result?.user.sendEmailVerification()
            print(result?.user.uid)
            print("User registered successfully!")
            
            if let uid = result?.user.uid {
                Firestore.firestore()
                    .collection("users")
                    .document(uid)
                    .setData([
                    "email": userData.email,
                    "name": userData.name,
                    "age": Date(),
                    "isValid": false
                    ], merge: true) { error in
                        if let error = error {
                            print("Error saving user data: \(error.localizedDescription)")
                        }
                    }
            }
            
        }
    }
}
