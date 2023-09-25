//
//  Bundle+.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/25.
//

import Foundation

extension Bundle {
    var naverMapsClientID: String {
        guard let file = self.path(forResource: "NaverMaps", ofType: "plist") else {
            fatalError("NaverMaps.plist 파일이 없습니다.")
        }
        guard let resource = NSDictionary(contentsOfFile: file) else { fatalError("파일 형식 에러") }
        guard let clientID = resource["NMFClientId"] as? String else {
            fatalError("NaverMaps에 NMFClientId을 설정해주세요.")
        }
        return clientID
    }
}
