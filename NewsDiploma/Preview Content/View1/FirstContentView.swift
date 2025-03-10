//
//  ContentView.swift
//  NewsDiploma
//
//  Created by Alena  on 5.03.25.
//

import SwiftUI

enum Category: String, CaseIterable {
    case business, education, sports, tourism, world
}

struct FirstContentView: View {
    @StateObject var viewModel: ViewModel
    @State private var isSheetPresented = false
    @State private var selectedCategory: Category? = nil

    
    var body: some View {
        VStack {
            Label("God morning with fresh news", systemImage: "newspaper")
                .font(.title)
                .padding(.top, 10)
            
            Picker("Choose the category", selection: $selectedCategory) {
                Text("All categories").tag(Category?.none)
                ForEach(Category.allCases, id: \.self) { category in
                    Text(category.rawValue.capitalized).tag(category as Category?)
                }
            }
           .pickerStyle(MenuPickerStyle())
           .onChange(of: selectedCategory) { oldValue, newValue in
               Task {
                   if let category = newValue {
                       await viewModel.loadNewsByCategory(category: category)
                   } else {
                       await viewModel.loadNews()
                   }
               }
           }

            
            
            List {
                ForEach(viewModel.items, id: \.articleId) { item in
                    ItemCard(item: item)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.secondary)

            Button("Push button") {
                isSheetPresented = true
            }
            .padding(5)
            .sheet(isPresented: $isSheetPresented) {
                SecondContentView()
            }
        }
        .background(Color.green)
        .padding()
        .onAppear {
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
