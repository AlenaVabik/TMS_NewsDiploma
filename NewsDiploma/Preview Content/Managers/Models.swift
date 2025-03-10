//
//  Models.swift
//  NewsDiploma
//
//  Created by Alena  on 9.03.25.
//

import SwiftUI
import Foundation


struct APIResponseModel: Decodable {
    let status: String
    let totalResults: Int
    let results: [ArticleModel]
}

struct ArticleModel: Decodable {
    let articleId: String
    let title: String
    let link: String
    let keywords: [String]?
    let creator: [String]?
    let videoUrl: String?
    let description: String
    let content: String?
    let pubDate: String
    let pubDateTZ: String
    let imageUrl: String
    let sourceId: String
    let sourcePriority: Int
    let sourceName: String
    let sourceUrl: String
    let sourceIcon: String
    let language: String
    let country: [String]
    let category: [String]
    
    enum CodingKeys: String, CodingKey {
        case articleId = "article_id"
        case title, link, keywords, creator
        case videoUrl = "video_url"
        case description, content, pubDate, pubDateTZ
        case imageUrl = "image_url"
        case sourceId = "source_id"
        case sourcePriority = "source_priority"
        case sourceName = "source_name"
        case sourceUrl = "source_url"
        case sourceIcon = "source_icon"
        case language, country, category
    }
}
