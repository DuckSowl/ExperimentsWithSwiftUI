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
    private let rotationAngle: Angle

    // MARK: - Initialization
    /// Creates a regular polygon shape.
    /// - Parameters:
    ///   - sides: Number of polygon sides, have to be more than 3.
    ///   - contentMode: Affects the size and placement of the shape. By default fits given rectangle.
    ///   - rotationAngle: Rotates shape counterclockwise conserving contentMode.
    public init(
        sides: Int,
        contentMode: ContentMode = .fit,
        rotationAngle: Angle = .zero
    ) {
        precondition(
            sides >= 3,
            "Can't create a polygon with less than 3 sides"
        )

        self.sides = sides
        self.contentMode = contentMode
        self.rotationAngle = rotationAngle
    }

    // MARK: - Shape conformance
    public func path(in rect: CGRect) -> Path {
        if contentMode == .circle {
            // Take half the square side length, to fit the polygon in the circle
            let radius = min(rect.width, rect.height) / 2.0
            let center = CGPoint(x: rect.midX, y: rect.midY)
            return pathWith(center: center, radius: radius)
        } else {
            let path = pathWith(center: .zero, radius: 1)
            return path.applying(
                path.boundingRect.transformToFit(in: rect)
            )
        }
    }

    // MARK: - Private methods
    /// Returns regular polygon path with given parameters.
    private func pathWith(center: CGPoint, radius: Double) -> Path {
        let angle = .pi * 2 / Double(sides)
        let rotation = rotationAngle.radians + .pi / 2.0
        let points = (0..<sides)
            .map { Double($0) * angle - rotation }
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
