//
//  GameView.swift
//  XsAndOs
//
//  Created by Eric Oh on 2/26/24.
//

import SwiftUI
import os.log

struct Liar_Game_View: View {
    @State private var selectedPlayerIndex: Int = 0
    @EnvironmentObject var game: GameService
    @EnvironmentObject var connectionManager: MPConnectionManager
    @Environment(\.dismiss) var dismiss
    @State private var card: [String] = []
    @State private var gameStart: Bool = true
    @State private var flickerToggle: Bool = false
    @State private var currentPlayerName: String = ""
    
    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()
            if game.clicked {
                let isReporter = game.players.first { $0.isClicker && $0.name == connectionManager.myPeerID.displayName } != nil
                if isReporter {
                    VStack {
                        Text("Were you right?")
                            .font(.title)
                        
                        Spacer()
                            .frame(height: 70)
                        
                        HStack {
                            Button(action:{
                                game.players.indices.forEach { index in
                                    if game.players[index].isTurn {
                                        game.players[index].card_count += 1
                                    }
                                    else if game.players[index].isClicker {
                                        game.players[index].isClicker.toggle()
                                    }
                                }
                                game.prefixSumOp()
                                game.clicked.toggle()
                                connectionManager.report(clicked: game.clicked)
                                connectionManager.send2(players: game.players)
                            }){
                                Text("Yes")
                            }
                            .foregroundColor(.white)
                            .bold()
                            .padding()
                            .frame(maxWidth: 80)
                            .background(Color.green)
                            .cornerRadius(20)
                            .disabled(connectionManager.joinedPeers.isEmpty)
                            
                            Spacer()
                                .frame(width: 40  )
                            
                            Button(action:{
                                game.players.indices.forEach{ index in
                                    if game.players[index].isTurn {
                                        game.players[index].isTurn.toggle()
                                    }
                                    else if game.players[index].isClicker {
                                        game.players[index].card_count += 1
                                        game.players[index].isClicker.toggle()
                                        game.players[index].isTurn.toggle()
                                    }
                                }
                                game.prefixSumOp()
                                game.clicked.toggle()
                                currentPlayerName = connectionManager.myPeerID.displayName
                                connectionManager.report(clicked: false)
                                connectionManager.send2(players: game.players)
                            }){
                                Text("No")
                            }
                            .foregroundColor(.white)
                            .bold()
                            .padding()
                            .frame(maxWidth: 80)
                            .background(Color(UIColor(red: 150/255, green: 0/255, blue: 0/255, alpha: 1)))
                            .cornerRadius(20)
                            .disabled(connectionManager.joinedPeers.isEmpty)
                        }
                        
                    }
                }
                else {
                    Text("Please wait as report has been made...")
                        .opacity(flickerToggle ? 0.5 : 1)
                        .onAppear {
                            startFlickering()
                        }
                }
            }
            else{
                VStack{
                    Text("Current player is: \(game.players.first(where: { $0.isTurn })?.name ?? "None")")
                    
                    Spacer()
                    
                    VStack {
                        if game.players.allSatisfy({ !$0.isTurn }) && game.host.name == connectionManager.myPeerID.displayName {
                            Text("Select a player to start")
                            
                            Picker("Select a player", selection: $selectedPlayerIndex) {
                                ForEach(game.players.indices, id: \.self) { index in
                                    Text(game.players[index].name).tag(index)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .onChange(of: selectedPlayerIndex) { newIndex in
                                
                                game.players.indices.forEach { index in
                                    game.players[index].isTurn = (index == newIndex)
                                }
                                gameStart.toggle()
                                
                                game.prefixSumOp()
                                
                                connectionManager.send2(players: game.players)
                            }
                        }
                        
                    }
                    
                    VStack {
                        ForEach(game.players.indices, id: \.self) { index in
                            Text(game.players[index].name)
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
                    
                    HStack{
                        Spacer()
                        
                        Button {
                            game.clicked = true
                            connectionManager.report(clicked: game.clicked)
                            if let currentIndex = game.players.firstIndex(where: {$0.name == connectionManager.myPeerID.displayName}) {
                                game.players[currentIndex].isClicker = true
                            }
                            connectionManager.send2(players:game.players)
                        } label: {
                            Image(systemName: "exclamationmark.octagon")
                                .resizable()
                                .foregroundColor(Color(UIColor(red: 120/255, green: 0/255, blue: 0/255, alpha: 1)))
                                .frame(width: 80, height: 80)
                        }
                        .disabled(currentPlayerName == connectionManager.myPeerID.displayName)
                        
                        Spacer()
                        
                        Button {
                            if let currentIndex = game.players.firstIndex(where: { $0.isTurn }) {
                                game.players[currentIndex].isTurn = false
                                
                                let nextIndex = ((currentIndex) + 1) % game.players.count
                                
                                game.players[nextIndex].isTurn = true
                                
                                currentPlayerName = game.players[nextIndex].name
                                
                                connectionManager.receivedPlayers = game.players

                                connectionManager.send2(players: game.players)
                            }
                        } label: {
                            Image(systemName: "arrowshape.right")
                                .resizable()
                                .foregroundColor(Color(UIColor(red: 0/255, green: 120/255, blue: 0/255, alpha: 1)))
                                .frame(width: 80, height: 80)
                        }
                        .disabled(currentPlayerName != connectionManager.myPeerID.displayName)
                        
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
            }
        }
        .onAppear{
            let cardMan = CardManager()
            card = cardMan.cards
        }
        .onChange(of: connectionManager.receivedPlayers) { newReceivedPlayers in
            game.players = newReceivedPlayers
            currentPlayerName = newReceivedPlayers.first { $0.isTurn }?.name ?? ""
        }
        .onChange(of: connectionManager.reportedClick) { clickToggled in
            game.clicked = clickToggled
        }
    }
    
    private func startFlickering() {
        // Start flickering animation /
        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            flickerToggle.toggle()
        }
    }
}

struct LiarView_Previews: PreviewProvider {
    static var previews: some View {
        Liar_Game_View()
            .environmentObject(GameService())
            .environmentObject(MPConnectionManager(yourName: "Sample", gameName: "liar_poker"))
    }
}
