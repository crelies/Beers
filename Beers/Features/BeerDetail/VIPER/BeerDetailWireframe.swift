import Foundation

protocol BeerDetailWireframeProtocol {
    static func makePresenter() -> BeerDetailPresenter
}

struct BeerDetailWireframe: BeerDetailWireframeProtocol {
    static func makePresenter() -> BeerDetailPresenter {
        let interactorDependencies = BeerDetailInteractorDependencies()
        let interactor = BeerDetailInteractor(dependencies: interactorDependencies)

        let presenterDependencies = BeerDetailPresenterDependencies()
        let presenter = BeerDetailPresenter(dependencies: presenterDependencies,
                                                               interactor: interactor)
        return presenter
    }
}
