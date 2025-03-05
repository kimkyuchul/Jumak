//
//  StubAlcoholicBeverageUseCase.swift
//  Makgulli
//
//  Created by kyuchul on 1/21/25.
//

import Foundation
@testable import Makgulli

final class StubAlcoholicBeverageUseCase: AlcoholicBeverageUseCase {
    var dataHandler: (Int) async -> Result<AlcoholicBeverage, Error>
    
    init(dataHandler: @escaping (Int) async -> Result<AlcoholicBeverage, Error>) {
        self.dataHandler = dataHandler
    }
    
    func fetchAlcoholicBeverageListAsync(page: Int) async -> Result<AlcoholicBeverage, Error> {
        return await dataHandler(page)
    }
}

extension StubAlcoholicBeverageUseCase {
    var mockData:AlcoholicBeverage {
        return .init(
            page: 1,
            currentCount: 5,
            totalCount: 5,
            liquor: [
                .init(
                    name: "고도리 화이트와인 드라이",
                    alcoholContent: "10.5 도",
                    specification: "750ml",
                    mainIngredient: "거봉포도(영천)",
                    manufacturer: "고도리 와이너리",
                    liquorType: .와인
                ),
                .init(
                    name: "고도리 복숭아와인",
                    alcoholContent: "6.5 도",
                    specification: "750ml",
                    mainIngredient: "복숭아(경북 영천)",
                    manufacturer: "고도리 와이너리",
                    liquorType: .와인
                ),
                .init(
                    name: "뱅꼬레 아이스와인",
                    alcoholContent: "12 도",
                    specification: "375ml",
                    mainIngredient: "양조용포도(영천)",
                    manufacturer: "한국와인",
                    liquorType: .와인
                ),
                .init(
                    name: "무주구천동산머루주",
                    alcoholContent: "16 도",
                    specification: "750ml, 360ml",
                    mainIngredient: "머루",
                    manufacturer: "산머루농원",
                    liquorType: .전통주
                ),
                .init(
                    name: "겨울소주 25",
                    alcoholContent: "25 도",
                    specification: "360ml",
                    mainIngredient: "국내산 쌀, 증류원액, 효모, 효소, 정제수",
                    manufacturer: "두이술공방",
                    liquorType: .소주
                )
            ]
        )
    }
}
