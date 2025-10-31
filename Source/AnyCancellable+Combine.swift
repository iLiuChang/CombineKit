//
//  AnyCancellable+Combine.swift
//  CombineKit
//
//  Created by LC on 2025/10/31.
//

import Combine
import Foundation

private var cancellablesKey: UInt8 = 0

extension CombineKitWrapper where Base: NSObject {
    public var cancellables: Set<AnyCancellable> {
        get {
            if let wrapper = objc_getAssociatedObject(base, &cancellablesKey) as? CancellableWrapper {
                return wrapper.cancellables
            }
            let cancellables = Set<AnyCancellable>()
            base.ck.cancellables = cancellables
            return cancellables
        }
        set {
            let wrapper = CancellableWrapper(cancellables: newValue)
            objc_setAssociatedObject(base, &cancellablesKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension CombineKitWrapper where Base: AnyCancellable {
    public func store(in object: NSObject) {
        base.store(in: &object.ck.cancellables)
    }
}

private class CancellableWrapper {
    let cancellables: Set<AnyCancellable>
    
    init(cancellables: Set<AnyCancellable>) {
        self.cancellables = cancellables
    }
}

