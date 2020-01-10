import SwiftUI

let url = URL(string: "https://jsonplaceholder.typicode.com/comments")!

struct Comment: Identifiable, Codable {
    var id: Int
    let email: String
    let body: String
}

struct ContentView: View {
    
    @State var comments = [Comment]()
    
    var body: some View {
        List(comments, rowContent: { comment in
            VStack {
                HStack {
                    Text("\(comment.id)")
                    Spacer()
                    Text(comment.email)
                }
                Text(comment.body)
            }
        }).onAppear(perform: {
            self.downloadComments(completion: { self.comments = $0 })
        })
    }
    
    func downloadComments(completion: @escaping ([Comment]) -> Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
            guard let data = data else { return }
            guard let comments = try? JSONDecoder().decode([Comment].self, from: data) else { return }
            completion(comments)
            
        })
        task.resume()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
