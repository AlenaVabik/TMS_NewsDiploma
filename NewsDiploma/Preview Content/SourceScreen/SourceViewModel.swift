//
//  SourceViewModel.swift
//  NewsDiploma
//
//  Created by Alena  on 17.03.25.
//

import SwiftUI
import Combine

final class SourceViewModel: ObservableObject {

    @Published var sourceName: String = ""
    @Published var sourceUrl: String = ""
    @Published var sourceIcon: String = ""
    @Published var pubDate: Date = Date()
}
