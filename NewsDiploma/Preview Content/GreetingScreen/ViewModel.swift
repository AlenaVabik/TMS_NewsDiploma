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
    
    private var cancellables: Set<AnyCancellable> = []
         
    var greeting: String {
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        switch currentHour {
        case 5..<12:
            return "Good morning with fresh news"
        case 12..<17:
            return "Good afternoon with fresh news"
        case 17..<24:
            return "Good evening with fresh news"
        default:
            return "Good night with fresh news"
        }
    }
    
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
            let response: APIResponseModel = try await APIManager.sendRequest(
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
                self.items = TestData.modelArray
            } else {
                let response: APIResponseModel = try await APIManager.sendRequest(
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
