//
//  DetailsNewsView.swift
//  NewsDiploma
//
//  Created by Alena  on 13.03.25.
//

import SwiftUI
import Kingfisher

struct DetailsNewsView: View {
    let title: String
    let description: String
    let imageUrl: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                if let imageUrl {
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

                Text(description)
            }
            .padding()
        }
        .navigationTitle("Details")
    }
}



#Preview {

}
