import RemoteImage
import SwiftUI

protocol BeerDetailViewProtocol: BeerDetailProtocol {
    
}

struct BeerDetailView: View {
    private let presenter = BeerDetailWireframe.makePresenter()
    #if targetEnvironment(macCatalyst)
    private let remoteImageService = RemoteImageService()
    #endif
    
    let beer: Beer
    weak var delegate: BeerDetailDelegateProtocol?
    
    var body: some View {
        VStack(spacing: 8) {
            Text(beer.description)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .font(.body)
            
            // TODO: optimize
            if beer.firstBrewed != nil {
                Text("First brewed on: \(beer.firstBrewed!, formatter: BeerAPIService.formatter)")
                    .font(.footnote)
            }
            
            // TODO: optimize
            if beer.imageURL != nil {
                #if !targetEnvironment(macCatalyst)
                    RemoteImage(url: beer.imageURL!, errorView: { error in
                        Text(error.localizedDescription)
                    }, imageView: { image in
                        image
                            .resizable()
                            .aspectRatio(0.25, contentMode: .fit)
                    }) {
                        Text("Loading image...")
                    }
                #else
                    RemoteImage(url: beer.imageURL!, errorView: { error in
                        Text(error.localizedDescription)
                    }, imageView: { image in
                        image
                            .resizable()
                            .aspectRatio(0.25, contentMode: .fit)
                    }) {
                        Text("Loading image...")
                    }
                    .environmentObject(remoteImageService)
                #endif
            }
        }
        .navigationBarTitle(Text(beer.name), displayMode: .inline)
        .onAppear {
            self.presenter.didReceiveEvent(.viewAppears)
        }
    }
}

extension BeerDetailView: BeerDetailViewProtocol {
    
}

extension BeerDetailView: BeerDetailProtocol {
    
}

#if DEBUG
struct BeerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let beer = MockBeerStore().beers.randomElement()!
        return NavigationView {
            BeerDetailView(beer: beer, delegate: nil)
        }
    }
}
#endif
