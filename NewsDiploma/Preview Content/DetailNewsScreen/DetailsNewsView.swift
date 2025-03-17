//
//  DetailsNewsView.swift
//  NewsDiploma
//
//  Created by Alena  on 13.03.25.
//

import SwiftUI
import Kingfisher

struct DetailsNewsView: View {
    @StateObject var viewModel: ViewModel

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
                    viewModel.isfullScreenPresented = true
                    
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
            .fullScreenCover(isPresented: $viewModel.isfullScreenPresented) {
                NavigationStack {
                    SourceView(sourceName: item.sourceName, sourceUrl: item.sourceUrl, sourceIcon: item.sourceIcon, pubDate: item.pubDate)
                }
            }
//            .sheet(isPresented: $viewModel.isSourceViewPresented) {
//                NavigationStack {
//                    SourceView(sourceName: item.sourceName, sourceUrl: item.sourceUrl, sourceIcon: item.sourceIcon, pubDate: item.pubDate)
//                }
//            }
            .padding()
        }
        .navigationTitle("Details")
    }
}



#Preview {
    let viewModel = ViewModel()
    
    NavigationStack {
        if ProcessInfo.isPreviewMode {
            viewModel.items = TestData.modelArray
        }
    return DetailsNewsView(viewModel: viewModel, item: viewModel.items.first!)
    }
    
}
//#Preview {
//    let viewModel = ViewModel()
//    
//    NavigationStack {
//        if ProcessInfo.isPreviewMode {
//            viewModel.items = TestData.modelArray
//        }
//         return FirstContentView(viewModel: viewModel)
//    }
//    
//}
