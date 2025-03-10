//
//  ViewModel.swift
//  NewsDiploma
//
//  Created by Alena  on 9.03.25.
//

import SwiftUI

final class ViewModel: ObservableObject, Sendable {
    var items: [ArticleModel] = []
    let apiManager = APIManager()

    
    func loadNews() async {
        do {
            let loadedItems = try await apiManager.sendRequest(
                typeResult: [ArticleModel].self,
                endpoint: .latest(q: nil, category: nil, country: nil)
            )
            DispatchQueue.main.async {
                self.items = loadedItems
            }
        } catch {
            print("Ошибка загрузки новостей: \(error)")
        }
    }
    
    func loadNewsByCategory(category: Category?) async {
        do {
            let loadedItems = try await apiManager.sendRequest(
                typeResult: [ArticleModel].self,
                endpoint: .latest(q: nil, category: category?.rawValue, country: nil)
            )
            DispatchQueue.main.async {
                self.items = loadedItems
            }
        } catch {
            print("Ошибка загрузки по категории: \(error)")
        }
    }

//    func loadDataByKeyWord() async throws -> [ArticleModel] {
//        return try await apiManager.sendRequest(typeResult: [ArticleModel].self, endpoint: .latest(q: "health", category: nil, country: nil))
//    }
//
//    func loadDataByCategory() async throws -> [ArticleModel] {
//        return try await apiManager.sendRequest(typeResult: [ArticleModel].self, endpoint: .latest(q: nil, category: "news", country: nil))
//    }
//    
//    func loadDataByCountry() async throws -> [ArticleModel] {
//        return try await apiManager.sendRequest(typeResult: [ArticleModel].self, endpoint: .latest(q: nil, category: nil, country: "Belarus"))
//    }
}
