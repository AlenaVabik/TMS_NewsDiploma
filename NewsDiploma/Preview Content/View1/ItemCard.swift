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
        HStack {
            Text(item.title)
                .frame(width: 170, height: 20, alignment: .leading)
                .font(.caption)
            Text(item.pubDate)
        }
        .frame(width: 165, height: 50, alignment: .leading)
    }
}
