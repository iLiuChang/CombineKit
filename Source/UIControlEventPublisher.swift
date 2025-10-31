//
//  UIControlEventPublisher.swift
//  CombineKit
//
//  Created by LC on 2025/10/30.
//

import Combine
import Foundation
import UIKit

public struct UIControlEventPublisher<Control: UIControl>: Publisher {
    public typealias Output = Void
    public typealias Failure = Never

    private let control: Control
    private let controlEvents: Control.Event

    /// Initialize a publisher that emits a Void
    /// whenever any of the provided Control Events trigger.
    ///
    /// - parameter control: UI Control.
    /// - parameter events: Control Events.
    public init(control: Control,
                events: Control.Event) {
        self.control = control
        self.controlEvents = events
    }

    public func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
        let subscription = Subscription(subscriber: subscriber,
                                        control: control,
                                        event: controlEvents)

        subscriber.receive(subscription: subscription)
    }
}

extension UIControlEventPublisher {
    private final class Subscription<S: Subscriber, C: UIControl>: Combine.Subscription where S.Input == Void {
        private var subscriber: S?
        weak private var control: C?

        init(subscriber: S, control: C, event: C.Event) {
            self.subscriber = subscriber
            self.control = control
            control.addTarget(self, action: #selector(processControlEvent), for: event)
        }

        func request(_ demand: Subscribers.Demand) { }

        func cancel() {
            subscriber = nil
        }

        @objc private func processControlEvent() {
            _ = subscriber?.receive()
        }
    }
}
