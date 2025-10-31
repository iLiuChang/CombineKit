//
//  UIControlPropertyPublisher.swift
//  CombineKit
//
//  Created by LC on 2025/10/30.
//

import Combine
import Foundation
import UIKit

public struct UIControlPropertyPublisher<Control: UIControl, Value>: Publisher {
    public typealias Output = Value
    public typealias Failure = Never
    
    private let control: Control
    private let controlEvents: Control.Event
    private let keyPath: KeyPath<Control, Value>
    
    /// Initialize a publisher that emits the value at the specified keypath
    /// whenever any of the provided Control Events trigger.
    ///
    /// - parameter control: UI Control.
    /// - parameter events: Control Events.
    /// - parameter keyPath: A Key Path from the UI Control to the requested value.
    public init(control: Control,
                events: Control.Event,
                keyPath: KeyPath<Control, Value>) {
        self.control = control
        self.controlEvents = events
        self.keyPath = keyPath
    }
    
    public func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
        let subscription = Subscription(subscriber: subscriber,
                                        control: control,
                                        event: controlEvents,
                                        keyPath: keyPath)
        
        subscriber.receive(subscription: subscription)
    }
}

extension UIControlPropertyPublisher {
    private final class Subscription<S: Subscriber, C: UIControl, V>: Combine.Subscription where S.Input == V {
        private var subscriber: S?
        weak private var control: C?
        let keyPath: KeyPath<C, V>
        private var didEmitInitial = false
        private let event: C.Event

        init(subscriber: S, control: C, event: C.Event, keyPath: KeyPath<C, V>) {
            self.subscriber = subscriber
            self.control = control
            self.keyPath = keyPath
            self.event = event
            control.addTarget(self, action: #selector(processControlEvent), for: event)
        }

        func request(_ demand: Subscribers.Demand) {
            // Emit initial value upon first demand request
            if !didEmitInitial,
                demand > .none,
                let control = control,
                let subscriber = subscriber {
                _ = subscriber.receive(control[keyPath: keyPath])
                didEmitInitial = true
            }
        }

        func cancel() {
            control?.removeTarget(self, action: #selector(processControlEvent), for: event)
            subscriber = nil
        }

        @objc private func processControlEvent() {
            guard let control = control else { return }
            _ = subscriber?.receive(control[keyPath: keyPath])
        }
    }
}
