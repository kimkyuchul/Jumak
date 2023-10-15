//
//  WriteEpisodeRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/14.
//

import Foundation

import RxSwift

protocol WriteEpisodeRepository {
    func saveImage(fileName: String, imageData: Data) -> Completable
}
