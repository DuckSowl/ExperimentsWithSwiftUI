//
//  DoubleShape.swift
//
//
//  Created by Anton Tolstov on 05.10.2021.
//

import SwiftUI

/// Shape that doubles another shape's path.
public struct DoubleShape<Content: Shape>: Shape {
    // MARK: - Private properties
    private let shape: Content

    // MARK: - Initialization
    /// Creates a shape by doubling path of another shape.
    public init(@ViewBuilder shape: () -> Content) {
        self.shape = shape()
    }

    // MARK: - Shape conformance
    public func path(in rect: CGRect) -> Path {
        var path = shape.path(in: rect)
        path.addPath(path)
        return path
    }
}
