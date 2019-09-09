import Foundation

protocol BeerListWireframeProtocol {
    static func makePresenter() -> BeerListPresenter
}

struct BeerListWireframe: BeerListWireframeProtocol {
    static func makePresenter() -> BeerListPresenter {
        let interactorDependencies = BeerListInteractorDependencies()
        let interactor = BeerListInteractor(dependencies: interactorDependencies)

        let presenterDependencies = BeerListPresenterDependencies()
        let presenter = BeerListPresenter(dependencies: presenterDependencies,
                                          interactor: interactor)
        return presenter
    }
}
