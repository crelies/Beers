import Foundation

protocol BeerListInteractorDependenciesProtocol: BeerAPIServiceProvider {
    
}

struct BeerListInteractorDependencies: BeerListInteractorDependenciesProtocol {
    let beerAPIService: BeerAPIServiceProtocol
    
    init() {
        beerAPIService = BeerAPIService()
    }
}
