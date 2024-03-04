//
//  ContentView.swift
//  CustomPullToRefresh
//
//  Created by Akash More on 01/11/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var jokes = Jokes()
    let items = (1...110).map { "Item \($0)" }
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State private var isShowing = false

//    let config = RotatingImageConfiguration(backgroundColor: .black, rotatingImage: "spinnerTwo")
    
//    let config = WaveConfiguration(backgroundColor: .red, waveColor: .blue)
    
//    let config = PulseConfiguration(backgroundColor: .red, pulseColor: .black, circleColor: .blue, shadowColor: .gray)
    
//     let config = LottieUIKitConfiguration(backgroundColor: .white, lottieFileName: "PaperPlane")
    
//     let config = LottieSwiftUIConfiguration(backgroundColor: .orange, lottieFileName: "ColorsAnimation")
    
//    let config = LottieSwiftUIConfiguration(backgroundColor: .clear, lottieFileName: "ColorsAnimation")
    
    var body: some View {
        
        // CombinedRefreshView(configuration: config, isShowing: $isShowing) {
         CombinedRefreshView(refreshViewType: .lottieSwiftUI(backgroundColor: .clear, lottieFileName: "PaperPlane"), dynamicIslandType: .doubleHelix, isShowing: $isShowing) {
//        CombinedRefreshView(configuration: config, refreshViewType: .lottieSwiftUI(backgroundColor: .clear, lottieFileName: "PaperPlane"), isShowing: $isShowing) {
            staticContentView
//            contentView2
        } refreshInitiated: {
            print("refresh initiated")
//            Task {
//                await fetchData()
//            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                isShowing = false
            })
        }
         .background(.gray)
    }
    
    private var staticContentView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 20, height: 100)
                        .background(Color.secondary)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        // .background(.yellow)
    }
    
    private var contentView2: some View {
        LazyVStack {
            if jokes.isEmpty {
                VStack {
                    Image(systemName: "arrow.clockwise")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Pull down to refresh the view")
                }
                .frame(height: UIScreen.main.bounds.height / 2)
            } else {
                ForEach(jokes, id: \.id) { joke in
                    VStack(spacing: 8) {
                        Text(joke.setup)
                            .multilineTextAlignment(.leading)
                            .font(.headline)
                            .foregroundColor(.blue)
                        Text(joke.punchline)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
            }
        }
    }
    
    func stopRefresh() {
        isShowing = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension ContentView {
    
    func fetchData() async {
        guard let url = URL(string: "https://official-joke-api.appspot.com/random_ten") else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Jokes.self, from: data) {
                jokes = decodedResponse
                stopRefresh()
                
                // for (index, value) in jokes.enumerated() {
                //     print("\(index): \(value.setup) -> \(value.punchline)")
                // }
            }
        } catch {
            print("invalid data: \(error.localizedDescription)")
        }
    }
}

enum RefreshViewType {
    case rotatingImage(backgroundColor: Color, imageName: String)
    case wave(backgroundColor: Color, waveColor: Color)
    case pulse(backgroundColor: Color, pulseColor: Color, circleColor: Color, shadowColor: Color)
    case lottieUIKit(backgroundColor: Color, lottieFileName: String)
    case lottieSwiftUI(backgroundColor: Color, lottieFileName: String)
}

enum DynamicIslandType {
    case doubleHelix
    case textAnimation
}
