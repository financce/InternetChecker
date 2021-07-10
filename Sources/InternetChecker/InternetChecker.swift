
import SwiftUI
import Network
import Combine

protocol CheckerInternetProtocol {
    // Wrapped value
    var status: NWPath.Status { get }
 
    // (Published property wrapper)
    var statusPublished: Published<NWPath.Status> { get }
 
     // Publisher
    var statusPublisher: Published<NWPath.Status>.Publisher { get }
    
    var store: Set<AnyCancellable> {get set}
    func changeStatus(_ status: NWPath.Status)
}


final class CheckerInternet: ObservableObject, CheckerInternetProtocol{
    
    @Published private(set)  var status: NWPath.Status = .satisfied
    
    var statusPublished: Published<NWPath.Status> { _status}
    
    var statusPublisher: Published<NWPath.Status>.Publisher { $status}
    
    var store: Set<AnyCancellable> = []
    
    func changeStatus(_ status: NWPath.Status) {
        self.status = status
    }
    
    init() {
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
