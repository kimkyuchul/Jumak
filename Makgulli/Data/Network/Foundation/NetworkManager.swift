//
//  NetworkManager.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/26.
//

import Foundation
import Combine

import RxSwift
import Alamofire

protocol NetworkSessionable<APIType> {
    associatedtype APIType: TargetType
    
    func request<Model: Decodable>(_ target: APIType, type: Model.Type) -> Single<Model>
    func request<Model: Decodable>(_ target: APIType, type: Model.Type) -> AnyPublisher<Model, Error>
}

struct NetworkManager<APIType: TargetType>: NetworkSessionable {
    private let decoder: JSONDecoder
    
    init() {
        self.decoder = JSONDecoder()
    }
    
    func request<Model: Decodable>(_ target: APIType, type: Model.Type) -> Single<Model> {
        
        return Single.create(subscribe: { single in
            AF.request(target).responseData { response in
                switch response.result {
                case .success(let value):
                    if validate(response.response) {
                        do {
                            let data = try decoder.decode(Model.self, from: value)
                            single(.success(data))
                        } catch {
                            dump(error.localizedDescription)
                            single(.failure(NetworkError.decodingError))
                        }
                    } else {
                        single(.failure(NetworkError.isNotSuccessful(statusCode: response.response?.statusCode ?? 500)))
                    }
                case .failure(let failure):
                    single(.failure(NetworkError.underlyingError(message: failure.localizedDescription)))
                }
            }
            return Disposables.create()
        })
    }
    
    func request<Model: Decodable>(_ target: APIType, type: Model.Type) -> AnyPublisher<Model, Error> {
        Future<Model, Error> { promise in
            AF.request(target).responseData { response in
                switch response.result {
                case .success(let value):
                    if validate(response.response) {
                        do {
                            let data = try decoder.decode(Model.self, from: value)
                            promise(.success(data))
                        } catch {
                            dump(error.localizedDescription)
                            promise(.failure(NetworkError.decodingError))
                        }
                    } else {
                        promise(.failure(NetworkError.isNotSuccessful(statusCode: response.response?.statusCode ?? 500)))
                    }
                    
                case .failure(let failure):
                    promise(.failure(NetworkError.underlyingError(message: failure.localizedDescription)))
                }
            }
        }.eraseToAnyPublisher()
    }
}

private extension NetworkManager {
    func validate(_ response: HTTPURLResponse?) -> Bool {
        guard let statusCode = response?.statusCode else { return false }
        return (200..<300).contains(statusCode)
    }
}

