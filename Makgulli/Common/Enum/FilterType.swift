//
//  FilterType.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/18.
//

import Foundation

enum FilterType: CaseIterable {
    case recentlyAddedBookmark
    case sortByUpRating
    case bookmarkSortByUpRating
    case sortByDescendingEpisodeCount
    case bookmarkSortByDescendingEpisodeCount
    case sortByName
    
    var title: String {
        switch self {
        case .recentlyAddedBookmark:
            return "최근 즐겨찾기 순"
        case .sortByUpRating:
            return "평점 높은 순"
        case .bookmarkSortByUpRating:
            return "평점 높은 즐겨찾기 순"
        case .sortByDescendingEpisodeCount:
            return "에피소드 많은 순"
        case .bookmarkSortByDescendingEpisodeCount:
            return "에피소드 많은 즐겨찾기 순"
        case .sortByName:
            return "가나다 순"
        }
    }
}

enum ReverseFilterType {
    case none
    case reverse
}

