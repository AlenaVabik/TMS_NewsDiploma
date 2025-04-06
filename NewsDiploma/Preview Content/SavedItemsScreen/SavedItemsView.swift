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
            if savedViewModel.savedArticles.isEmpty {
                Text("No saved articles yet")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .navigationTitle("Saved")
            } else {
                List(savedViewModel.savedArticles, id: \.title) { article in
                    HStack {
                        if let url = URL(string: article.image) {
                            KFImage(url)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(5)
                        }
                        VStack(alignment: .leading) {
                            Text(article.title)
                                .font(.headline)
                            Text(article.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    Task {
                        do {
                            try await savedViewModel.firebaseManager.logOut()
                            savedViewModel.alertMessage = "You logged out!"
                            savedViewModel.showAlert = true
                        } catch {
                            savedViewModel.alertMessage = "Error: \(error.localizedDescription)"
                            savedViewModel.showAlert = true
                        }
                    }
                }) {
                    HStack{
                        Text("Log out")
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }
                    .padding(10)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.red)

                }
            }
        }
        .onAppear {
            Task {
                await savedViewModel.loadSavedArticles()
            }
        }
//        .task {
//            await savedViewModel.loadSavedArticles()
//        }
        .navigationTitle("Saved")
        .alert(savedViewModel.alertMessage, isPresented: $savedViewModel.showAlert) {
            Button("OK", role: .cancel) {
                
            }
        }
    }
    

}

#Preview {
    NavigationStack {
        SavedItemsView()
    }
}
