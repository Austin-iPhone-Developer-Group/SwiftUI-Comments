import SwiftUI
import Combine

let url = URL(string: "https://jsonplaceholder.typicode.com/comments")!

struct Comment: Identifiable, Codable {
    let id: Int
    let email: String
    let body: String
}

class ViewModel: ObservableObject {
    
   @Published var comments = [Comment]()
    var binding: AnyCancellable?
    
    init() {
        binding = URLSession.shared.dataTaskPublisher(for: url)
        .map { $0.data }
        .decode(type: [Comment].self, decoder: JSONDecoder())
        .assertNoFailure()
        .receive(on: DispatchQueue.main)
        .assign(to: \.comments, on: self)
    }
    
}

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
        
    var body: some View {
        List(viewModel.comments, rowContent: { comment in
            VStack {
                HStack {
                    Text("\(comment.id)")
                    Spacer()
                    Text(comment.email)
                }
                Text(comment.body)
            }
        })
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
