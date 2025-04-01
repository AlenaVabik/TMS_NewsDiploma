//
//  ItemCard.swift
//  NewsDiploma
//
//  Created by Alena  on 10.03.25.
//

import SwiftUI

struct ItemCard: View {
    var item: ArticleModel
    
    var body: some View {
        VStack {
            Text(item.title)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(item.pubDate ?? Date(), format: .dateTime.year().month().day())
                .font(.caption2)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(.gray)
        }
        .background(Color.accentColor.opacity(0.1))
    }
}

#Preview {
    let viewModel = ViewModel()

    if ProcessInfo.isPreviewMode {
        ItemCard(item: TestData.articleModel)
    }
}
