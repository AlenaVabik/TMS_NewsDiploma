//
//  ViewModel.swift
//  NewsDiploma
//
//  Created by Alena  on 9.03.25.
//

import SwiftUI
import Combine

final class ViewModel: ObservableObject {
    @Published var items: [ArticleModel] = []
    @Published var selectedCategory: Category = .allCategories
    @Published var isSourceViewPresented: Bool = false
    @Published var isLoading: Bool = true
    @Published var detVM: DetailsViewModel
    
    @Published var shouldReload: Bool = true

//экземпляр
    var translatedArticleId = PassthroughSubject<ArticleModel, Never>()
    
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
        let placeholderItem = ArticleModel(
            articleId: "placeholder",
            title: "Placeholder Title",
            link: "https://example.com",
            description: "Placeholder description",
            pubDate: Date(),
            pubDateTZ: "GMT",
            sourceId: "source_placeholder",
            sourcePriority: 1,
            sourceName: "Placeholder Source",
            sourceUrl: "https://example.com",
            sourceIcon: "https://example.com/icon.png",
            language: "en",
            country: ["US"],
            category: ["General"],
            translatedDescription: "",
            translatedTitle: ""
        )
        let placeholderSubject = PassthroughSubject<ArticleModel, Never>()
        self.detVM = DetailsViewModel(item: placeholderItem, translatedArticleId: placeholderSubject)
        
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
        guard shouldReload else { return }
        shouldReload = false
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
