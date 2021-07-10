
import SwiftUI
import Network
import Combine

public protocol CheckerInternetProtocol {
    // Wrapped value
    var status: NWPath.Status { get }
 
    // (Published property wrapper)
    var statusPublished: Published<NWPath.Status> { get }
 
     // Publisher
    var statusPublisher: Published<NWPath.Status>.Publisher { get }
    
    var store: Set<AnyCancellable> {get set}
    func changeStatus(_ status: NWPath.Status)
}


public class CheckerInternet: ObservableObject, CheckerInternetProtocol{
    
    @Published private(set)  public var status: NWPath.Status = .satisfied
    
    public var statusPublished: Published<NWPath.Status> { _status}
    
    public var statusPublisher: Published<NWPath.Status>.Publisher { $status}
    
    public var store: Set<AnyCancellable> = []
    
    public func changeStatus(_ status: NWPath.Status) {
        self.status = status
    }
    
    public init() {
                NWPathMonitor()
                    .publisher()
                    .map { $0.status }
                    .sink {[weak self] status in
                        guard let self = self  else { return }
                        self.changeStatus(status)
                    }
                    .store(in: &self.store)
        }
    
    deinit {
        print("VM deinit")
    }
}
