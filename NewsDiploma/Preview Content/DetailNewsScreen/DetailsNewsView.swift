//
//  DetailsNewsView.swift
//  NewsDiploma
//
//  Created by Alena  on 13.03.25.
//

import SwiftUI
import Kingfisher

enum BookmarkState: String {
    case unmarked = "bookmark"
    case marked = "bookmark.fill"
}

struct DetailsNewsView: View {
    @StateObject private var detailsViewModel: DetailsViewModel
    var item: ArticleModel
        
    @State private var bookmarkState: BookmarkState = .unmarked

    init(detailsViewModel: DetailsViewModel, item: ArticleModel) {
        _detailsViewModel = StateObject(wrappedValue: detailsViewModel)
        self.item = item
    }
    
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text(detailsViewModel.showTranslation
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
                    
                    
                    Text(detailsViewModel.showTranslation
                         ? (detailsViewModel.translatedDescription ?? "Перевод недоступен")
                         : (item.description ?? "No description"))
                    .padding(.top, 10)
                    
                    
                    
                    Button(action: {
                        detailsViewModel.isSourceViewPresented = true
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
                .blur(radius: detailsViewModel.showBlur ? 10 : 0)
                .animation(.easeInOut, value: detailsViewModel.showBlur)
                
                if detailsViewModel.showBlur {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                }
            }
            .sheet(isPresented: $detailsViewModel.isSourceViewPresented, onDismiss: {
                detailsViewModel.showBlur = false
            }) {
                NavigationStack {
                    SourceView(articleModel: item)
                        .presentationDetents([.large, .medium])
                        .interactiveDismissDisabled()
                        .onAppear {
                            detailsViewModel.showBlur = true
                        }
                }
            }

            .padding(.horizontal)
        }
        
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    Task {
                        if detailsViewModel.showTranslation {
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
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    Task {
                        bookmarkState = await detailsViewModel.removeOrSaveArticleAction(currentState: bookmarkState)
                    }
                }) {
                    Image(systemName: bookmarkState.rawValue)
                        .font(.title2)
                        .foregroundColor(bookmarkState == .marked ? .yellow : .gray)
                }
            }
        }
        .sheet(isPresented: $detailsViewModel.isAutorisationViewPresented, onDismiss: {
            detailsViewModel.showBlur = false
        }) {
            NavigationStack {
                AutorizationView()
                    .interactiveDismissDisabled()
                    .onAppear {
                        detailsViewModel.showBlur = true
                    }
            }
        }
        .alert(detailsViewModel.alertMessage, isPresented: $detailsViewModel.showAlert) {
            Button("OK", role: .cancel) {
                
            }
        }
        
        .task {
            bookmarkState = await detailsViewModel.checkBookmarkAction()
        }
 
    }
}

#Preview {
    NavigationStack {
        DetailsNewsView(detailsViewModel: TestData.detailViewModel, item: TestData.articleModel)
    }
}
