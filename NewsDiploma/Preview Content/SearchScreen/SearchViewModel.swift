//
//  SearchViewModel.swift
//  NewsDiploma
//
//  Created by Alena  on 23.03.25.
//

import SwiftUI
import Combine

final class SearchViewModel: ObservableObject {
    @Published var items: [ArticleModel] = []
    @Published var keyWord: String = ""
    var translatedArticleId = PassthroughSubject<ArticleModel, Never>()
    
    
    func loadNews(q: String) async {

        guard !ProcessInfo.isPreviewMode else { return }
        do {
            let response: APIResponseModel = try await APIManager.sendRequest(
                typeResult: APIResponseModel.self,
                endpoint: .latest(q: keyWord, category: nil, country: nil)
            )
            await MainActor.run {
                self.items = response.results
            }
        } catch {
            print("Ошибка загрузки новостей: \(error)")
        }
    }
}
