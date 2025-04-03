//
//  UserDataModel.swift
//  NewsDiploma
//
//  Created by Alena  on 1.04.25.
//
import SwiftUI
import Firebase
import FirebaseAuth

final class SavedViewModel: ObservableObject {
    @Published var savedArticles: [SavedArticleModel] = []

    func loadSavedArticles() async {
        guard let currentUser = Auth.auth().currentUser else { return }
        do {
            let snapshot = try await Firestore.firestore()
                .collection("users")
                .document(currentUser.uid)
                .collection("bookmarks")
                .getDocuments()
            self.savedArticles = snapshot.documents.compactMap { doc in
                guard let data = doc.data() as? [String: String],
                      let title = data["title"],
                      let description = data["description"],
                      let image = data["imageUrl"] else {
                    return nil
                }
                return SavedArticleModel(title: title, description: description, image: image)
            }
        } catch {
            print("Ошибка загрузки новостей: \(error)")
        }
    }
}
