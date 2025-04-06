//
//  ContentView.swift
//  NewsDiploma
//
//  Created by Alena  on 5.03.25.
//

import SwiftUI
import Kingfisher
import Combine

enum Category: String, CaseIterable {
    case allCategories
    case business
    case education
    case sports
    case tourism
    case world
}

struct FirstContentView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack {
            Label(viewModel.greeting, systemImage: "newspaper")
                .font(.title2)
                .padding(.top, 10)
            
            Text(DateFormatter.firstScreenDateFormatter.string(from: Date()))
                .font(.callout)
                .foregroundColor(.black.opacity(0.5))
            
            TabView(selection: $viewModel.selectedCategory) {
                ForEach(Category.allCases, id: \.self) { category in
                    VStack {
                        Text(category.rawValue.capitalized)
                            .font(.headline)
                            .frame(maxWidth: .infinity, maxHeight: 27)
                            .border(Color.black, width: 1)

                        Divider()
                        List(viewModel.items, id: \.articleId) { item in
                            NavigationLink(
                                destination: DetailsNewsView(
                                    detailsViewModel: DetailsViewModel(
                                        item: item,
                                        translatedArticleId: viewModel.translatedArticleId
                                    ),
                                    item: item
                                )
                            ) {
                                ItemCard(item: item)
                            }
                        }
                        
                        .scrollContentBackground(.visible)
                    }
                    .tag(category)
                }
           }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .background(Color.white)
        .task {
            await viewModel.loadNews()
        }
    }

}

#Preview {
    FirstContentView()
//    let viewModel = ViewModel()
//    
//    NavigationStack {
//        if ProcessInfo.isPreviewMode {
//            viewModel.items = TestData.modelArray
//        }
//         return FirstContentView(viewModel: viewModel)
//    }
    
}
