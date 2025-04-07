//
//  ItemCard.swift
//  NewsDiploma
//
//  Created by Alena  on 10.03.25.
//

import SwiftUI
import Kingfisher

struct ItemCard: View {
    var item: ArticleModel
    
    var body: some View {
        HStack {
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
            
            VStack {
                Text(item.title)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(item.pubDate ?? Date(), format: .dateTime.year().month().day())
                    .font(.caption2)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    let viewModel = ViewModel()

    if ProcessInfo.isPreviewMode {
        ItemCard(item: TestData.articleModel)
    }
}
