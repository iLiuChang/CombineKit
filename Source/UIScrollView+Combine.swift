//
//  UIScrollView+Combine.swift
//  CombineKit
//
//  Created by LC on 2025/10/30.
//

import UIKit
import Combine

public extension CombineKitWrapper where Base: UIScrollView {
    var contentOffsetPublisher: AnyPublisher<CGPoint, Never> {
        base.publisher(for: \.contentOffset)
            .eraseToAnyPublisher()
    }
    
    func reachedBottomPublisher(offset: CGFloat = 0) -> AnyPublisher<Void, Never> {
        contentOffsetPublisher
            .map { [weak base] contentOffset -> Bool in
                guard let self = base else { return false }
                let visibleHeight = self.frame.height - self.contentInset.top - self.contentInset.bottom
                let yDelta = contentOffset.y + self.contentInset.top
                let threshold = max(offset, self.contentSize.height - visibleHeight)
                return yDelta > threshold
            }
            .removeDuplicates()
            .filter { $0 }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
