//
//  ServiceCheckerViewModel.swift
//  CheckerNetwor
//
//  Created by slava on 09/07/2021.
//

import SwiftUI
import Network
import Combine


public class ViewModelCheckerInternet: ObservableObject {
    //
    @Published public var status: NWPath.Status = .satisfied
    public var checkerInternet: CheckerInternetProtocol
    public var cancellableTimer: Cancellable?
    public var cancellableCheckIntermet: Cancellable?
    
    public init(checkerInternet: CheckerInternetProtocol) {
        self.checkerInternet = checkerInternet
        cancellableTimer = Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .sink() { [weak self] _ in
                guard let self = self  else { return }
                self.cancellableCheckIntermet = checkerInternet
                    .statusPublisher
                    .receive(on: RunLoop.main)
                    .sink(receiveValue: { [weak self] status in
                        self?.status = status
            })
        }
    }
}
