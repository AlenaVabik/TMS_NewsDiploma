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
    case allCategories, business, education, sports, tourism, world
}

struct FirstContentView: View {
    @StateObject var viewModel: ViewModel
    

    var body: some View {
        VStack {
            Label(viewModel.greeting, systemImage: "newspaper")
                .font(.custom("AvenirNext-Bold", size: 20))
                .padding(.top, 10)

            SearchView()
            
            Picker("Choose the category", selection: $viewModel.selectedCategory) {
                ForEach(Category.allCases, id: \.self) { category in
                    Text(category.rawValue.capitalized)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .background(Color.orange)
           
            
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
            .background(Color.secondary)

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
//    let viewModel = ViewModel()
//    
//    NavigationStack {
//        if ProcessInfo.isPreviewMode {
//            viewModel.items = TestData.modelArray
//        }
//         return FirstContentView(viewModel: viewModel)
//    }
//    
}
