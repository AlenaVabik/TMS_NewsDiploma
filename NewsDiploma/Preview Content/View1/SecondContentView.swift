//
//  ContentView.swift
//  NewsDiploma
//
//  Created by Alena  on 5.03.25.
//

import SwiftUI

struct SecondContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "newspaper")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("SECOND VIEW")
        }
        .padding()
        .background(Color.red.opacity(0.5))
    }
}

#Preview {
    SecondContentView()
}
