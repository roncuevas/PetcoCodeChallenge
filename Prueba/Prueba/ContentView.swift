import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.response, id: \.self) { element in
                    Contact(image: element.pictureURL,
                            name: "\(element.firstName) \(element.lastName)",
                            contactType: .messages)
                }
                .listStyle(.plain)
            }
            .padding()
            .navigationTitle("Favorites")
            .task {
                let url = "https://jserver-api.herokuapp.com/users"
                await viewModel.getData(url)
            }
        }
    }
}


final class ContentViewModel: ObservableObject {
    @Published var response: [ContactInfo] = []

    func getData(_ url: String) async {
        do {
            self.response = try await NetworkManager.shared.getData(url, type: [ContactInfo].self)
        } catch {
            print(error)
        }
    }
}

struct ContactInfo: Codable, Identifiable, Hashable {
    let id: Int
    let firstName: String
    let lastName: String
    let pictureURL: String
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func getData<T: Codable>(_ url: String, type: T.Type) async throws -> T {
        let url = URL(string: url)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        let data = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(type.self, from: data.0)
    }
}

enum ContactType: String {
    case messages = "message.fill"
    case iphone, mobile, work = "phone.fill"

    var text: String {
        switch self {
        case .messages: "Messages"
        case .iphone: "iPhone"
        case .mobile: "Mobile"
        case .work: "Work"
        }
    }
}

