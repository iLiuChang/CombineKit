//
//  UIView+Combine.swift
//  CombineKit
//
//  Created by LC on 2025/10/31.
//

import Combine
import UIKit

public extension CombineKitWrapper where Base: UIView {
    /// Tap
    var tapPublisher: AnyPublisher<UITapGestureRecognizer, Never> {
        gesturePublisher(for: UITapGestureRecognizer.self)
    }
    
    /// Long Press
    var longPressPublisher: AnyPublisher<UILongPressGestureRecognizer, Never> {
        gesturePublisher(for: UILongPressGestureRecognizer.self)
    }
    
    /// Pan
    var panPublisher: AnyPublisher<UIPanGestureRecognizer, Never> {
        gesturePublisher(for: UIPanGestureRecognizer.self)
    }
    
    /// Swipe
    var swipePublisher: AnyPublisher<UISwipeGestureRecognizer, Never> {
        gesturePublisher(for: UISwipeGestureRecognizer.self)
    }
    
    /// Pinch
    var pinchPublisher: AnyPublisher<UIPinchGestureRecognizer, Never> {
        gesturePublisher(for: UIPinchGestureRecognizer.self)
    }
    
    /// Rotation
    var rotationPublisher: AnyPublisher<UIRotationGestureRecognizer, Never> {
        gesturePublisher(for: UIRotationGestureRecognizer.self)
    }
    
    /// A generic function which returns the provided publisher whenever its specific event occurs
    func gesturePublisher<T: UIGestureRecognizer>(
        for gestureType: T.Type,
        configure: @escaping (T) -> Void = { _ in }
    ) -> AnyPublisher<T, Never> {
        UIGesturePublisher<T>(view: base, configure: configure)
            .eraseToAnyPublisher()
    }
}
