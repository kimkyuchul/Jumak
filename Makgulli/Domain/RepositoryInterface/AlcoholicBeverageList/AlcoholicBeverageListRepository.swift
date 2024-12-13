//
//  AlcoholicBeverageListRepository.swift
//  Makgulli
//
//  Created by kyuchul on 12/13/24.
//

import Foundation
import Combine

protocol AlcoholicBeverageListRepository: AnyObject {
    func fetchAlcoholicBeverageList(page: Int) -> AnyPublisher<AlcoholicBeverage, Error>
}
