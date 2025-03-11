//
//  ViewModel.swift
//  NewsDiploma
//
//  Created by Alena  on 9.03.25.
//

import SwiftUI
import Combine

final class ViewModel: ObservableObject, Sendable {
    @Published var items: [ArticleModel] = []
    @Published var selectedCategory: Category = .allCategories
    @Published var isSheetPresented: Bool = false
    
    let apiManager = APIManager()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        $selectedCategory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] category in
                guard let self = self else { return }
                Task {
                    if category == .allCategories {
                        await self.loadNews()
                    } else {
                        await self.loadNewsByCategory(category: category)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func loadNews() async {
        do {
            let loadedItems = try await apiManager.sendRequest(
                typeResult: [ArticleModel].self,
                endpoint: .latest(q: nil, category: nil, country: nil)
            )
            await MainActor.run {
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
            await MainActor.run {
                self.items = loadedItems
            }
        } catch {
            print("Ошибка загрузки по категории: \(error)")
        }
    }
}
