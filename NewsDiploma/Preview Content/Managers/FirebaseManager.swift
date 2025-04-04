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
    
    
    func registerUser(name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error {
                //дописать уведомление об оштбке
                print("Error: \(error.localizedDescription)")
                completion(false)
            } else {
                if let uid = result?.user.uid {
                    //отсылает письмо на почту для вериыикации
                    result?.user.sendEmailVerification()
                    print(result?.user.uid as Any)
                    
                    Firestore.firestore()
                        .collection("users")
                        .document(uid)
                        .setData([
                            "email": email,
                            "name": name,
                            "age": Date(),
                            "isValid": false
                        ], merge: true) { error in
                            if let error {
                                print("Error saving user data: \(error.localizedDescription)")
                                completion(false)
                            } else {
                                print("Данные пользователя успешно сохранены!")
                                completion(true)
                            }
                        }
                } else {
                    completion(false)
                }

            }

        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error {
                print("Ошибка входа: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Пользователь успешно вошел!")
                completion(true)
            }
        }
    }
    
    func logOut() async {
        do {
            try Auth.auth().signOut()
            print("Пользователь успешно вышел из аккаунта!")
// может дополнительно перейти на экран авторизации??????
        } catch {
            print("Ошибка выхода: \(error.localizedDescription)")
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
