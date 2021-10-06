//
//  ShapeOffsetViewModifier.swift
//
//
//  Created by Anton Tolstov on 06.10.2021.
//

import SwiftUI

// TODO: - Add documentation
// TODO: - Add View extension
struct ShapeOffsetViewModifier<OffsetShape: Shape>: AnimatableModifier {
    // MARK: - Private properties
    private var offsetFraction: Double
    private let shape: OffsetShape

    // MARK: - Animatable conformance
    var animatableData: CGFloat {
        get { offsetFraction }
        set { offsetFraction = newValue }
    }

    // MARK: - Initialization
    init(offsetFraction: Double, @ViewBuilder in shape: () -> OffsetShape) {
        self.shape = shape()
        self.offsetFraction = offsetFraction
    }

    // MARK: - ViewModifier conformance
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            let offset = offset(with: geometry)
            content.offset(offset)
        }
    }

    // MARK: - Private methods
    private func offset(with geometry: GeometryProxy) -> CGSize {
        let rect = CGRect(origin: .zero, size: geometry.size)
        var path = shape.path(in: rect)
        if offsetFraction != 0 {
            path = path.trimmedPath(from: 0, to: offsetFraction)
        }
        return path.currentPoint.flatMap {
            CGSize(width: $0.x, height: $0.y)
        } ?? .zero
    }
}
