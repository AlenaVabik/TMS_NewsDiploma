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
                .font(.custom("AvenirNext-Bold", size: 20))
                .padding(.top, 10)
            
            Text(DateFormatter.firstScreenDateFormatter.string(from: Date()))
                 .font(.caption)
                 .foregroundColor(.white)
            
            TabView(selection: $viewModel.selectedCategory) {
                ForEach(Category.allCases, id: \.self) { category in
                    VStack {
                        Text(category.rawValue.capitalized)
                            .font(.headline)
                            .padding()
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
                        
                        .scrollContentBackground(.hidden)
//                        .foregroundStyle(.secondary)
                        .background(Color.black)
                    }
                    .tag(category)
                }
           }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))

//            Button("Push button") {
//                viewModel.isSheetPresented = true
//            }
//            .padding(5)
//            .sheet(isPresented: $viewModel.isSheetPresented) {
//                SecondContentView()
//            }
        }
        .background(Color.red)
        .padding()
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
