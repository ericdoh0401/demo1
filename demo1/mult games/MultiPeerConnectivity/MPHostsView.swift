//
//  MPPeersView.swift
//  MultiPlayer
//
//  Created by Eric Oh on 2/26/24.
//

import SwiftUI
import Combine  // Import Combine framework

struct MPHostsView: View {
    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var game: GameService
    @Binding var startGame: Bool
    @State private var flickerToggle: Bool = true
    
    var body: some View {
        VStack {
            Text("Select Players to Invite.\n Current invite count: \(connectionManager.joinedPeers.count)")
                .foregroundColor(.black)
            
            List(connectionManager.availablePeers, id: \.self) { peer in
                HStack {
                    Text(peer.displayName)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button("Select") {
                        game.gameType = .start
                        
                        if let index = connectionManager.availablePeers.firstIndex(of: peer) {
                            DispatchQueue.main.async {
                                connectionManager.availablePeers.remove(at: index)
                                let newPlayer = Player(turn: game.players.count + 1, card_count: 1, name: peer.displayName, cards: [""])
                                game.players.append(newPlayer)
                                connectionManager.nearbyServiceBrowser.invitePeer(peer, to: connectionManager.session, withContext: nil, timeout: 30)
                                connectionManager.joinedPeers.append(peer)
                            }
                        }
                        else {
                            print("Peer not found in availablePeers array.")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .listStyle(
                PlainListStyle() // Use PlainListStyle for a basic list
            )
            .background(
                Color(.gray) // Set the desired background color
            )
            .onAppear {
                connectionManager.game?.gameName = "liar_poker"
                connectionManager.startBrowsing()
                game.host = Player(turn: 1, card_count: 1, name: connectionManager.myPeerID.displayName)
                game.players.append(Player(turn: 1, card_count: 1, name: connectionManager.myPeerID.displayName, cards: [""]))
            }
            .onDisappear {
                connectionManager.game?.gameName = ""
                connectionManager.stopBrowsing()
                connectionManager.stopAdvertising()
                connectionManager.isAvailableToPlay = false
            }
            
            Spacer()
            
            Button("Start Game") {
                startGame.toggle()
                
                for peer in connectionManager.joinedPeers {
                    if connectionManager.joinedPeers.firstIndex(of: peer) != nil {
                        connectionManager.nearbyServiceBrowser.invitePeer(peer, to: connectionManager.session, withContext: nil, timeout: 30)
                    }
                }
                
                // do we need to send player info?
            }
            .foregroundColor(.white)
            .bold()
            .padding()
            .frame(maxWidth: 150)
            .background(Color.blue)
            .cornerRadius(20)
            .disabled(connectionManager.joinedPeers.isEmpty)
            .opacity(flickerToggle ? 0.7 : 1)
            .onAppear {
                startFlickering()
            }
        }
    }
    private func startFlickering() {
        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            flickerToggle.toggle()
        }
    }
}

//let encoder = JSONEncoder()
//let encodedPlayers = try encoder.encode(game.players)

struct MPPeersView_Previews: PreviewProvider {
    static var previews: some View {
        MPHostsView(startGame: .constant(false))
            .environmentObject(MPConnectionManager(yourName: "1", gameName: "liar_poker"))
            .environmentObject(GameService())
    }
}
                
//                .alert("Received request from \(connectionManager.receivedInviteFrom?.displayName ?? "Unknown")", isPresented: $connectionManager.receivedInvite) {
//                    Button("Accept") {
//                        if let invitationHandler = connectionManager.invitationHandler {
//                            invitationHandler(true, connectionManager.session)
//                            game.players.append(Player(turn: game.players.count + 1, player_deck: [""], name: connectionManager.receivedInviteFrom?.displayName ?? "Unknown"))
//                        }
//                    }
//                    Button("Reject") {
//                        if let invitationHandler = connectionManager.invitationHandler {
//                            invitationHandler(false, nil)
//                        }
//                    }
//                }

//                Section(header: Text("Join by Game Code")) {
//                    Text("Game Code: \(gameCode)")
//                }
//            }
//        }
//    }
//}

//                    game.gameType = .start
//                    connectionManager.startGameForAllPlayers()
                    // Iterate through joined peers and invite them
//                    connectionManager.nearbyServiceBrowser.invitePeer(<#T##MCPeerID#>, to: <#T##MCSession#>, withContext: <#T##NSData?#>, timeout: <#T##NSTimeInterval#>)
                //                    connectionManager.sendDataToAll(players: game.players)

                
                
                
//
//var body: some View {
//    Text("Available Players")
//    List(connectionManager.availablePeers, id: \.self){ peer in
//        HStack {
//            Text(peer.displayName)
//
//            Spacer()
//
//            Button("Select"){
//                game.gameType = .peer
//                connectionManager.nearbyServiceBrowser.invitePeer(peer, to: connectionManager.session, withContext: nil, timeout: 30)
//                game.player1.name = connectionManager.myPeerID.displayName
//                game.player2.name = peer.displayName
//            }
//            .buttonStyle(.borderedProminent)
//        }
//        .alert("Received Invitation from \(connectionManager.receivedInviteFrom?.displayName ?? "Unknown")", isPresented: $connectionManager.receivedInvite) {
//            Button("Accept") {
//                if let invitationHandler = connectionManager.invitationHandler  {
//                    invitationHandler(true, connectionManager.session)
//                    game.player1.name = connectionManager.receivedInviteFrom?.displayName ?? "Unknown"
//                    game.player2.name = connectionManager.myPeerID.displayName
//                    game.gameType = .peer
//                }
//            }
//            Button("Reject") {
//                if let invitationHandler = connectionManager.invitationHandler {
//                    invitationHandler(false, nil)
//                }
//            }
//        }
//    }
//    .onAppear {
//        connectionManager.isAvailableToPlay = true
//        connectionManager.startBrowsing()
//    }
//    .onDisappear {
//        connectionManager.stopBrowsing()
//        connectionManager.stopAdvertising()
//        connectionManager.isAvailableToPlay = false
//    }
//    .onChange(of: connectionManager.paired) { newValue in
//        startGame = newValue
//    }
//}
