//
//  GameView.swift
//  XsAndOs
//
//  Created by Eric Oh on 2/26/24.
//

import SwiftUI
import os.log

struct Deck_Game_View: View {
    @State private var selectedPlayerIndex: Int = 0
    @EnvironmentObject var game: GameService
    @EnvironmentObject var connectionManager: MPConnectionManager
    @Environment(\.dismiss) var dismiss
    @State private var card: [String] = []
    @State private var gameStart: Bool = true
    @State private var flickerToggle: Bool = false
    @State private var currentPlayerName: String = ""
    @State private var restart: Bool = false
    @State private var cardIndex: Int = 0
    
    
    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()
            
            VStack {
                
                if !game.clicked{
                    if game.host.name == connectionManager.myPeerID.displayName {
                        Button(){
                            game.dealGameStart()
                            connectionManager.reportedClick = true
                            game.clicked = true
                            connectionManager.sendCards(cards: game.deck)
                            connectionManager.send2(players: game.players)
                            connectionManager.report(clicked: game.clicked)
                        } label: {
                            Image(systemName: "play.circle")
                                .resizable()
                                .foregroundColor(Color(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)))
                                .frame(width: 80, height: 80)
                        }
                        .offset(y: 100)
                    }
                    else{
                        Text("Wait for host to activate deck.")
                    }
                }
                
                Spacer()
                
                GeometryReader { geometry in
                    ScrollView(.vertical) {
                        ForEach(game.players.indices, id: \.self) { index in
                            if game.players[index].name == connectionManager.myPeerID.displayName {
                                let playerCards = game.players[index].cards
                                LazyVStack(alignment: .leading, spacing: 10) {
                                    ForEach(1..<playerCards.count, id: \.self) { cardIndex in
                                        if cardIndex % 3 == 1 {
                                            HStack {
                                                ForEach(cardIndex..<min(cardIndex + 3, playerCards.count), id: \.self) { innerIndex in
                                                    Image(playerCards[innerIndex])
                                                        .resizable()
                                                        .frame(width: 75, height: 105)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: 250)
                }
                .offset(x: 80, y: 200)

                
                Spacer()
                    .frame(height: 500)
                
                HStack{
                    Spacer()
                    
                    Button {
                        restart.toggle()
                    } label: {
                        Image(systemName: "arrow.clockwise.circle")
                            .resizable()
                            .foregroundColor(Color(UIColor(red: 120/255, green: 0/255, blue: 0/255, alpha: 1)))
                            .frame(width: 80, height: 80)
                    }
                    .disabled(!game.clicked)
                    
                    Spacer()
                    
                    Button {
                        if let index = game.players.firstIndex(where: { $0.name == connectionManager.myPeerID.displayName }) {
                            game.players[index].cards.append(game.deck[cardIndex])
                            game.players[index].card_count += 1
                            cardIndex += 1
                            connectionManager.send2(players: game.players)
                            connectionManager.sendNext(index: cardIndex)
                        }
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .foregroundColor(Color(UIColor(red: 0/255, green: 120/255, blue: 0/255, alpha: 1)))
                            .frame(width: 80, height: 80)
                    }
                    .disabled(!game.clicked)
                    
                    Spacer()
                }
                
                Spacer()
                
                
                VStack {
                    if game.gameOver {
                        Text("Game Over")
                        if let loserPlayer = game.players.first(where: { $0.isLoser }) {
                            Text("\(loserPlayer.name) is the loser")
                        }
                        Button("New Game") {
                            game.reset()
                            if game.gameType == .host {
                                let gameMove = MPGameMove(action: .nextRound, playerName: nil, reportInitiated: false, players: game.players)
                                connectionManager.send(gameMove: gameMove)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .font(.largeTitle)
                Spacer()
            }
            .alert("Restart Game", isPresented: $restart, actions: {
                Button("Cancel", role: .destructive){
                    restart.toggle()
                }
                Button("Restart", role: .cancel){
                    restart.toggle()
                    game.restartCardCount()
                    game.dealGameStart()
                    connectionManager.reportedClick = false
                    game.clicked = false
                    connectionManager.report(clicked: game.clicked)
                    connectionManager.send2(players: game.players)
                    connectionManager.sendCards(cards: game.deck)
                }
            }, message: {
                Text("Are you sure you would like to restart the game?")
            })
        }
        .onChange(of: connectionManager.receivedPlayers) { newReceivedPlayers in
            print(newReceivedPlayers)
            print("pass through1")
            game.players = newReceivedPlayers
        }
        .onChange(of: connectionManager.reportedClick) { clickToggled in
            print(clickToggled)
            print("pass through2")
            game.clicked = clickToggled
        }
        .onChange(of: connectionManager.receivedCards) { newDeckOfCards in
            game.deck = newDeckOfCards
        }
        .onChange(of: connectionManager.receivedIndex) { newIndex in
            cardIndex = newIndex
        }
    }
    
    private func startFlickering() {
        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            flickerToggle.toggle()
        }
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        Deck_Game_View()
            .environmentObject(GameService())
            .environmentObject(MPConnectionManager(yourName: "Sample", gameName: "interactive_deck"))
    }
}
