import Combine

protocol BeerListInteractorProtocol {
    func getCurrentBeers() -> AnyPublisher<[Beer], Error>
	func getNextBeers() -> AnyPublisher<[Beer], Error>
}

final class BeerListInteractor {
    private let dependencies: BeerListInteractorDependenciesProtocol
    private var page: Int
    private let pageSize: Int
    
    init(dependencies: BeerListInteractorDependenciesProtocol) {
        self.dependencies = dependencies
        page = 1
        pageSize = 50
    }
}

extension BeerListInteractor: BeerListInteractorProtocol {
    func getCurrentBeers() -> AnyPublisher<[Beer], Error> {
        return dependencies.beerAPIService.getBeers(page: page,
                                                    pageSize: pageSize)
    }
    
    func getNextBeers() -> AnyPublisher<[Beer], Error> {
        page += 1
        return dependencies.beerAPIService.getBeers(page: page,
                                                    pageSize: pageSize)
    }
}
