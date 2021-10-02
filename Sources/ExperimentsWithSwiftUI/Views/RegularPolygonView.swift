//
//  RegularPolygonView.swift
//
//
//  Created by Anton Tolstov on 01.10.2021.
//

import SwiftUI

public struct RegularPolygonView: Shape {
    // MARK: - Private properties
    private let sides: Int

    // MARK: - Initialization
    public init(sides: Int) {
        self.sides = sides
    }

    // MARK: - Shape
    public func path(in rect: CGRect) -> Path {
        let angle = .pi * 2.0 / Double(sides)
        let size = rect.size
        let circumradius = min(size.width, size.height) / 2.0
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)

        let points = (0..<sides)
            .map { Double($0) * angle - .pi / 2 }
            .map { angleOfRotation -> CGPoint in
                CGPoint(
                    x: center.x + cos(angleOfRotation) * circumradius,
                    y: center.y + sin(angleOfRotation) * circumradius
                )
            }

        return Path { path in
            path.addLines(points)
            path.closeSubpath()
        }
    }
}

struct RegularPolygonView_Previews: PreviewProvider {
    static var previews: some View {
        RegularPolygonView(sides: 3)
    }
}
