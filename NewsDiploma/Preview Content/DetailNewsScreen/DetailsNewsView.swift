//
//  DetailsNewsView.swift
//  NewsDiploma
//
//  Created by Alena  on 13.03.25.
//

import SwiftUI

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
                
                if let imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                        default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                }
                
                Text(description)
                    .font(.body)
                    .padding(.top, 10)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Details")
    }
}



#Preview {

}
