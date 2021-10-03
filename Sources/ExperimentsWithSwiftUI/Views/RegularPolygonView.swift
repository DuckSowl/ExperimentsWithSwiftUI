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
        precondition(
            sides >= 3,
            "Can't create a polygon with less than 3 sides"
        )

        self.sides = sides
        self.contentMode = contentMode
    }

    // MARK: - Shape conformance
    public func path(in rect: CGRect) -> Path {
        if contentMode == .circle {
            return circlePath(in: rect)
        } else {
            return fitPath(in: rect)
        }
    }

    // MARK: - Private methods
    /// Path that fits regular polygon in circle inside the given rect.
    private func circlePath(in rect: CGRect) -> Path {
        let angle = .pi * 2.0 / Double(sides)
        // Take half the square side length, to fit the polygon in the circle
        let radius = min(rect.width, rect.height) / 2.0
        let center = CGPoint(x: rect.midX, y: rect.midY)

        let points = (0..<sides)
            .map { Double($0) * angle - .pi / 2 }
            .map { angleOfRotation -> CGPoint in
                CGPoint(
                    x: center.x + cos(angleOfRotation) * radius,
                    y: center.y + sin(angleOfRotation) * radius
                )
            }

        return Path { path in
            path.addLines(points)
            path.closeSubpath()
        }
    }

    /// Path that fits regular polygon in the given rect.
    private func fitPath(in rect: CGRect) -> Path {
        let angle = .pi * 2 / Double(sides)
        let points = (0..<sides)
            .map { Double($0) * angle - .pi / 2 }
            .map { angleOfRotation -> CGPoint in
                CGPoint(x: cos(angleOfRotation), y: sin(angleOfRotation))
            }

        let path = Path { path in
            path.addLines(points)
            path.closeSubpath()
        }

        return path.applying(
            path.boundingRect.transformToFit(in: rect)
        )
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
        HStack {
            VStack {
                ForEach(3..<8) {
                    RegularPolygonView(sides: $0)
                        .stroke(lineWidth: 1)
                }
            }

            VStack {
                ForEach(3..<8) {
                    RegularPolygonView(sides: $0, contentMode: .circle)
                        .background(Circle().foregroundColor(.secondary))
                }
            }
        }
    }
}
