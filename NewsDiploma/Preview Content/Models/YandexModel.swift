//
//  Untitled.swift
//  NewsDiploma
//
//  Created by Alena  on 22.03.25.
//

//запрос
struct TranslatedArticleModel {
    let articleId: String
    let title: String
    let description: String
}

//ответ
struct YandexTranslateResponse: Decodable {
    let translations: [Translation]
}

struct Translation: Decodable {
    let text: String
}
