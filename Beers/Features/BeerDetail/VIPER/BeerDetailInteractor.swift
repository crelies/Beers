import Foundation

protocol BeerDetailInteractorProtocol {
	
}

final class BeerDetailInteractor {
    private let dependencies: BeerDetailInteractorDependenciesProtocol
    
    init(dependencies: BeerDetailInteractorDependenciesProtocol) {
        self.dependencies = dependencies
    }
}

extension BeerDetailInteractor: BeerDetailInteractorProtocol {
	
}
