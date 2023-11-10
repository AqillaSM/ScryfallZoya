import SwiftUI

struct MTGCardView: View {
    var card: MTGCard
    
    var body: some View {
        NavigationLink(destination: DetailMTGCardView(card: card)) {
            VStack {
                // Tampilkan gambar kartu
                AsyncImage(url: URL(string: card.image_uris?.large ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100) // Sesuaikan tinggi gambar sesuai kebutuhan
                    case .failure:
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100) // Sesuaikan tinggi gambar sesuai kebutuhan
                            .foregroundColor(.red)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        ProgressView()
                    }
                }
                .padding()

                // Tampilkan nama kartu
                Text(card.name)
                    .font(.title)
                    .padding()
            }
        }
    }
}

struct DetailMTGCardView: View {
    var card: MTGCard
    
    var body: some View {
        VStack {
            // Tampilkan gambar kartu dalam ukuran lebih besar di halaman detail
            AsyncImage(url: URL(string: card.image_uris?.large ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300) // Sesuaikan tinggi gambar sesuai kebutuhan
                case .failure:
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300) // Sesuaikan tinggi gambar sesuai kebutuhan
                        .foregroundColor(.red)
                case .empty:
                    ProgressView()
                @unknown default:
                    ProgressView()
                }
            }
            .padding()

            // Tampilkan seluruh data kartu
            VStack(alignment: .leading) {
                Text("\(card.name)")
                    .font(.headline)
                
                Text("Type:")
                    .font(.headline)
                Text(card.type_line)
                
                // Oracle Text section
                Text("Oracle Text:")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(card.oracle_text)
                

                
                // Legalities section
                Text("Legality : ")
                    .font(.headline)
                LegalitiesView(legalities: card.legalities)
                
                // Tambahkan property lainnya sesuai kebutuhan
            }
            .padding()
        }
        .navigationBarTitle(card.name, displayMode: .inline)
    }
}


struct ContentView: View {
    @State private var mtgCards: [MTGCard] = []
    @State private var isSortedAscending = true
    @State private var searchText = ""

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
            VStack {
                SearchBar(searchText: $searchText)

                // Tambahkan tombol untuk menyortir
                HStack {
                    Spacer()
                    Button(action: {
                        // Toggle urutan sorting
                        isSortedAscending.toggle()
                        // Sort kartu berdasarkan nama
                        mtgCards.sort(by: { card1, card2 in
                            if isSortedAscending {
                                return card1.name < card2.name
                            } else {
                                return card1.name > card2.name
                            }
                        })
                    }) {
                        Image(systemName: isSortedAscending ? "arrow.up" : "arrow.down")
                            .padding()
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }

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
                        // Load data dari file JSON
                        if let data = loadJSON() {
                            do {
                                let decoder = JSONDecoder()
                                let cards = try decoder.decode(MTGCardList.self, from: data)
                                mtgCards = cards.data
                            } catch {
                                print("Error decoding JSON: \(error)")
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("MTG Cards")
        }
    }

    // Fungsi untuk memuat data dari file JSON
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
                
                // Add more legality rows for other legalities as needed
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
        TextField("Search", text: $searchText)
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 10)
    }
}
