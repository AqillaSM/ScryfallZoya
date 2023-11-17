import SwiftUI

struct MTGCardView: View {
    var card: MTGCard
    
    var body: some View {
        NavigationLink(destination: DetailMTGCardView(card: card)) {
            VStack {
                // Display card image
                AsyncImage(url: URL(string: card.image_uris?.large ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit) // Menambahkan aspectRatio
                            .frame(width: 150, height: 200) // Menetapkan lebar dan tinggi kartu
                    case .failure:
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 200)
                            .foregroundColor(.red)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        ProgressView()
                    }
                }
                .padding()

                // Display card name with smaller font size
                Text(card.name)
                    .font(.headline) // Adjust the font size as needed
                    .foregroundColor(.black)
                    .padding()
            }

        }
        
    }
    
}

struct DetailMTGCardView: View {
    @State private var isZoomed = false
    var card: MTGCard

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Display larger card image in the detail view
                    AsyncImage(url: URL(string: card.image_uris?.large ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: isZoomed ? nil : 300)
                                .cornerRadius(16) // Rounded corners
                                .shadow(radius: 5) // Shadow effect
                                .onTapGesture {
                                    // Handle tap gesture to show pop-up
                                    isZoomed.toggle()
                                }
                        case .failure:
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: isZoomed ? nil : 300)
                                .foregroundColor(.red)
                                .cornerRadius(16) // Rounded corners
                                .shadow(radius: 5) // Shadow effect
                                .onTapGesture {
                                    // Handle tap gesture to show pop-up
                                    isZoomed.toggle()
                                }
                        case .empty:
                            ProgressView()
                        @unknown default:
                            ProgressView()
                        }
                    }
                    .padding()

                    // Display all card data
                    VStack(alignment: .leading, spacing: 12) {
                        Text("\(card.name)")
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 8)
                        
                        let replacedText = (card.mana_cost)
                            .replacingOccurrences(of: "{U}", with: " 💧 ")
                            .replacingOccurrences(of: "\"{T}", with: " ↩️ ")
                            .replacingOccurrences(of: "{B}", with: " 💀 ")
                            .replacingOccurrences(of: "{W/B}", with: " ☀️ ")
                            .replacingOccurrences(of: "{1}", with: " 1️⃣ ")
                            .replacingOccurrences(of: "{2}", with: " 2️⃣ ")
                            .replacingOccurrences(of: "{3}", with: " 3️⃣ ")
                            .replacingOccurrences(of: "{4}", with: " 4️⃣ ")
                            .replacingOccurrences(of: "{5}", with: " 5️⃣ ")
                            .replacingOccurrences(of: "{6}", with: " 6️⃣ ")
                            .replacingOccurrences(of: "{7}", with: " 7️⃣ ")
                            .replacingOccurrences(of: "{8}", with: " 8️⃣ ")
                            .replacingOccurrences(of: "{9}", with: " 9️⃣ ")
                            .replacingOccurrences(of: "{0}", with: " 0️⃣ ")
                            .replacingOccurrences(of: "{R}", with: " 🔥 ")
                            .replacingOccurrences(of: "{G}", with: " 🌲 ")
                            .replacingOccurrences(of: "{W}", with: " ☀️ ")
                        Text(replacedText) // Directly using card.mana_cost
                            .font(.subheadline)
                            .padding(4)
                            .background(Color.white)
                            .foregroundColor(.white)
                            .cornerRadius(4)

                        // Type Line section with border
                        TypeSection(title: "Type", content: card.type_line)

                        // Oracle Text section with border
                        OracleTextSection(title: "Oracle Text", content: card.oracle_text)

                        // Legalities section
                        Text("Legality:")
                            .font(.headline)
                        LegalitiesView(legalities: card.legalities)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 5)
                    .padding(.top, 20)

                    // Spacer to ensure content is at the top
                    Spacer()
                }
            }
            .fullScreenCover(isPresented: $isZoomed) {
                // Pop-up view to show the larger image
                ZStack {
                    Color.white
                        .ignoresSafeArea()

                    AsyncImage(url: URL(string: card.image_uris?.large ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(16) // Rounded corners
                                .shadow(radius: 5) // Shadow effect
                        case .failure:
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.red)
                                .cornerRadius(16) // Rounded corners
                                .shadow(radius: 5) // Shadow effect
                        case .empty:
                            ProgressView()
                        @unknown default:
                            ProgressView()
                        }
                    }
                    .padding()
                    .onTapGesture {
                        // Handle tap to close the pop-up
                        isZoomed.toggle()
                    }
                }
            }
            .navigationBarHidden(true)
            .padding(.top, -16)
        }
    }
}

struct TypeSection: View {
    var title: String
    var content: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(content)
                .font(.headline) // Make the font bold
                .padding()
                .background(Color.white)
                .cornerRadius(8)
        }
        .foregroundColor(.black)
        .padding(.vertical, 8)
    }
}


struct OracleTextSection: View {
    var title: String
    var content: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.leading, 4)

            parseOracleText(content)
                .multilineTextAlignment(.leading)
                .padding()
                .background(Color(.systemGray6)) // Use system gray color
                .cornerRadius(8)
        }
        .foregroundColor(.black)
        .padding(.bottom, 12)
        .padding(.top, 8)
    }

    private func parseOracleText(_ text: String) -> Text {
        let replacedText = text
            .replacingOccurrences(of: "{U}", with: "💧")
            .replacingOccurrences(of: "\"{T}", with: "↩️")
            .replacingOccurrences(of: "{B}", with: "💀")
            .replacingOccurrences(of: "{W/B}", with: "☀️")
            .replacingOccurrences(of: "{1}", with: "1️⃣")
            .replacingOccurrences(of: "{2}", with: "2️⃣")
            .replacingOccurrences(of: "{3}", with: "3️⃣")
            .replacingOccurrences(of: "{4}", with: "4️⃣")
            .replacingOccurrences(of: "{5}", with: "5️⃣")
            .replacingOccurrences(of: "{6}", with: "6️⃣")
            .replacingOccurrences(of: "{7}", with: "7️⃣")
            .replacingOccurrences(of: "{8}", with: "8️⃣")
            .replacingOccurrences(of: "{9}", with: "9️⃣")
            .replacingOccurrences(of: "{0}", with: "0️⃣")
            .replacingOccurrences(of: "{R}", with: "🔥")
            .replacingOccurrences(of: "{G}", with: "🌲")
            .replacingOccurrences(of: "{W}", with: "☀️")
        let components = replacedText.components(separatedBy: CharacterSet(charactersIn: "()"))
        var parsedText = Text("")
        for (index, component) in components.enumerated() {
            if index % 2 != 0 {
                parsedText = parsedText + Text(component)
                    .italic() // Membuat teks dalam kurung kurawal menjadi italic
            } else {
                parsedText = parsedText + Text(component)
            }
        }
        return parsedText
    }
}





struct ContentView: View {
    @State private var mtgCards: [MTGCard] = []
    @State private var isSortedAscending = true
    @State private var sortOption: SortOption = .name
    @State private var searchText = ""
    @State private var isContentVisible = false

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var filteredMTGCards: [MTGCard] {
        if searchText.isEmpty {
            return mtgCards
        } else {
            return mtgCards.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                // Konten akan muncul dengan animasi fading saat tampilan dimuat
                VStack {
                    SearchBar(searchText: $searchText)
                        .opacity(isContentVisible ? 1 : 0) // Kontrol transparansi

                    Spacer()

                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(filteredMTGCards) { card in
                                NavigationLink(destination: DetailMTGCardView(card: card)) {
                                    MTGCardView(card: card)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .onAppear {
                            if let data = loadJSON() {
                                do {
                                    let decoder = JSONDecoder()
                                    let cards = try decoder.decode(MTGCardList.self, from: data)
                                    mtgCards = cards.data.sorted { $0.collector_number < $1.collector_number }
                                    withAnimation(.easeInOut) {
                                        isContentVisible = true // Setelah konten dimuat, tampilkan dengan animasi
                                    }
                                } catch {
                                    print("Error decoding JSON: \(error)")
                                }
                            }
                        }
                    }
                }
                .opacity(isContentVisible ? 1 : 0) // Kontrol transparansi
                .navigationBarTitle("MTG Cards", displayMode: .inline)
                .zIndex(0) // Keep the VStack below

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        // Sort button with dropdown menu
                        Menu {
                            Button(action: { sortOption = .name; sort() }) {
                                Label("Sort by Name", systemImage: "arrow.up.arrow.down")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: 2)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.black) // Latar belakang berwarna biru
                                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5) // Efek shadow
                                    )
                            )
                            .padding(.bottom, 10) // Tambahkan padding ke bawah agar tombol melayang di sudut kanan bawah

                            Button(action: { sortOption = .number; sort() }) {
                                Label("Sort by Number", systemImage: "arrow.up.arrow.down")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: 2)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.black) // Latar belakang berwarna biru
                                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5) // Efek shadow
                                    )
                            )
                            .padding(.bottom, 10) // Tambahkan padding ke bawah agar tombol melayang di sudut kanan bawah
                        } label: {
                            Label("Sort", systemImage: "arrow.up.arrow.down")
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white, lineWidth: 2)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.black) // Latar belakang berwarna biru
                                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5) // Efek shadow
                                        )
                                )
                                .padding(.bottom, 10) // Tambahkan padding ke bawah agar tombol melayang di sudut kanan bawah
                        }
                        .padding()
                    }
                    .padding()
                }
            }
        }
    }

    func loadJSON() -> Data? {
        if let path = Bundle.main.path(forResource: "WOT-Scryfall", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                print("JSON Loaded Successfully")
                return data
            } catch {
                print("Error loading JSON: \(error)")
            }
        }
        return nil
    }

    // Enum for sorting options
    enum SortOption {
        case name
        case number
    }

    private func sort() {
        isSortedAscending.toggle()
        switch sortOption {
        case .name:
            mtgCards.sort { card1, card2 in
                isSortedAscending ? card1.name < card2.name : card1.name > card2.name
            }
        case .number:
            mtgCards.sort { card1, card2 in
                isSortedAscending ? card1.collector_number < card2.collector_number : card1.collector_number > card2.collector_number
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct LegalitiesView: View {
    var legalities: MTGCard.Legalities
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                legalityRow("Standard", legalities.standard)
                legalityRow("Future", legalities.future)
                legalityRow("Historic", legalities.historic)
                legalityRow("Gladiator", legalities.gladiator)
                legalityRow("Pioneer", legalities.pioneer)
                legalityRow("Explorer", legalities.explorer)
                legalityRow("Modern", legalities.modern)
                legalityRow("Legacy", legalities.legacy)
                legalityRow("Pauper", legalities.pauper)
                legalityRow("predh", legalities.predh)
            }

            VStack(alignment: .leading) {
                legalityRow("Vintage", legalities.vintage)
                legalityRow("Penny", legalities.penny)
                legalityRow("Commander", legalities.commander)
                legalityRow("brawl", legalities.brawl)
                legalityRow("historicbrawl", legalities.historicbrawl)
                legalityRow("alchemy", legalities.alchemy)
                legalityRow("paupercommander", legalities.paupercommander)
                legalityRow("duel", legalities.duel)
                legalityRow("oldschool", legalities.oldschool)
                legalityRow("premodern", legalities.premodern)
            }
        }
    }

    private func legalityRow(_ title: String, _ status: String) -> some View {
        HStack {
            Text("\(title):")
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()

            Text(status)
                .font(.subheadline)
                .padding(4)
                .foregroundColor(.white)
                .background(legalityColor(status))
                .cornerRadius(4)
        }
        .padding(.vertical, 4)
    }

    private func legalityColor(_ status: String) -> Color {
        return status == "legal" ? .green : .red
    }
}

struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)

            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }
        }
    }
}
