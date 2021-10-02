//
//  CGAffineTransform+.swift
//
//
//  Created by Anton Tolstov on 02.10.2021.
//

import CoreGraphics

extension CGAffineTransform {
    /// Returns transform that scales and compensates by translating back to center.
    static func centeredScaleBy(
        _ scale: Double, width: Double, height: Double
    ) -> CGAffineTransform {
        Self.identity
            .translatedBy(
                x: (1 - scale) * width / 2,
                y: (1 - scale) * height / 2
            )
            .scaledBy(x: scale, y: scale)
    }
}
