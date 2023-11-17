import SwiftUI

struct MTGCardView: View {
    var card: MTGCard
    
    var body: some View {
        NavigationLink(destination: DetailMTGCardView(card: card)) {
            VStack(spacing: 0) {
                // Display card image
                AsyncImage(url: URL(string: card.image_uris?.normal ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 0))
                    case .failure:
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 150)
                            .foregroundColor(.red)
                            .clipShape(RoundedRectangle(cornerRadius: 0))
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 0))
                    @unknown default:
                        ProgressView()
                            .frame(width: 100, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 0))
                    }
                }
                Spacer()

                // Display card name with smaller font size
                Text(card.name)
                    .font(.footnote) // Change the font size as needed
                    .foregroundColor(.black)
                
                Spacer()
            }
        }
        .padding(.horizontal)
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
                    AsyncImage(url: URL(string: card.image_uris?.art_crop ?? "")) { phase in
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
                        HStack {
                            Text("\(card.name)")
                                .font(.largeTitle)
                                .bold()
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 8)
                            
                            Spacer()
                            
                            let replacedText = (card.mana_cost)
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
                            Text(replacedText)
                                .font(.subheadline)
                                .padding(4)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(4)
                            
                        }


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
    @State private var selectedTab = 0
    
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
            TabView(selection: $selectedTab) {
                // Menu Tab
                VStack {
                        HStack {
                            VStack {
                                SearchBar(searchText: $searchText)
                                    .opacity(isContentVisible ? 1 : 0) // Atur padding horizontal di dalam HStack
                                    .padding(.top, 30)
                                    .padding(.bottom, -40)
                                Menu {
                                    Button(action: { sortOption = .name; sort() }) {
                                        Label("Sort by Name", systemImage: "arrow.up.arrow.down")
                                    }
                                    .foregroundColor(.black)
                                    
                                    Button(action: { sortOption = .number; sort() }) {
                                        Label("Sort by Number", systemImage: "arrow.up.arrow.down")
                                    }
                                    .foregroundColor(.black)
                                    
                                    // Tambahkan kode desain dan aksi lain yang diperlukan untuk sort by number
                                } label: {
                                    Label("Sort", systemImage: "arrow.up.arrow.down")
                                        .foregroundColor(.black)
                                    // Tambahkan kode desain dan aksi lain yang diperlukan untuk sort
                                }
                                .padding(.bottom, 20)
                                .padding()
                                .offset(y: 25)
                                .padding(.trailing, 10)
                            }// Memberikan padding kanan pada Menu
                        }
                        .padding(.horizontal) // Menambahkan padding horizontal di luar HStack
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
                            // Load JSON data and display content with animation once loaded
                            if let data = loadJSON() {
                                do {
                                    let decoder = JSONDecoder()
                                    let cards = try decoder.decode(MTGCardList.self, from: data)
                                    mtgCards = cards.data.sorted { $0.collector_number < $1.collector_number }
                                    withAnimation(.easeInOut) {
                                        isContentVisible = true
                                    }
                                } catch {
                                    print("Error decoding JSON: \(error)")
                                }
                            }
                        }
                    }
                    Divider()
                }
                .opacity(isContentVisible ? 1 : 0) // Control transparency
                .navigationBarItems(leading:
                    // Navigation bar content
                    HStack {
                        Spacer().frame(width: 16) // Set width of space as needed
                        Image("MTGName")
                            .resizable()
                            .frame(width: 206, height: 69) // Adjust size as needed
                    }
                    .padding(.top, 20)
                )
                .zIndex(0) // Keep the VStack below
                .tabItem {
                    Label("Menu", systemImage: "house")
                }
                .tag(0)
                
                // Collection Tab
                VStack {
                    Text("Under Progress")
                }
                .tabItem {
                    Label("Collection", systemImage: "folder")
                }
                .tag(1)
                
                // Account Tab
                VStack {
                    Spacer()
                    
                    // Profile Picture
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                    
                    // Username/Name
                    Text("Mahazoya")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    // Email
                    Text("mahazoya@example.com")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 30)
                    
                    Spacer()
                }
                .padding()
                .navigationBarTitle("Account")
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
                .tag(2)
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
                legalityRow("Predh", legalities.predh)
            }

            VStack(alignment: .leading) {
                legalityRow("Vintage", legalities.vintage)
                legalityRow("Penny", legalities.penny)
                legalityRow("Commander", legalities.commander)
                legalityRow("Brawl", legalities.brawl)
                legalityRow("Historicbrawl", legalities.historicbrawl)
                legalityRow("Alchemy", legalities.alchemy)
                legalityRow("Paupercommander", legalities.paupercommander)
                legalityRow("Duel", legalities.duel)
                legalityRow("Oldschool", legalities.oldschool)
                legalityRow("Premodern", legalities.premodern)
            }
        }
    }

    private func legalityRow(_ title: String, _ status: String) -> some View {
        let formattedStatus = status == "not_legal" ? "Not Legal" : status.capitalized
        
        return HStack {
            Text("\(title):")
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()

            Text(formattedStatus)
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

