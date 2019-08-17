import AdvancedList
import Combine
import SwiftUI

protocol BeerListPresenterProtocol: class {
    associatedtype PaginationErrorView: View
    associatedtype PaginationLoadingView: View
    
    var listService: ListService { get }
    var pagination: AdvancedListPagination<PaginationErrorView, PaginationLoadingView> { get }
    func didReceiveEvent(_ event: BeerListEvent)
    func didTriggerAction(_ action: BeerListAction)
}

final class BeerListPresenter: ObservableObject {
    private let dependencies: BeerListPresenterDependenciesProtocol
    private var interactor: BeerListInteractorProtocol
    private var getCurrentBeersCancellable: AnyCancellable?
    private var getNextBeersCancellable: AnyCancellable?
    
    let listService: ListService
    private(set) lazy var pagination: AdvancedListPagination<AnyView, TupleView<(Divider, Text)>> = {
        .thresholdItemPagination(errorView: { error in
            AnyView(
                VStack {
                    Text(error.localizedDescription)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    
                    Button(action: {
                        self.getCurrentBeers(isInitialLoading: false)
                    }) {
                        Text("Retry")
                    }.padding()
                }
            )
        }, loadingView: {
            Divider()
            Text("Fetching next beers...")
        }, offset: 20, shouldLoadNextPage: {
            self.loadNextPage()
        }, state: .idle)
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
                getCurrentBeers(isInitialLoading: true)
            case .viewDisappears:
                getCurrentBeersCancellable?.cancel()
                getNextBeersCancellable?.cancel()
                listService.listState = .items
                pagination.state = .idle
        }
    }

    func didTriggerAction(_ action: BeerListAction) {

    }
}

extension BeerListPresenter {
    private func getCurrentBeers(isInitialLoading: Bool) {
        if isInitialLoading {
            listService.listState = .loading
        } else {
            pagination.state = .loading
        }
        
        getCurrentBeersCancellable = interactor.getCurrentBeers()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        if isInitialLoading {
                            self.listService.listState = .error(error)
                        } else {
                            self.pagination.state = .error(error)
                        }
                    case .finished:
                        if isInitialLoading {
                            self.listService.listState = .items
                        } else {
                            self.pagination.state = .idle
                        }
                }
            }, receiveValue: { beers in
                let beerViewModels = beers.map(BeerViewModel.init)
                self.listService.appendItems(beerViewModels)
            })
    }
    
    private func loadNextPage() {
        guard !interactor.allBeersLoaded, pagination.state == .idle else {
            return
        }
        
        pagination.state = .loading
        
        getNextBeersCancellable = interactor.getNextBeers()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        if let interactorError = error as? BeerListInteractorError, interactorError == .allBeersLoaded {
                            self.pagination.state = .idle
                        } else {
                            self.pagination.state = .error(error)
                        }
                    case .finished:
                        self.pagination.state = .idle
                }
            }, receiveValue: { beers in
                // TODO: move this logic to interactor
                self.interactor.allBeersLoaded = beers.count < self.interactor.pageSize
                let beerViewModels = beers.map(BeerViewModel.init)
                self.listService.appendItems(beerViewModels)
            })
    }
}
