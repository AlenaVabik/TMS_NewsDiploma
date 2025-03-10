//
//  JSONService.swift
//  NewsDiploma
//
//  Created by Alena  on 8.03.25.
//

import SwiftUI
import Moya

let myAPIKey = "pub_7329412f3824b77fc8d104ba5b17b684559f5"
let locale = Locale.current.language.languageCode?.identifier  /*язык системы*/

enum JsonService {
    case latest(q: String?, category: String?, country: String?)
}

extension JsonService: TargetType {
    var baseURL: URL {
        switch self {
        case .latest:
            return URL(string: "https://newsdata.io/api/1")!
        }
    }
    
    var path: String {
        switch self {
        case .latest(q: let q, category: let category, country: let country):
            return "latest"
        }
    }
    
    var method: Moya.Method {
        .get
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
        }
        return params
    }

    
    var headers: [String : String]? {
        nil
    }
    
    var parameterEncoding: ParameterEncoding {
        URLEncoding.default
    }
    
}
