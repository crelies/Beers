import RemoteImage
import SwiftUI

protocol BeerDetailViewProtocol: BeerDetailProtocol {
    
}

struct BeerDetailView: View {
    @ObservedObject private var presenter = BeerDetailWireframe.makePresenter()
    
    let beer: Beer
    weak var delegate: BeerDetailDelegateProtocol?
    
    var body: some View {
        VStack {
            Section {
                VStack(alignment: .leading) {
                    Text(beer.description)
                        // TODO: not working
                        .lineLimit(nil)
                        .font(.body)
                    // TODO: handle nil values
                    Text("First brewed on: \(beer.firstBrewed ?? Date(), formatter: BeerAPIService.formatter)")
                        .font(.footnote)
                }.padding(.horizontal)
            }
            
            Section {
                // TODO: optimize
                if beer.imageURL != nil {
                    RemoteImage(url: beer.imageURL!, errorView: { error in
                        Text(error.localizedDescription)
                    }, imageView: { image in
                        image
                            .resizable()
                            .aspectRatio(0.25, contentMode: .fit)
                    }) {
                        Text("Loading image...")
                    }
                } else {
                    Text("No image available")
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
