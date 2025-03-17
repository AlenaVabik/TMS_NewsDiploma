//
//  SourceView.swift
//  NewsDiploma
//
//  Created by Alena  on 16.03.25.
//

import SwiftUI

struct SourceView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var sourceViewModel: SourceViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if sourceViewModel.sourceIcon.isEmpty {
                Image(systemName: "newspaper.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            } else {
                Image(systemName: sourceViewModel.sourceIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
            
            Text(sourceViewModel.sourceName)
                .font(.title)
                .fontWeight(.bold)
            
            if let url = URL(string: sourceViewModel.sourceUrl) {
                Link("Go to source", destination: url)
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
                .foregroundColor(.gray)
            
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
        
        .background(Color.secondary)
    }
    
    private var formattedPubDate: String {
        DateFormatter.articleDateFormatter.string(from: sourceViewModel.pubDate)
    }
}


#Preview {
    NavigationStack {
        SourceView(sourceViewModel: SourceViewModel())
    }
}
