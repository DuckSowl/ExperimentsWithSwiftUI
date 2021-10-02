//
//  RegularPolygonView.swift
//
//
//  Created by Anton Tolstov on 01.10.2021.
//

import SwiftUI

/// Regular polygon shape with given number of sides.
public struct RegularPolygonView: Shape {
    // MARK: - Private properties
    private let sides: Int
    private let contentMode: ContentMode

    // MARK: - Initialization
    /// Creates a regular polygon shape.
    /// - Parameters:
    ///   - sides: Number of polygon sides, have to be more than 3.
    ///   - contentMode: Affects the size and placement of the shape. By default fits given rectangle.
    public init(sides: Int, contentMode: ContentMode = .fit) {
        self.sides = sides
        self.contentMode = contentMode
    }

    // MARK: - Shape conformance
    public func path(in rect: CGRect) -> Path {
        let angle = .pi * 2.0 / Double(sides)
        let size = rect.size
        let circumradius = circumradius(with: size)
        let center = CGPoint(
            x: size.width / 2.0,
            y: contentMode == .fit ? circumradius : size.height / 2.0
        )

        let points = (0..<sides)
            .map { Double($0) * angle - .pi / 2 }
            .map { angleOfRotation -> CGPoint in
                CGPoint(
                    x: center.x + cos(angleOfRotation) * circumradius,
                    y: center.y + sin(angleOfRotation) * circumradius
                )
            }

        return path(in: rect, with: points)
    }

    // MARK: - Private methods
    /// Returns circumradius for the polygon.
    private func circumradius(with size: CGSize) -> Double {
        if contentMode == .fit {
            // Find radius so the polygon will fill the rect height
            guard sides.isMultiple(of: 2) else {
                // Add (radius - apothem) to the radius of the odd sided polygon
                return size.height / (cos(.pi / Double(sides)) + 1)
            }

            // Or take half the height for the even sided polygon
            return size.height / 2.0
        }

        // Take half the square side length, to fit the polygon in the circle
        return min(size.width, size.height) / 2.0
    }

    /// Creates the path with given points.
    private func path(in rect: CGRect, with points: [CGPoint]) -> Path {
        let path = Path { path in
            path.addLines(points)
            path.closeSubpath()
        }

        if contentMode == .fit {
            return path.applying(
                // Scale exessive width, conserving polygon center
                .centeredScaleBy(
                    min(1, rect.width / path.boundingRect.width),
                    width: rect.width,
                    height: rect.height
                )
            )
        }

        return path
    }

    // MARK: - Public models
    /// Fitting of the polygon.
    public enum ContentMode {
        /// Fit polygon in the circle.
        case circle
        /// Fit polygon in the given rectangle.
        case fit
    }
}

struct RegularPolygonView_Previews: PreviewProvider {
    static var previews: some View {
        RegularPolygonView(sides: 3)
    }
}
