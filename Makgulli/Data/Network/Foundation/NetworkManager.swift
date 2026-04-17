//
//  NetworkManager.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/26.
//

import Foundation

import RxSwift
import Alamofire

protocol NetworkService {
    func request<T: Decodable>(_ target: TargetType, type: T.Type) -> Single<T>
}

final class DefaultNetworkService: NetworkService {
    func request<T: Decodable>(_ target: TargetType, type: T.Type) -> Single<T> {
        return Single.create { single in
            AF.request(target).responseData { response in
                single(Self.handleResponse(response, type: type))
            }
            return Disposables.create()
        }
    }

    // MARK: - 결과 분기
    private static func handleResponse<T: Decodable>(_ response: AFDataResponse<Data>, type: T.Type) -> Result<T, Error> {
        switch response.result {
        case .success(let data):
            return validateAndDecode(data: data, statusCode: response.response?.statusCode, type: type)
        case .failure(let error):
            return .failure(NetworkError.underlyingError(message: error.localizedDescription))
        }
    }

    // MARK: - HTTP 상태코드 검증 + JSON 디코딩
    private static func validateAndDecode<T: Decodable>(data: Data, statusCode: Int?, type: T.Type) -> Result<T, Error> {
        guard let statusCode, (200..<300).contains(statusCode) else {
            return .failure(NetworkError.isNotSuccessful(statusCode: statusCode ?? 500))
        }

        do {
            let decoded = try JSONDecoder().decode(type, from: data)
            return .success(decoded)
        } catch {
            dump(error.localizedDescription)
            return .failure(NetworkError.decodingError)
        }
    }
}
