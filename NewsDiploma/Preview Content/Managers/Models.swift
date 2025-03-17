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
    let totalResults: Int?
    let results: [ArticleModel]
}

struct ArticleModel: Decodable {
    let articleId: String
    let title: String
    let link: String
    let keywords: [String]?
    let creator: [String]?
    let videoUrl: String?
    let description: String?
    let content: String?
    let pubDate: Date
    let pubDateTZ: String
    let imageUrl: String?
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
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<ArticleModel.CodingKeys> = try decoder.container(keyedBy: ArticleModel.CodingKeys.self)
        
        self.articleId = try container.decode(String.self, forKey: ArticleModel.CodingKeys.articleId)
        self.title = try container.decode(String.self, forKey: ArticleModel.CodingKeys.title)
        self.link = try container.decode(String.self, forKey: ArticleModel.CodingKeys.link)
        self.keywords = try container.decodeIfPresent([String].self, forKey: ArticleModel.CodingKeys.keywords)
        self.creator = try container.decodeIfPresent([String].self, forKey: ArticleModel.CodingKeys.creator)
        self.videoUrl = try container.decodeIfPresent(String.self, forKey: ArticleModel.CodingKeys.videoUrl)
        self.description = try container.decodeIfPresent(String.self, forKey: ArticleModel.CodingKeys.description)
        self.content = try container.decodeIfPresent(String.self, forKey: ArticleModel.CodingKeys.content)
        let pubDate = try container.decode(String.self, forKey: ArticleModel.CodingKeys.pubDate)
        
        if let date = DateFormatter.articleDateFormatter.date(from: pubDate) {
            self.pubDate = date
        } else {
            self.pubDate = Date()
        }
        self.pubDateTZ = try container.decode(String.self, forKey: ArticleModel.CodingKeys.pubDateTZ)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: ArticleModel.CodingKeys.imageUrl)
        self.sourceId = try container.decode(String.self, forKey: ArticleModel.CodingKeys.sourceId)
        self.sourcePriority = try container.decode(Int.self, forKey: ArticleModel.CodingKeys.sourcePriority)
        self.sourceName = try container.decode(String.self, forKey: ArticleModel.CodingKeys.sourceName)
        self.sourceUrl = try container.decode(String.self, forKey: ArticleModel.CodingKeys.sourceUrl)
        self.sourceIcon = try container.decode(String.self, forKey: ArticleModel.CodingKeys.sourceIcon)
        self.language = try container.decode(String.self, forKey: ArticleModel.CodingKeys.language)
        self.country = try container.decode([String].self, forKey: ArticleModel.CodingKeys.country)
        self.category = try container.decode([String].self, forKey: ArticleModel.CodingKeys.category)
        
    }
    
    init(
            articleId: String,
            title: String,
            link: String,
            keywords: [String]? = nil,
            creator: [String]? = nil,
            videoUrl: String? = nil,
            description: String? = nil,
            content: String? = nil,
            pubDate: Date,
            pubDateTZ: String,
            imageUrl: String? = nil,
            sourceId: String,
            sourcePriority: Int,
            sourceName: String,
            sourceUrl: String,
            sourceIcon: String,
            language: String,
            country: [String],
            category: [String]
        ) {
            self.articleId = articleId
            self.title = title
            self.link = link
            self.keywords = keywords
            self.creator = creator
            self.videoUrl = videoUrl
            self.description = description
            self.content = content
            self.pubDate = pubDate
            self.pubDateTZ = pubDateTZ
            self.imageUrl = imageUrl
            self.sourceId = sourceId
            self.sourcePriority = sourcePriority
            self.sourceName = sourceName
            self.sourceUrl = sourceUrl
            self.sourceIcon = sourceIcon
            self.language = language
            self.country = country
            self.category = category
        }
}
