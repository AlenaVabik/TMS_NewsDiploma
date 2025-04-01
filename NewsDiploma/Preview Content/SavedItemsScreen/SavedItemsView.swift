//
//  SavedItemsView.swift
//  NewsDiploma
//
//  Created by Alena  on 2.04.25.
//

import SwiftUI

struct SavedItemsView: View {
    
    var body: some View {
        Text("Saved Items")
            .navigationTitle("Saved")
    }
}

#Preview {
    NavigationStack {
        SavedItemsView()
    }
}
