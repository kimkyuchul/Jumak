//
//  AlcoholThumbnailDecoration.swift
//  Makgulli
//
//  Created by 김규철 on 5/14/26.
//

import UIKit

enum AlcoholThumbnailDecoration {
    static func makeLoadingIndicator() -> IndicatorView {
        let indicator = IndicatorView(style: .medium, size: 20)
        indicator.startAnimating()
        return indicator
    }

    static func makeFailureView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: stripePattern)
        view.isUserInteractionEnabled = false
        return view
    }

    private static let stripePattern: UIImage = {
        let size = CGSize(width: 8, height: 8)
        return UIGraphicsImageRenderer(size: size).image { context in
            UIColor.darkGray.withAlphaComponent(0.18).setStroke()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: size.height))
            path.addLine(to: CGPoint(x: size.width, y: 0))
            path.lineWidth = 1
            path.stroke()
        }
    }()
}
