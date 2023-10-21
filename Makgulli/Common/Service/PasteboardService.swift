//
//  PasteboardService.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/19.
//

import UIKit

protocol PasteboardService: AnyObject {
    func addressPasteboard(address: String)
}

final class DefaultPasteboardService: PasteboardService {
    func addressPasteboard(address: String) {
        UIPasteboard.general.string = address
    }
}
