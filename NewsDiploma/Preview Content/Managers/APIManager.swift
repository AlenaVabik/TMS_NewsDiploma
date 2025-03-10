//
//  APIManager.swift
//  NewsDiploma
//
//  Created by Alena  on 8.03.25.
//
import SwiftUI
import Moya


class APIManager {
    //MARK: Request Moya
    let provider = MoyaProvider<JsonService>()
    
    func sendRequest<T: Decodable>(typeResult: T.Type, endpoint: JsonService) async throws -> T {
        
       try await withCheckedThrowingContinuation { continuation in
            provider.request(endpoint) { result in
                switch result {
                case .success(let response):
                    do {
                        let stringData = String(data: response.data, encoding: .utf8) ?? ""
                        print("Ответ сервера: \(stringData)")
                        
                        let filtresResponse = try response.filterSuccessfulStatusCodes().map(T.self)
                        print("Получены данные из \(filtresResponse)")
                        return continuation.resume(returning: filtresResponse)
                    } catch {
                        print("Ошибка декодирования \(error)")
                        return continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    print("Error request: \(error)")
                    return continuation.resume(throwing: error)
                }
            }
        }
    }
    
    
//универсальный метод для отправки запросов
    func sendRequest<T: Decodable>(typeResult: T.Type, endpoint: JsonService, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(endpoint) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let response):
                do {
                    let filtresResponse = try response.filterSuccessfulStatusCodes().map(T.self)
                    print("Получены данные из \(filtresResponse)")
                    completion(.success(filtresResponse))
                } catch {
                    print("Ошибка декодирования \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Error request: \(error)")
                completion(.failure(error))
            }
        }
    }
   
}
