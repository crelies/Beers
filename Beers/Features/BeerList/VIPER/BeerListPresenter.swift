import AdvancedList
import Combine
import SwiftUI

protocol BeerListPresenterProtocol: class {
    associatedtype PaginationErrorView: View
    associatedtype PaginationLoadingView: View

    var pagination: AdvancedListPagination<PaginationErrorView, PaginationLoadingView> { get }
    
    func didReceiveEvent(_ event: BeerListEvent)
    func didTriggerAction(_ action: BeerListAction)
}

final class BeerListPresenter: NSObject, ObservableObject {
    private let dependencies: BeerListPresenterDependenciesProtocol
    private var interactor: BeerListInteractorProtocol
    private var getCurrentBeersCancellable: AnyCancellable?
    private var getNextBeersCancellable: AnyCancellable?

    @Published private(set) var beerViewModels: [BeerViewModel] = []
    @Published var listState: ListState = .items

    private(set) lazy var pagination: AdvancedListPagination<AnyView, AnyView> = {
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
            AnyView(
                VStack {
                    Divider()
                    Text("Fetching next beers...")
                }
            )
        }, offset: 20, shouldLoadNextPage: {
            self.loadNextPage()
        }, state: .idle)
    }()
    
    init(dependencies: BeerListPresenterDependenciesProtocol,
         interactor: BeerListInteractorProtocol) {
        self.dependencies = dependencies
        self.interactor = interactor
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
                listState = .items
                pagination.state = .idle
        }
    }

    func didTriggerAction(_ action: BeerListAction) {
        switch action {
            case .retry:
                getCurrentBeers(isInitialLoading: true)
        }
    }
}

extension BeerListPresenter {
    private func getCurrentBeers(isInitialLoading: Bool) {
        if isInitialLoading {
            listState = .loading
        } else {
            pagination.state = .loading
        }
        
        getCurrentBeersCancellable = interactor.getCurrentBeers()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        if isInitialLoading {
                            self.listState = .error(error)
                        } else {
                            self.pagination.state = .error(error)
                        }
                    case .finished:
                        if isInitialLoading {
                            self.listState = .items
                        } else {
                            self.pagination.state = .idle
                        }
                }
            }, receiveValue: { beers in
                let beerViewModels = beers.map(BeerViewModel.init)
                self.beerViewModels.append(contentsOf: beerViewModels)
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
                self.beerViewModels.append(contentsOf: beerViewModels)
            })
    }
}
