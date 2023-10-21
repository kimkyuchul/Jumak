//
//  LocationDetailRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/14.
//

import Foundation

protocol LocationDetailRepository: AnyObject {
    func loadDataSourceImage(fileName: String) -> Data? 
}
