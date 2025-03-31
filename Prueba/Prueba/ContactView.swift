import SwiftUI

struct Contact: View {
    @State var image: String
    @State var name: String
    @State var contactType: ContactType

    var body: some View {
        HStack {
            if let url = URL(string: image) {
                AsyncImage(url: url)
            }
            VStack {
                Text(name)
                HStack {
                    Image(systemName: contactType.rawValue)
                        .padding(.trailing, 1)
                    Text(contactType.text)
                }
            }
            Spacer()
            Image(systemName: "info.circle")
        }
    }
}
