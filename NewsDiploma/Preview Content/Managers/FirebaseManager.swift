//
//  FirebaseManager.swift
//  NewsDiploma
//
//  Created by Alena  on 1.04.25.
//

import Foundation
import Firebase
import FirebaseAuth

final class FirebaseManager: ObservableObject {
    
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    
    func registerUser(name: String, email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = result.user.uid
            
            try await result.user.sendEmailVerification()
            print("UID пользователя: \(uid)")
            
            let userData: [String: Any] = [
                "email": email,
                "name": name,
                "age": Date(),
                "isValid": false ]
            
            try await Firestore.firestore()
                .collection("users")
                .document(uid)
                .setData(userData, merge: true)
            print("Данные пользователя успешно сохранены!")
        } catch {
            print("Error: \(error.localizedDescription)")
            throw error
        }
    }
    
//    func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            if let error {
//                print("Ошибка входа: \(error.localizedDescription)")
//                completion(false)
//            } else {
//                print("Пользователь успешно вошел!")
//                completion(true)
//            }
//        }
//    }
    
    func loginUser(email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            print("Пользователь успешно вошел!")
        } catch {
            print("Ошибка входа: \(error.localizedDescription)")
            throw error
        }
    }
    
    func logOut() async throws {
        do {
            try Auth.auth().signOut()
            print("Пользователь успешно вышел из аккаунта!")
        } catch {
            print("Ошибка выхода: \(error.localizedDescription)")
            throw error
        }
    }


    func removeArticleFromBookmarks(articleId: String) async {
        guard let currentUser = Auth.auth().currentUser else {
            print("Пользователь не авторизован,статья не может быть удалена")
            return
        }
        do {
            try await Firestore.firestore()
                .collection("users")
                .document(currentUser.uid)
                .collection("bookmarks")
                .document(articleId)
                .delete()
            print("Статья успешно удалена из закладок!")
        } catch {
            print("ошибка \(error.localizedDescription)")
        }
    }

}
