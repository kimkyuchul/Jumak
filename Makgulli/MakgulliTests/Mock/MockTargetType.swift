//
//  MockTargetType.swift
//  Makgulli
//
//  Created by kyuchul on 12/20/24.
//

import Foundation

@testable import Makgulli

import Alamofire

enum MockTargerType {
    case fetchMockTraditionalAlcoholicBeverage(page: Int, perPage: Int = 20)
}

extension MockTargerType: TargetType {
    var baseURL: String {
        return "https://www.naver.com"
    }
    
    var method: Alamofire.HTTPMethod {
        .get
    }
    
    var path: String {
        return ""
    }
    
    var task: Makgulli.Task {
        switch self {
        case let .fetchMockTraditionalAlcoholicBeverage(page, perPage):
            return .requestParameters(parameters: [
                "page": page,
                "perPage": perPage,
                "serviceKey": "test"
            ], encoding: URLEncoding.queryString)
        }
    }
}


//extension AlcoholicBeverageDTO {
//    static var mockTraditionalWineData: Data {
//        let mockResponse = AlcoholicBeverageDTO(
//            page: 1,
//            perPage: 20,
//            totalCount: 1073,
//            currentCount: 1,
//            matchCount: 10,
//            data: [
//                TraditionalLiquorDTO(
//                    specification: "750ml",
//                    alcoholContent: "10.5",
//                    name: "고도리 화이트와인 드라이",
//                    manufacturer: "고도리 와이너리",
//                    mainIngredient: "거봉포도(영천)"
//                ),
//                TraditionalLiquorDTO(
//                    specification: "750ml",
//                    alcoholContent: "6.5",
//                    name: "고도리 복숭아와인",
//                    manufacturer: "고도리 와이너리",
//                    mainIngredient: "복숭아(경북 영천)"
//                ),
//                TraditionalLiquorDTO(
//                    specification: "375ml",
//                    alcoholContent: "12",
//                    name: "뱅꼬레 아이스와인",
//                    manufacturer: "한국와인",
//                    mainIngredient: "양조용포도(영천)"
//                ),
//                TraditionalLiquorDTO(
//                    specification: "375ml",
//                    alcoholContent: "11.5",
//                    name: "뱅꼬레 로제와인",
//                    manufacturer: "한국와인",
//                    mainIngredient: "양조용포도(영천)"
//                )
//            ]
//        )
//        
//        return mockResponse
//    }
//}

