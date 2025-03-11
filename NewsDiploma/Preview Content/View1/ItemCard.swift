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
                .font(.caption)
            Text(item.pubDate, format: .dateTime.year().month().day().hour().minute())
        }
    }
}

#Preview {
//    ItemCard(item: <#ArticleModel#>)
}
