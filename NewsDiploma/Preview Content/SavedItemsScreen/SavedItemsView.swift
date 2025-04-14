//
//  SavedItemsView.swift
//  NewsDiploma
//
//  Created by Alena  on 2.04.25.
//

import SwiftUI
import Kingfisher
import FirebaseAuth
import Firebase

struct SavedItemsView: View {
    @StateObject private var savedViewModel = SavedViewModel()

    
    var body: some View {
        NavigationView {
            Group {
                if savedViewModel.savedArticles.isEmpty {
                    Text("No saved articles yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    List(savedViewModel.savedArticles, id: \.articleId) { item in
                        NavigationLink(
                            destination: DetailsNewsView(
                                detailsViewModel: DetailsViewModel(
                                    item: item
                                ),
                                item: item
                            )
                        ) {
                            ItemCard(item: item)
                        }
                    }
                    
                    .scrollContentBackground(.visible)
                }
            }
            .navigationTitle("Saved")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: savedViewModel.logOutAction) {
                        HStack{
                            Text("Log out")
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                        .padding(10)
                        .font(.callout)
                        .cornerRadius(10)
                        .foregroundColor(.red)
                    }
                }
            }
            .alert(savedViewModel.alertMessage, isPresented: $savedViewModel.showAlert) {
                Button("OK", role: .cancel) {
                    
                }
            }
            .task {
                await savedViewModel.loadSavedArticles()
            }

        }
    }
    

}

#Preview {
    NavigationStack {
        SavedItemsView()
    }
}
