//
//  DetailsViewModel.swift
//  NewsDiploma
//
//  Created by Alena  on 17.03.25.
//
import SwiftUI
import Combine

final class DetailsViewModel: ObservableObject, Sendable {
    @Published var items: [ArticleModel] = []
    @Published var isfullScreenPresented: Bool = false

}
