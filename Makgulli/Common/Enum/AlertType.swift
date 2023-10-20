//
//  AlertType.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/16.
//

import Foundation

enum AlertType {
    case deleteEpisode

    var title: String {
      switch self {
      case .deleteEpisode:
          return "에피소드 삭제"
      }
    }

    var description: String {
      switch self {
      case .deleteEpisode:
          return "세상에 하나 밖에 없는 에피소드를 삭제하시겠어요?"
      }
    }

    var leftButtonTitle: String {
      switch self {
      case .deleteEpisode:
          return "다음에요"
      }
    }

    var rightButtonTitle: String {
      switch self {
      case .deleteEpisode:
          return "삭제할래요."
      }
    }
  }
