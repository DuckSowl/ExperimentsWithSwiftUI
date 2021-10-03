//
//  CGRect+.swift
//
//
//  Created by Anton Tolstov on 03.10.2021.
//

import CoreGraphics

extension CGRect {
    /// Returns transform to fit `self` in center of the other rect boundries.
    func transformToFit(in rect: CGRect) -> CGAffineTransform {
        let yScale = rect.height / height
        let xScale = rect.width / width
        let scale = yScale * min(1, xScale / yScale)

        let yTranslation = (rect.height - height * scale) / 2 - origin.y * scale
        let xTranslation = (rect.width - width * scale) / 2 - origin.x * scale

        return CGAffineTransform.identity
            .translatedBy(x: xTranslation, y: yTranslation)
            .scaledBy(x: scale, y: scale)
    }
}
