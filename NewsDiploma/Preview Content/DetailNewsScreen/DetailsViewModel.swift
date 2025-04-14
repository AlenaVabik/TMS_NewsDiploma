//
//  DetailsViewModel.swift
//  NewsDiploma
//
//  Created by Alena  on 17.03.25.
//
import SwiftUI
import Firebase
import FirebaseAuth

final class DetailsViewModel: ObservableObject {
    var item: ArticleModel

    
    @Published var isSourceViewPresented: Bool = false
    
    var translatedTitle: String?
    var translatedDescription: String?
    var isTranslated: Bool = false

    @Published var showTranslation: Bool = false
    
    @Published var isAutorisationViewPresented: Bool = false

    @Published var showBlur = false
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private let firebaseManager = FirebaseManager()
    
    
    init(item: ArticleModel) {
        self.item = item
    }
    
    private func translateText(_ text: String) async throws -> String? {
        let response: YandexTranslateResponse = try await APIManager.sendRequest(
            typeResult: YandexTranslateResponse.self,
            endpoint: .translate(texts: [text], targetLanguageCode: "ru", sourceLanguageCode: "en")
        )
        return response.translations.first?.text
    }
    
    func translateContent() async {
        guard !ProcessInfo.isPreviewMode else { return }
        guard !self.isTranslated else {
            await MainActor.run {
                self.showTranslation = true
            }
            return
        }
        do {
            let translatedTitle = try await translateText(item.title)
            
            if let descriptionText = item.description, !descriptionText.isEmpty {
                let translatedDescription = try await translateText(descriptionText)
                await MainActor.run {
                    self.translatedDescription = translatedDescription
                }
            } else {
                await MainActor.run {
                    self.translatedDescription = "Нет описания для перевода"
                }
            }
            
            await MainActor.run {
                self.translatedTitle = translatedTitle
                self.showTranslation = true
                self.isTranslated = true
            }
        } catch { print("Ошибка перевода: \(error.localizedDescription)") }
    }
    

//    переключатель
    func toggleTranslation() {
        showTranslation.toggle()
    }
    
    func removeOrSaveArticleAction(currentState: BookmarkState) async -> BookmarkState {
        if firebaseManager.isUserLoggedIn() {
            if currentState == .marked {
                await firebaseManager.removeArticleFromBookmarks(articleId: item.articleId)
                await MainActor.run {
                    alertMessage = "Removed from bookmarks"
                    showAlert = true
                }
                return .unmarked
            } else {
                do {
                    try await
                    firebaseManager.saveArticle(article: item)
                    await MainActor.run {
                        alertMessage = "Saved to bookmarks!"
                        showAlert = true
                    }
                    return .marked
                } catch {
                    await MainActor.run {
                        alertMessage = "Saving error: \(error.localizedDescription)"
                        showAlert = true
                    }
                    return currentState
                }
            }
            //            если она горит то по нажатию удалить из закладок,а если не горит то сохранить
        } else {
            await MainActor.run {
                isAutorisationViewPresented = true
            }
            return currentState
        }
    }


    func checkBookmarkAction() async -> BookmarkState {
        let isBookmarked = await firebaseManager.checkArticleInSavedBookmarks(articleId: item.articleId)
        
        if isBookmarked {
            print("Статья уже сохранена в закладках.")
            return .marked
        } else {
            print("Статья не найдена в закладках.")
            return .unmarked
        }
    }


}



