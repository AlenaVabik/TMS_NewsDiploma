//
//  DetailsViewModel.swift
//  NewsDiploma
//
//  Created by Alena  on 17.03.25.
//
import SwiftUI
import Combine

final class DetailsViewModel: ObservableObject {
    let sourceViewModel = SourceViewModel()
    var item: ArticleModel
    var translatedArticleId: PassthroughSubject<ArticleModel, Never>
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isfullScreenPresented: Bool = false
    @Published var translatedTitle: String?
    @Published var translatedDescription: String?
    @Published var isTranslated: Bool = false
    
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
        } catch let error as NSError {
            print("Ошибка перевода: \(error.localizedDescription) (\(error.code))")
        } catch {
            print("Непредвиденная ошибка перевода: \(error)")
        }
    }
    

//    переключатель
    func toggleTranslation() {
        isTranslated.toggle()
    }
}



