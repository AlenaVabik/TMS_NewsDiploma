//
//  TabBarView.swift
//  NewsDiploma
//
//  Created by Alena  on 16.03.25.
//

import SwiftUI

struct NewsTabBarView: View {
    @StateObject var viewModel = ViewModel()
    @StateObject private var searchViewModel = SearchViewModel()

    var body: some View {
        TabView {
            NavigationStack {
                FirstContentView(viewModel: viewModel)
            }
                .tabItem {
                    Image(systemName: "house")
                    Text("Top News")
                }
            NavigationStack {
                SearchView(searchViewModel: searchViewModel)
            }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            NavigationStack {
                MapContainerView()
            }
                .tabItem {
                    Image(systemName: "mappin.circle.fill")
                    Text("Map")
                }
        }
    }
}


#Preview {
    NewsTabBarView()
}
