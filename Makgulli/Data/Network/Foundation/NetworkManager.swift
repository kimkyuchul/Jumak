//
//  NetworkManager.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/26.
//

import Foundation

import RxSwift
import Alamofire

struct NetworkManager<T: TargetType> {
    
    func request<T: Decodable>(_ target: TargetType, type: T.Type) -> Single<T> {
        return Single.create(subscribe: { single in
            AF.request(target).responseData { response in
                switch response.result {
                case .success(let value):
                    guard let statusCode = response.response?.statusCode else { return }
                    let isSuccessful = (200..<300).contains(statusCode)
                    
                    if isSuccessful {
                        do {
                            let data = try JSONDecoder().decode(T.self, from: value)
                            single(.success(data))
                        } catch {
                            print(error.localizedDescription)
                            single(.failure(error))
                        }
                    } else {
                        print(response.response)
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                    single(.failure(failure))
                }
            }
            return Disposables.create()
        })
    }
}
