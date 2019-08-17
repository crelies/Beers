import AdvancedList
import Combine
import SwiftUI

protocol BeerListPresenterProtocol: class {
    associatedtype PaginationLoadingView: View
    
    var listService: ListService { get }
    var pagination: AdvancedListPagination<PaginationLoadingView> { get }
    func didReceiveEvent(_ event: BeerListEvent)
    func didTriggerAction(_ action: BeerListAction)
}

final class BeerListPresenter: ObservableObject {
    private let dependencies: BeerListPresenterDependenciesProtocol
    private let interactor: BeerListInteractorProtocol
    private var getCurrentBeersCancellable: AnyCancellable?
    private var getNextBeersCancellable: AnyCancellable?
    
    let listService: ListService
    private(set) lazy var pagination: AdvancedListPagination<TupleView<(Divider, Text)>> = {
        .thresholdItemPagination(loadingView: {
            Divider()
            Text("Fetching next beers...")
        }, offset: 20, shouldLoadNextPage: {
            self.loadNextPage()
        }, isLoading: false)
    }()
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
                listService.listState = .loading
                
                getCurrentBeersCancellable = interactor.getCurrentBeers()
                    .receive(on: RunLoop.main)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                            case .failure(let error):
                                self.listService.listState = .error(error)
                            case .finished:
                                self.listService.listState = .items
                        }
                    }, receiveValue: { beers in
                        let beerViewModels = beers.map(BeerViewModel.init)
                        self.listService.appendItems(beerViewModels)
                    })
            case .viewDisappears:
                getCurrentBeersCancellable?.cancel()
                getNextBeersCancellable?.cancel()
                listService.listState = .items
                pagination.isLoading = false
        }
    }

    func didTriggerAction(_ action: BeerListAction) {

    }
}

extension BeerListPresenter {
    private func loadNextPage() {
        pagination.isLoading = true
        
        getNextBeersCancellable = interactor.getNextBeers()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                debugPrint(completion)
                self.pagination.isLoading = false
            }, receiveValue: { beers in
                let beerViewModels = beers.map(BeerViewModel.init)
                self.listService.appendItems(beerViewModels)
            })
    }
}
