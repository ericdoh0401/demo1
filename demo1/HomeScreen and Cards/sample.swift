//
//  sample.swift
//  demo1
//
//  Created by Eric Oh on 2/21/24.
//

import SwiftUI

struct CardView : View {
    @State var card: Game
    @AppStorage("yourName") var yourName = ""
    @EnvironmentObject var game: GameService
    @State private var hol: Bool = false
    @State private var king: Bool = false
    @State private var dice: Bool = false
    @State private var buzz: Bool = false
    @State private var superl: Bool = false
    @State private var pang: Bool = false
    @State private var titan: Bool = false
    @State private var coin: Bool = false
    @State private var liar: Bool = false
    @State private var deck: Bool = false
    @State private var hol_int: Bool = false
    @State private var king_int: Bool = false
    @State private var dice_int: Bool = false
    @State private var buzz_int: Bool = false
    @State private var superl_int: Bool = false
    @State private var pang_int: Bool = false
    @State private var titan_int: Bool = false
    @State private var coin_int: Bool = false
    @State private var liar_int: Bool = false
    @State private var deck_int: Bool = false
    
    init(card: Game, yourName: String){
        _card = State(initialValue: card)
        self.yourName = yourName
    }
    let cardGradient = Gradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.5)])
    
    var body: some View{
        ZStack {
            
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 360, height: 500)
                .clipped()
                .foregroundColor(card.color)
            
            
            // Linear Gradient
            VStack {
                Text(card.name)
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .opacity(Double(1 - abs(card.x/30)))
                
                Spacer()
                    .frame(height: 70)
                
                Image(systemName: card.imageName)
                    .resizable()
                    .frame(width: card.dimX, height: card.dimY)
                    .opacity(Double(1 - abs(card.x/30)))
            }
            .padding()
            .foregroundColor(.black)
            
            ZStack {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(Double(card.x/30 * -1 - 1))
                
                Image(systemName: "gamecontroller")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(Double(card.x/30 - 1))
            }
            .foregroundColor(.black)
            .frame(height: 100)
        }
        .cornerRadius(8)
        .offset(x: card.x, y: card.y)
        .rotationEffect(.init(degrees: card.degree))
        .gesture (
            DragGesture()
                .onChanged { value in
                    withAnimation(.default) {
                        card.x = value.translation.width
                        card.y = value.translation.height
                        card.degree = 7 * (value.translation.width > 0 ? 1 : -1)
                    }
                }
                .onEnded { (value) in
                    withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
                        switch value.translation.width {
                        case 0...100:
                            card.x = 0; card.degree = 0; card.y = 0
                        case let x where x > 100:
                            card.x = 500; card.degree = 12
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                hol = (card.name == "Higher or Lower?")
                                king = (card.name == "Kings Cup")
                                dice = (card.name == "Dice Game")
                                buzz = (card.name == "BUZZED")
                                superl = (card.name == "Superlatives")
                                pang = (card.name == "Ultimate Pangea")
                                titan = (card.name == "Titanic")
                                coin = (card.name == "Coin Flip")
                                liar = (card.name == "Liar's Poker")
                                deck = (card.name == "Deck of Cards")
                            }
//                            isNavigating = true
                        case (-100)...(-1):
                            card.x = 0; card.degree = 0; card.y = 0
                        case let x where x < -100:
                            card.x  = -500; card.degree = -12
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                hol_int = (card.name == "Higher or Lower?")
                                king_int = (card.name == "Kings Cup")
                                dice_int = (card.name == "Dice Game")
                                buzz_int = (card.name == "BUZZED")
                                superl_int = (card.name == "Superlatives")
                                pang_int = (card.name == "Ultimate Pangea")
                                titan_int = (card.name == "Titanic")
                                coin_int = (card.name == "Coin Flip")
                                liar_int = (card.name == "Liar's Poker")
                                deck_int = (card.name == "Deck of Cards")
                            }
                        default:
                            card.x = 0; card.y = 0
                        }
                    }
                }
        )
        NavigationLink(
            destination: HOL(), // Replace with the actual view you want to navigate to
            isActive: $hol
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: HOL_instruction(), // Replace with the actual view you want to navigate to
            isActive: $hol_int
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: Kings(), // Replace with the actual view you want to navigate to
            isActive: $king
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: king_instruction(), // Replace with the actual view you want to navigate to
            isActive: $king_int
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: Dice(), // Replace with the actual view you want to navigate to
            isActive: $dice
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: dice_instruction(), // Replace with the actual view you want to navigate to
            isActive: $dice_int
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: buzzed(), // Replace with the actual view you want to navigate to
            isActive: $buzz
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: buzz_instruction(), // Replace with the actual view you want to navigate to
            isActive: $buzz_int
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: superlatives(), // Replace with the actual view you want to navigate to
            isActive: $superl
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: super_instruction(), // Replace with the actual view you want to navigate to
            isActive: $superl_int
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: pangea1(), // Replace with the actual view you want to navigate to
            isActive: $pang
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: pan1_instruction(), // Replace with the actual view you want to navigate to
            isActive: $pang_int
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: titanic(), // Replace with the actual view you want to navigate to
            isActive: $titan
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: titanic_instruction(), // Replace with the actual view you want to navigate to
            isActive: $titan_int
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: Coin(), // Replace with the actual view you want to navigate to
            isActive: $coin
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: coin_instruction(), // Replace with the actual view you want to navigate to
            isActive: $coin_int
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: Liar_Start_View(yourName: self.yourName), // Replace with the actual view you want to navigate to
            isActive: $liar
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: Liar_instruction(), // Replace with the actual view you want to navigate to
            isActive: $liar_int
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: Deck_Start_View(yourName: self.yourName), // Replace with the actual view you want to navigate to
            isActive: $deck
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
        NavigationLink(
            destination: coin_instruction(), // Replace with the actual view you want to navigate to
            isActive: $deck_int
        ) {
            EmptyView()
        }
        .onAppear(){
            card.x = 0; card.y = 0; card.degree = 0
        }
    }
}

struct RightDestination: View {
    var body: some View {
        // Your content for the right destination
        Text("Right Destination")
    }
}

struct LeftDestination: View {
    var body: some View {
        // Your content for the left destination
        Text("Left Destination")
    }
}

struct Sample: View {
    @State private var currentIndex = 0
    @State private var currentIndex1 = 0
    @State private var isNavigatingRight = false
    @State private var isNavigatingLeft = false
    @State private var multiSetting = false
    @EnvironmentObject var game: GameService
    @AppStorage("yourName") var yourName = ""
    
    init(yourName: String){
        self.yourName = yourName
    }
    
    var non_mult_games: [Game] =
    [.init(name: "Higher or Lower?", imageName: "arrow.up.arrow.down.square", color: Color(UIColor(red: 217/255, green: 33/255, blue: 33/255, alpha: 1)), index: 0, dimX: 130, dimY: 130),
     .init(name: "Kings Cup", imageName: "wineglass", color : .orange, index: 1, dimX: 100, dimY: 140),
     .init(name: "Dice Game", imageName: "dice", color: .yellow, index: 2, dimX: 130, dimY: 130),
     .init(name: "BUZZED", imageName: "brain.filled.head.profile", color: Color(UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1)), index: 3, dimX: 110, dimY: 130),
     .init(name: "Superlatives", imageName: "person.fill.questionmark", color: .cyan, index: 4, dimX: 130, dimY: 120),
     .init(name: "Ultimate Pangea", imageName: "mappin.and.ellipse", color: .indigo, index: 5, dimX: 110, dimY: 130),
     .init(name: "Titanic", imageName: "sailboat.circle", color: .brown, index: 6, dimX: 130, dimY: 130),
     .init(name: "Coin Flip", imageName: "bitcoinsign.circle", color: .blue, index: 7, dimX: 130, dimY: 130)]
    
    var mult_games: [Game] =
    [.init(name: "Deck of Cards", imageName: "greetingcard", color: Color(UIColor(red: 217/255, green: 33/255, blue: 33/255, alpha: 1)), index: 0, dimX: 100, dimY: 130),
     .init(name: "Liar's Poker", imageName: "doc.questionmark", color: Color(UIColor(red: 255/255, green: 100/255, blue: 50/255, alpha: 1)), index: 1, dimX: 100, dimY: 130)]

    var body: some View {
            
        NavigationView{
            
            if !multiSetting {
                ZStack{
                    
                    LinearGradient(gradient: Gradient(colors: [Color(UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1)), Color(UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                    
                    VStack {
                        Spacer()
                            .frame(height: 15)
                        
                        Text("Swipe right to play and \n    left for instructions. \n        (Single-phone)")
                            .font(.title3)
                            .foregroundColor(.black)
                            .frame(width: 360, height: 100)
                            .background(Color.white)
                            .clipShape(.capsule)
                            .bold()
                        
                        Spacer()
                            .frame(height: 40)
                        
                        ZStack {
                            ForEach(non_mult_games, id: \.name) { game in
                                CardView(card: game, yourName: yourName)
                                    .opacity(game.index == currentIndex ? 1 : 0)
                            }
                        }
                        
                        Spacer()
                            .frame(height: 40)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                scroll(offset: -1)
                            }) {
                                Image(systemName: "arrow.left.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                            Spacer()
                            
                            Button(action: {
                                multiSetting.toggle()
                            }){
                                ZStack{
                                    Image(systemName: "person.2.circle")
                                        .resizable()
                                        .frame(width: 45, height: 45)
                                        .offset(x: 33, y: -20)
                                        .opacity(0.5)
                                    
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                }
                            }
                            Spacer()
                            
                            Button(action: {
                                scroll(offset: 1)
                            }) {
                                Image(systemName: "arrow.right.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                            Spacer()
                        }
                        .bold()
                        .foregroundColor(.black)
                        
                    }
                    .navigationBarHidden(true)
                }
            }
            else{
                ZStack{
                    
                    LinearGradient(gradient: Gradient(colors: [Color(UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)), Color(UIColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                    
                    VStack {
                        Spacer()
                            .frame(height: 15)
                        
                        Text("Swipe right to play and \n    left for instructions.\n        (Multi-phone)")
                            .font(.title3)
                            .foregroundColor(.black)
                            .frame(width: 360, height: 100)
                            .background(Color.white)
                            .clipShape(.capsule)
                            .bold()
                        
                        Spacer()
                            .frame(height: 40)
                        
                        ZStack {
                            ForEach(mult_games, id: \.name) { game in
                                CardView(card: game, yourName: yourName)
                                    .opacity(game.index == currentIndex1 ? 1 : 0)
                            }
                        }
                        
                        Spacer()
                            .frame(height: 40)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                scroll(offset: -1)
                            }) {
                                Image(systemName: "arrow.left.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                            Spacer()
                            
                            Button(action: {
                                multiSetting.toggle()
                            }){
                                ZStack{
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .frame(width: 45, height: 45)
                                        .offset(x: 33, y: -20)
                                        .opacity(0.5)
                                    
                                    Image(systemName: "person.2.circle.fill")
                                        .resizable()
                                        .frame(width: 60, height: 60)                                }
                            }
                            Spacer()
                            
                            Button(action: {
                                scroll(offset: 1)
                            }) {
                                Image(systemName: "arrow.right.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                            Spacer()
                        }
                        .bold()
                        .foregroundColor(.white)
                        
                    }
                    .navigationBarHidden(true)
                }

            }
        }
    }

    func scroll(offset: Int) {
        if !multiSetting {
            let newIndex = (currentIndex + offset) % non_mult_games.count
            if newIndex < 0 {
                withAnimation {
                    currentIndex = non_mult_games.count - 1
                }
            }
            else if newIndex >= 0 && newIndex < non_mult_games.count {
                withAnimation {
                    currentIndex = newIndex
                }
            }
        }
        else {
            let newIndex = (currentIndex1 + offset) % mult_games.count
            if newIndex < 0 {
                withAnimation {
                    currentIndex1 = mult_games.count - 1
                }
            }
            else if newIndex >= 0 && newIndex < mult_games.count {
                withAnimation {
                    currentIndex1 = newIndex
                }
            }
        }
    }
}


struct Sample_Previews: PreviewProvider {
    static var previews: some View {
        Sample(yourName: "Sample5")
            .environmentObject(GameService())
    }
}
