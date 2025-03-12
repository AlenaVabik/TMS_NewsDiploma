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
     
    let testData = TestData()
    
    init() {
        $selectedCategory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] category in
                guard let self else { return }
                Task {
                    switch category {
                    case .allCategories:
                        await self.loadNews()
                    default:
                        await self.loadNewsByCategory(category: category)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func loadNews() async {
        guard !ProcessInfo.isPreviewMode else { return }
        do {
            let response: APIResponseModel = try await apiManager.sendRequest(
                typeResult: APIResponseModel.self,
                endpoint: .latest(q: nil, category: nil, country: nil)
            )
            await MainActor.run {
                self.items = response.results
            }
        } catch {
            print("Ошибка загрузки новостей: \(error)")
        }
    }

    
    func loadNewsByCategory(category: Category?) async {
        do {
            if ProcessInfo.isPreviewMode {
                self.items = testData.modelArray
            } else {
                let response: APIResponseModel = try await apiManager.sendRequest(
                    typeResult: APIResponseModel.self,
                    endpoint: .latest(q: nil, category: category?.rawValue, country: nil)
                )
                await MainActor.run {
                    self.items = response.results
                }
            }
        } catch {
            print("Ошибка загрузки по категории: \(error)")
        }
    }

}
