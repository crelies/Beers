import AdvancedList
import Combine
import SwiftUI

protocol BeerListPresenterProtocol: class {
    var listService: ListService { get }
    func didReceiveEvent(_ event: BeerListEvent)
    func didTriggerAction(_ action: BeerListAction)
}

final class BeerListPresenter: ObservableObject {
    private let dependencies: BeerListPresenterDependenciesProtocol
    private let interactor: BeerListInteractorProtocol
    private var getBeersCancellable: AnyCancellable?
    
    let listService: ListService
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    init(dependencies: BeerListPresenterDependenciesProtocol,
         interactor: BeerListInteractorProtocol) {
        self.dependencies = dependencies
        self.interactor = interactor
        listService = ListService()
    }
}

extension BeerListPresenter: BeerListPresenterProtocol {
    func didReceiveEvent(_ event: BeerListEvent) {
        switch event {
            case .viewAppears:
                getBeersCancellable = interactor.getBeers()
                    .receive(on: RunLoop.main)
                    .sink(receiveCompletion: { completion in
                        debugPrint(completion)
                    }, receiveValue: { beers in
                        let beerViewModels = beers.map { BeerViewModel(beer: $0) }
                        self.listService.appendItems(beerViewModels)
                    })
            case .viewDisappears:
                getBeersCancellable?.cancel()
        }
    }

    func didTriggerAction(_ action: BeerListAction) {

    }
}
