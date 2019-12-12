import RemoteImage
import SwiftUI

protocol BeerDetailViewProtocol: BeerDetailProtocol {
    
}

struct BeerDetailView: View {
    private let presenter = BeerDetailWireframe.makePresenter()

    let beer: Beer
    weak var delegate: BeerDetailDelegateProtocol?
    
    var body: some View {
        VStack(spacing: 8) {
            Text(beer.description)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .font(.body)

            beer.firstBrewed.map { firstBrewed in
                Text("First brewed on: \(firstBrewed, formatter: BeerAPIService.formatter)")
                    .font(.footnote)
            }

            beer.imageURL.map { imageURL in
                RemoteImage(type: .url(imageURL), errorView: { error in
                    Text(error.localizedDescription)
                }, imageView: { image in
                    image
                        .resizable()
                        .aspectRatio(0.25, contentMode: .fit)
                }) {
                    Text("Loading image...")
                }
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
