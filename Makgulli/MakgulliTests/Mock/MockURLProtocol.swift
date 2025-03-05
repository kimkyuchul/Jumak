//
//  MockURLProtocol.swift
//  Makgulli
//
//  Created by kyuchul on 12/20/24.
//

import Foundation


final class MockURLProtocol: URLProtocol {
    
    private let data: Data
    
    init(data: Data) {
        self.data = data
        super.init()
    }
    
    // 프로토콜 하위 클래스가 지정된 요청을 처리할 수 있는지 여부를 결정
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    // 지정된 요청의 정식 버전을 반환
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // 요청의 프로토콜별 로드를 시작 -> 이 부분에서 우리가 전달해야할 데이터를 주입
    override func startLoading() {
        
        // client란 ??
        // 정의(var client: URLProtocolClient?) 프로토콜이 URL 로드 시스템과 통신하는 데 사용하는 개체
        
        // 프로토콜 구현이 일부 데이터를 로드했음을 클라이언트에 알림 (Required) -> 데이터 전달.
        client?.urlProtocol(self, didLoad: data)
        // 프로토콜 구현이 요청에 대한 응답 개체를 생성했음을 클라이언트에 알림 (Required)
        client?.urlProtocol(self, didReceive: HTTPURLResponse(), cacheStoragePolicy: .allowed)
        // 프로토콜 구현이 로드를 완료했음을 클라이언트에 알림 (Required)
        client?.urlProtocolDidFinishLoading(self)
        
    }
    
    override func stopLoading() {}
}
