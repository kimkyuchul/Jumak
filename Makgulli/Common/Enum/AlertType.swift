//
//  AlertType.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/16.
//

import Foundation

enum AlertType {
    case deleteEpisode
    case declarationStore

    var title: String {
      switch self {
      case .deleteEpisode:
          return "에피소드 삭제"
      case .declarationStore:
          return "해당 주막 신고하기"
      }
    }

    var description: String {
      switch self {
      case .deleteEpisode:
          return "세상에 하나 밖에 없는 에피소드를 삭제하시겠어요?"
      case .declarationStore:
          return "해당 주막이 실제로 존재하지 않아 신고하시겠어요?"
      }
    }

    var leftButtonTitle: String {
      switch self {
      case .deleteEpisode, .declarationStore:
          return "다음에요"
      }
    }

    var rightButtonTitle: String {
      switch self {
      case .deleteEpisode:
          return "삭제할래요"
      case .declarationStore:
          return "신고할래요"
      }
    }
  }
