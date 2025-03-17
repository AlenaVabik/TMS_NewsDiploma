//
//  DetailsNewsView.swift
//  NewsDiploma
//
//  Created by Alena  on 13.03.25.
//

import SwiftUI
import Kingfisher

struct DetailsNewsView: View {
    @StateObject var detailsViewModel: DetailsViewModel
    
    
    let item: ArticleModel
    
    var body: some View {
  
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(item.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                if let imageUrl = item.imageUrl {
                    KFImage(URL(string: imageUrl))
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                }
                
                if let description = item.description {
                    Text(description)
                } else {
                    Text("No description")
                }
                
                Button(action: {
                    detailsViewModel.isfullScreenPresented = true
                    
                    print("Кнопка 'Source information' нажата.")
                }) {
                    Text("Source information")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .fullScreenCover(isPresented: $detailsViewModel.isfullScreenPresented) {
                NavigationStack {
                    SourceView(sourceViewModel: detailsViewModel.sourceViewModel)
                }
            }
//            .sheet(isPresented: $viewModel.isSourceViewPresented) {
//                NavigationStack {
//                    SourceView(sourceName: item.sourceName, sourceUrl: item.sourceUrl, sourceIcon: item.sourceIcon, pubDate: item.pubDate)
//                }
//            }
            .padding(.horizontal)
        }
        .navigationTitle("Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Логика перевода
                    print("Кнопка перевода нажата")
                }) {
                    Image(systemName: "translate")
                        .font(.title2)
                        .foregroundColor(.red)
                }
            }
        }
    }
}



#Preview {
    let viewModel = DetailsViewModel()
    
    NavigationStack {
        if ProcessInfo.isPreviewMode {
            viewModel.items = TestData.modelArray
        }
    return DetailsNewsView(detailsViewModel: viewModel, item: viewModel.items.first!)
    }
    
}
