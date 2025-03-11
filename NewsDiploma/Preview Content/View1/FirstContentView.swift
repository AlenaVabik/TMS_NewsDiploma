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
//    @State private var isSheetPresented = false
//    @State private var selectedCategory: Category

    
    var body: some View {
        VStack {
            Label("God morning with fresh news", systemImage: "newspaper")
                .font(.title)
                .padding(.top, 10)


            Picker("Choose the category", selection: $viewModel.selectedCategory) {
                ForEach(Category.allCases, id: \.self) { category in
                    Text(category.rawValue.capitalized)
                }
            }
           .pickerStyle(MenuPickerStyle())

            
            List(viewModel.items, id: \.articleId) { item  in
                ItemCard(item: item)
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
        .background(Color.green)
        .padding()
        .task {
            Task {
                await viewModel.loadNews()
            }
        }
    }

}

#Preview {
    let viewModel = ViewModel()
    FirstContentView(viewModel: viewModel)
}
