//
//  CombineKit.swift
//  CombineKit
//
//  Created by LC on 2025/10/30.
//

import UIKit
import Combine
public struct CombineKitWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol CombineKitCompatible: AnyObject { }

public protocol CombineKitCompatibleValue {}

extension CombineKitCompatible {
    public var ck: CombineKitWrapper<Self> {
        get { return CombineKitWrapper(self) }
        set { }
    }
}

extension CombineKitCompatibleValue {
    public var ck: CombineKitWrapper<Self> {
        get { return CombineKitWrapper(self) }
        set { }
    }
}

extension NSObject: CombineKitCompatible { }
extension AnyCancellable: CombineKitCompatibleValue { }


