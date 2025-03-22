//
//  JSONService.swift
//  NewsDiploma
//
//  Created by Alena  on 8.03.25.
//

import SwiftUI
import Moya

let myAPIKey = "pub_7329412f3824b77fc8d104ba5b17b684559f5"
let yandexAPIKey = "Api-Key AQVN3jX6WN4x2RNnY7EcLLdylbVeWoSbPzNtogSR"
let locale = Locale.current.language.languageCode?.identifier

enum JsonService {
    case latest(q: String?, category: String?, country: String?)
    case translate(texts: [String], targetLanguageCode: String = "ru", sourceLanguageCode: String = "en")
}

extension JsonService: TargetType {
    var baseURL: URL {
        switch self {
        case .latest:
            return URL(string: "https://newsdata.io/api/1")!
        case .translate:
            return URL(string: "https://translate.api.cloud.yandex.net/translate/v2")!
//            Authorization    Api-Key AQVN3jX6WN4x2RNnY7EcLLdylbVeWoSbPzNtogSR
        }
        
    }
    
    var path: String {
        switch self {
        case .latest:
            "latest"
        case .translate:
            "translate"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .latest:
            return .get
        case .translate:
            return .post
        }
    }
    
    var task: Moya.Task {
        guard let params = parameters else {
            return .requestPlain
        }
        return .requestParameters(parameters: params, encoding: parameterEncoding)
    }

    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        params["apikey"] = myAPIKey
        params["language"] = locale ?? "en"
        switch self {
        case .latest(q: let q, category: let category, country: let country):
            if let q {
                params["q"] = q
            }
            if let category {
                params["category"] = category
            }
            if let country {
                params["country"] = country
            }
        case .translate(texts: let texts, targetLanguageCode: let targetLanguageCode, sourceLanguageCode: let sourceLanguageCode):
            return [
                "sourceLanguageCode": sourceLanguageCode,
                "targetLanguageCode": targetLanguageCode,
                "format": "PLAIN_TEXT",
                "texts": texts,
                "folderId": "b1gagvjaohvssl6mg135",
                "speller": "true"
            ]
        }
            return params
    }

    
    var headers: [String : String]? {
        switch self {
        case .latest:
            return nil
        case .translate:
            return [
                "Authorization": "\(yandexAPIKey)",
                "Content-Type": "application/json"
            ]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .latest:
            return URLEncoding.default
        case .translate:
            return JSONEncoding.default
        }
    }

}
