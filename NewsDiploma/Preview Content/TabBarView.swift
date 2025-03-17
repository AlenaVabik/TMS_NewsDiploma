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
                FirstContentView(viewModel: ViewModel())
            }
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            Text("Second")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Find")
                }
            
            Text("Third")
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
