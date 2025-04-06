//
//  DetailsViewModel.swift
//  NewsDiploma
//
//  Created by Alena  on 17.03.25.
//
import SwiftUI
import Combine
import Firebase
import FirebaseAuth

final class DetailsViewModel: ObservableObject {
    var item: ArticleModel
    var translatedArticleId: PassthroughSubject<ArticleModel, Never>
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isSourceViewPresented: Bool = false
    @Published var translatedTitle: String?
    @Published var translatedDescription: String?
    @Published var isTranslated: Bool = false
    
    @Published var isAutorisationViewPresented: Bool = false

    @Published var showBlur = false
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private let firebaseManager = FirebaseManager()
    
    init(item: ArticleModel, translatedArticleId: PassthroughSubject<ArticleModel, Never>) {
        self.item = item
        self.translatedArticleId = translatedArticleId
        translatedArticleId
            .sink { [weak self] article in
                self?.item = article
            }
            .store(in: &cancellables)
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
                self.isTranslated = true
            }
        } catch { print("Ошибка перевода: \(error.localizedDescription)") }
    }
    

//    переключатель
    func toggleTranslation() {
        isTranslated.toggle()
    }
    
    func removeOrSaveArticleAction(bookmarkState: BookmarkState, completion: @escaping (BookmarkState) -> Void) {
        Task {
            if firebaseManager.isUserLoggedIn() {
                if bookmarkState == .marked {
                    await firebaseManager.removeArticleFromBookmarks(articleId: item.articleId)
                    await MainActor.run {
                        alertMessage = "Removed from bookmarks"
                        showAlert = true
                        completion(.unmarked)
                    }
                } else {
                    do {
                        try await
                        firebaseManager.saveArticle(article: item)
                        await MainActor.run {
                            alertMessage = "Saved to bookmarks!"
                            showAlert = true
                            completion(.marked)
                        }
                    } catch {
                        await MainActor.run {
                            alertMessage = "Saving error: \(error.localizedDescription)"
                            showAlert = true
                        }
                    }
                }
                //            если она горит то по нажатию удалить из закладок,а если не горит то сохранить
            } else {
                await MainActor.run {
                    isAutorisationViewPresented = true
                }
            }
        }
    }

    func checkBookmarkAction(bookmarkState: BookmarkState, completion: @escaping (BookmarkState) -> Void) {
        Task {
            if await firebaseManager.checkArticleInSavedBookmarks(articleId: item.articleId) {
                completion(.marked)
                print("Статья уже сохранена в закладках.")
            } else {
                completion(.unmarked)
                print("Статья не найдена в закладках.")
            }
        }
    }
}



