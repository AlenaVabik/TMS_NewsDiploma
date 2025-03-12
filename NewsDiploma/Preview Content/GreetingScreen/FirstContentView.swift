//
//  ContentView.swift
//  NewsDiploma
//
//  Created by Alena  on 5.03.25.
//

import SwiftUI

enum Category: String, CaseIterable {
    case allCategories, business, education, sports, tourism, world
}

struct FirstContentView: View {
    @StateObject var viewModel: ViewModel
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
    
    var body: some View {
        VStack {
            Label(greeting, systemImage: "newspaper")
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
            
           
            
            List(viewModel.items, id: \.articleId) { item  in
                NavigationLink(
                    destination: DetailsNewsView(
                        title: item.title,
                        description: item.description ?? "No description",
                        imageUrl: item.imageUrl
                    )
                ) {
                    ItemCard(item: item)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.secondary)

            Button("Push button") {
                viewModel.isSheetPresented = true
            }
            .padding(5)
            .sheet(isPresented: $viewModel.isSheetPresented) {
                SecondContentView()
            }
        }
        .background(Color.red)
        .padding()
        .task {
            await viewModel.loadNews()
        }
    }

}

#Preview {
    let viewModel = ViewModel()
    let testData = TestData()
    
    NavigationStack {
        if ProcessInfo.isPreviewMode {
            viewModel.items = testData.modelArray
        }
         return FirstContentView(viewModel: viewModel)
    }
    
}
