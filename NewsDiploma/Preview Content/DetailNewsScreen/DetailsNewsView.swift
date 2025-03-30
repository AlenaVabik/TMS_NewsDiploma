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
    @State private var showBlur = false
    
    init(detailsViewModel: DetailsViewModel, item: ArticleModel) {
        _detailsViewModel = StateObject(wrappedValue: detailsViewModel)
        self.item = item
    }
    
    
    var body: some View {
        ZStack {
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
                         : (item.description ?? "No description"))
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
                .blur(radius: showBlur ? 10 : 0)
                .animation(.easeInOut, value: showBlur)
                
                // Опционально: затемнение
                if showBlur {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                }
            }
            .sheet(isPresented: $detailsViewModel.isfullScreenPresented, onDismiss: {
                showBlur = false
            }) {
                NavigationStack {
                    SourceView(articleModel: item)
                        .presentationDetents([.large, .medium])
                        .interactiveDismissDisabled()
                        .onAppear {
                            showBlur = true
                        }
                }
            }

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
//    let viewModel = ViewModel()
//
//    if ProcessInfo.isPreviewMode {
//        viewModel.items = TestData.modelArray
//    }
//    DetailsNewsView(detailsViewModel: TestData.articleModel, item: TestData.articleModel)
}
