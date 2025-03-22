//
//  DetailsNewsView.swift
//  NewsDiploma
//
//  Created by Alena  on 13.03.25.
//

import SwiftUI
import Kingfisher
import Combine

struct DetailsNewsView: View {
    @StateObject private var detailsViewModel: DetailsViewModel
    let item: ArticleModel
    
    init(detailsViewModel: DetailsViewModel, item: ArticleModel) {
        _detailsViewModel = StateObject(wrappedValue: detailsViewModel)
        self.item = item
    }
    
    
    var body: some View {
  
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(detailsViewModel.isTranslated
                     ? (detailsViewModel.translatedTitle ?? "Перевод недоступен")
                     : item.title)
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
                
                Text(detailsViewModel.isTranslated
                     ? (detailsViewModel.translatedDescription ?? "Перевод недоступен")
                     : (item.description ?? "Нет описания"))
                .padding(.top, 10)
                
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
                    Task {
                        if detailsViewModel.isTranslated {
                            detailsViewModel.toggleTranslation()
                            // возврат на оригинал
                        } else {
                            await detailsViewModel.translateContent() // перевод на русский
                        }
                    }
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
//    let viewModel = DetailsViewModel(item: ArticleModel(from: <#any Decoder#>), translatedArticleId: PassthroughSubject<ArticleModel, Never>)
//    
//    NavigationStack {
//        if ProcessInfo.isPreviewMode {
//            viewModel.items = TestData.modelArray
//        }
//    return DetailsNewsView(detailsViewModel: viewModel, item: viewModel.items.first!)
//    }
    
}
