    import XCTest
    import Combine
    import Network
    @testable import InternetChecker

    final class InternetCheckerTests: XCTestCase {
        func testExample() {
        }
    }

    class CheckerInternetTest: XCTestCase {
        private var cancellables: Set<AnyCancellable>!

        override func setUp() {
            super.setUp()
            cancellables = []
        }

        func testPublisher() {
            let chekerInternet = NWPathMonitor()
        
            var statusMonitor: NWPath.Status = .satisfied
            var error: Error?
       
            // Setting up our Combine pipeline:
            chekerInternet
                .publisher()
                .map { $0.status }
                .sink(receiveCompletion: { result in
                    
                    switch result {
                    case .finished :
                        break
                    case .failure(let error1):
                        error = error1
                    }
                    
                }, receiveValue: { status in
                    statusMonitor = status
                })

                .store(in: &cancellables)
            

            // Asserting that our Combine pipeline yielded the
            XCTAssertNil(error)
            XCTAssertEqual(.satisfied, statusMonitor)
        }
    }

