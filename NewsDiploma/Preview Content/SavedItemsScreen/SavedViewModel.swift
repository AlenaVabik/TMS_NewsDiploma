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
    @Published var savedArticles: [ArticleModel] = []
    private let firebaseManager = FirebaseManager()
    @Published var showAlert = false
    var alertMessage = ""

    func loadSavedArticles() async {
        guard let currentUser = Auth.auth().currentUser else { return }
        do {
            let snapshot = try await Firestore.firestore()
                .collection("users")
                .document(currentUser.uid)
                .collection("bookmarks")
                .getDocuments()
            await MainActor.run {
                self.savedArticles = snapshot.documents.compactMap { (doc: QueryDocumentSnapshot) -> ArticleModel? in
                    let data = doc.data()
                    guard let title = data["title"] as? String,
                          let articleId = data["articleId"] as? String,
                          let link = data["link"] as? String,
                          let sourceId = data["sourceId"] as? String,
                          let sourcePriority = data["sourcePriority"] as? Int,
                          let sourceName = data["sourceName"] as? String,
                          let sourceUrl = data["sourceUrl"] as? String,
                          let sourceIcon = data["sourceIcon"] as? String
//                          let translatedDescription = data["translatedDescription"] as? String,
//                          let translatedTitle = data["translatedTitle"] as? String
                    else {
                        return nil
                    }
                    return ArticleModel(
                        articleId: articleId,
                        title: title,
                        link: link,
                        keywords: data["keywords"] as? [String],
                        creator: data["creator"] as? [String],
                        videoUrl: data["videoUrl"] as? String,
                        description: data["description"] as? String,
                        content: data["content"] as? String,
                        pubDate: data["pubDate"] as? Date ?? Date() ,
                        pubDateTZ: data["pubDateTZ"] as? String ?? "",
                        imageUrl: data["imageUrl"] as? String,
                        sourceId: sourceId,
                        sourcePriority: sourcePriority,
                        sourceName: sourceName,
                        sourceUrl: sourceUrl,
                        sourceIcon: sourceIcon,
                        language: data["language"] as? String ?? "",
                        country: data["country"] as? [String] ?? [],
                        category: data["category"] as? [String] ?? []
                    )
                }
            }
        } catch {
            print("Ошибка загрузки новостей: \(error)")
        }
    }
    
    
    func logOutAction() {
        Task {
            do {
                try await firebaseManager.logOut()
                await MainActor.run {
                    alertMessage = "You logged out!"
                    showAlert = true
                }
            } catch {
                await MainActor.run {
                    alertMessage = "Error: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
}
