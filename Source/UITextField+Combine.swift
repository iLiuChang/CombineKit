//
//  UITextField+Combine.swift
//  CombineKit
//
//  Created by LC on 2025/10/30.
//

import Combine
import UIKit

public extension CombineKitWrapper where Base: UITextField {
    var textPublisher: AnyPublisher<String?, Never> {
        Publishers.Merge(
            UIControlPropertyPublisher(control: base, events: .allEditingEvents, keyPath: \.text),
            
            base.publisher(for: \.text)
        )
        .eraseToAnyPublisher()
    }

    var attributedTextPublisher: AnyPublisher<NSAttributedString?, Never> {
        Publishers.Merge(
            UIControlPropertyPublisher(control: base, events: .allEditingEvents, keyPath: \.attributedText),

            base.publisher(for: \.attributedText)
        )
        .eraseToAnyPublisher()
    }

}
