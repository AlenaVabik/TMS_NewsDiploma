//
//  ItemCard.swift
//  NewsDiploma
//
//  Created by Alena  on 10.03.25.
//

import SwiftUI
import Kingfisher

struct ItemScreenCard: View {
    var item: ArticleModel
    
    var body: some View {
        VStack {
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
                Text(item.title)
                    .font(.title2)
                    .frame(width: .infinity, alignment: .leading)
            Text(item.description ?? "No description")
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let pubDate = item.pubDate {
                Text(pubDate, format: .dateTime.year().month().day())
                    .font(.caption2)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.gray)
            } else {
                Text("No date")
                    .font(.caption2)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.gray)
            }

        }
        .padding()
        .background(Color.white)
        Divider()
    }
}

#Preview {
    let viewModel = ViewModel()

    if ProcessInfo.isPreviewMode {
        ItemScreenCard(item: TestData.articleModel)
    }
}
