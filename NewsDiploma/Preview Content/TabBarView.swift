//
//  TabBarView.swift
//  NewsDiploma
//
//  Created by Alena  on 16.03.25.
//

import SwiftUI

struct NewsTabBarView: View {
    var body: some View {
        TabView {
            NavigationStack {
                FirstContentView()
            }
                .tabItem {
                    Image(systemName: "house")
                    Text("Top News")
                }
            NavigationStack {
                SearchView()
            }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            NavigationStack {
                AutorizationView()
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
