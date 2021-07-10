//
//  ServiceChekerCombine.swift
//  CheckerNetwor
//
//  Created by slava on 09/07/2021.
//

import Combine
import Foundation
import Network

extension NWPathMonitor {
   public func publisher(queue: DispatchQueue = DispatchQueue.main) -> NWPathMonitor.Publisher {
        Publisher(monitor: self, queue: queue)
    }
    
    public class Subscription<S: Subscriber>: Combine.Subscription where S.Input == NWPath {
        private let subscriber: S
        private let monitor: NWPathMonitor
        private let queue: DispatchQueue
        private var isStarted = false
        
        init(subscriber: S, monitor: NWPathMonitor, queue: DispatchQueue) {
            self.subscriber = subscriber
            self.monitor = monitor
            self.queue = queue
        }

        public func request(_ demand: Subscribers.Demand) {
            precondition(demand == .unlimited, "This subscription is only supported to `Demand.unlimited`.")
            
            guard !isStarted else { return }
            isStarted = true
            
            monitor.pathUpdateHandler = { [unowned self] path in
                _ = self.subscriber.receive(path)
            }
            monitor.start(queue: queue)
        }
        
        public func cancel() {
            monitor.cancel()
        }
    }
    
    public struct Publisher: Combine.Publisher {
        public typealias Output = NWPath
        public typealias Failure = Never
        
        private let monitor: NWPathMonitor
        private let queue: DispatchQueue
        
        init(monitor: NWPathMonitor, queue: DispatchQueue) {
            self.monitor = monitor
            self.queue = queue
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = Subscription(subscriber: subscriber, monitor: monitor, queue: queue)
            subscriber.receive(subscription: subscription)
        }
    }
}
