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
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search", text: $searchViewModel.keyWord)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(8)
                    .background(Color.white.opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .autocapitalization(.none)
                    .onSubmit {
                       Task {
                           await searchViewModel.loadNews(q: searchViewModel.keyWord)
                       }
            }
                
            }
        }
        .padding(5)
        
        List(searchViewModel.items, id: \.articleId) { item in
                ItemScreenCard(item: item)
        }
        
        .scrollContentBackground(.hidden)
        .background(Color.brown.opacity(0.5))
    }
    
}

#Preview {
    if ProcessInfo.isPreviewMode {
        ItemScreenCard(item: TestData.articleModel)
    }
    SearchView()
}
