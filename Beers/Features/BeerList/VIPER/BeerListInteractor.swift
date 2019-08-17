import Combine

protocol BeerListInteractorProtocol {
    var pageSize: Int { get }
    var allBeersLoaded: Bool { get set }
    func getCurrentBeers() -> AnyPublisher<[Beer], Error>
	func getNextBeers() -> AnyPublisher<[Beer], Error>
}

final class BeerListInteractor {
    private let dependencies: BeerListInteractorDependenciesProtocol
    private var page: Int
    
    let pageSize: Int
    var allBeersLoaded: Bool
    
    init(dependencies: BeerListInteractorDependenciesProtocol) {
        self.dependencies = dependencies
        page = 1
        pageSize = 50
        allBeersLoaded = false
    }
}

extension BeerListInteractor: BeerListInteractorProtocol {
    func getCurrentBeers() -> AnyPublisher<[Beer], Error> {
        return dependencies.beerAPIService.getBeers(page: page,
                                                    pageSize: pageSize)
    }
    
    func getNextBeers() -> AnyPublisher<[Beer], Error> {
        guard !allBeersLoaded else {
            return Fail(outputType: [Beer].self,
                        failure: BeerListInteractorError.allBeersLoaded).eraseToAnyPublisher()
        }
        
        page += 1
        return dependencies.beerAPIService.getBeers(page: page,
                                                    pageSize: pageSize)
    }
}
