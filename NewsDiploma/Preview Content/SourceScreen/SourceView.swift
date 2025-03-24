//
//  SourceView.swift
//  NewsDiploma
//
//  Created by Alena  on 16.03.25.
//

import SwiftUI
import Kingfisher

struct SourceView: View {
    @Environment(\.dismiss) private var dismiss
    
    let articleModel: ArticleModel
    
    var body: some View {
        VStack(spacing: 20) {
            if articleModel.sourceIcon.isEmpty {
                Image(systemName: "newspaper.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            } else {
                KFImage(URL(string: articleModel.sourceIcon))
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
            
            Text(articleModel.sourceName)
                .font(.title)
                .fontWeight(.bold)
            
            if let url = URL(string: articleModel.sourceUrl) {
                Link("Go to source link", destination: url)
                    .font(.headline)
                    .foregroundColor(.blue)
            } else {
                Text("Wrong URL")
                    .font(.title2)
                    .foregroundColor(.red)
            }
            
            Text("Request date: \(formattedPubDate)")
                .font(.caption)
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
            
            Button {
                dismiss()
            } label: {
                Text("Close")
                    .frame(width: 200, height: 25)
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Source of information")
        .background(
            AngularGradient(
                gradient: Gradient(colors: [Color.white, Color.brown, Color.white]),
                center: .center
            )
        )
        .cornerRadius(10)
        .padding()
    }
    
    private var formattedPubDate: String {
        if let pubDate = articleModel.pubDate {
            return DateFormatter.articleDateFormatter.string(from: pubDate)
        } else {
            return "No date available"
        }
    }
}


#Preview {
    let viewModel = ViewModel()
    NavigationStack {
        if ProcessInfo.isPreviewMode {
            viewModel.items = TestData.modelArray
        }
         return SourceView(articleModel: TestData.articleModel)
    }
}
