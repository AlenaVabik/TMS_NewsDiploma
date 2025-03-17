//
//  Search.swift
//  NewsDiploma
//
//  Created by Alena  on 12.03.25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(8)
                    .background(Color.white.opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .autocapitalization(.none)
            }
        }
        .padding(5)
    }
}

#Preview {
    SearchView()
}
