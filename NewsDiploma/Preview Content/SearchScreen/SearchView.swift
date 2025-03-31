//
//  Search.swift
//  NewsDiploma
//
//  Created by Alena  on 12.03.25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var searchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            List(searchViewModel.items, id: \.articleId) { item in
                NavigationLink(
                    destination: DetailsNewsView(
                        detailsViewModel: DetailsViewModel(
                            item: item,
                            translatedArticleId: searchViewModel.translatedArticleId
                        ),
                        item: item
                    )
                ) {
                    ItemScreenCard(item: item)
                }
            }
            
            .scrollContentBackground(.hidden)
            .background(Color.brown.opacity(0.5))
            .navigationTitle("Search by key word")
            .searchable(text: $searchViewModel.keyWord, prompt: "Search for articles")
            .onChange(of: searchViewModel.keyWord) { oldValue, newValue in
                Task {
                    await searchViewModel.loadNews(q: newValue)
                }
            }
        }
    }
    
}

#Preview {
    if ProcessInfo.isPreviewMode {
        ItemScreenCard(item: TestData.articleModel)
    }
    SearchView()
}
