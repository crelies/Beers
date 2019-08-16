import Combine

protocol BeerListInteractorProtocol {
	func getBeers() -> AnyPublisher<[Beer], Error>
}

final class BeerListInteractor {
    private let dependencies: BeerListInteractorDependenciesProtocol
    
    init(dependencies: BeerListInteractorDependenciesProtocol) {
        self.dependencies = dependencies
    }
}

extension BeerListInteractor: BeerListInteractorProtocol {
    func getBeers() -> AnyPublisher<[Beer], Error> {
        return dependencies.beerAPIService.publisher
    }
}
