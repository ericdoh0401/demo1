//
//  MPJoinView.swift
//  XsAndOs
//
//  Created by Eric Oh on 2/27/24.
//

import SwiftUI

struct MPJoinView: View {
    @EnvironmentObject var game: GameService
    @EnvironmentObject var connectionManager: MPConnectionManager
    @State private var gameCodeID: String = ""
    @Binding var startGame: Bool
    
    @State private var showAcceptAlert = false
//    @State private var showRejectAlert = false
    
    @State private var flickerToggle: Bool = false
    @State private var invited: Bool = false

    var body: some View {
        VStack {
            if !flickerToggle && !invited{
                Text("Wait for a host to send you an invite.")
            }
            else {
                Text("Please wait for host to start game...")
                    .opacity(flickerToggle ? 0.5 : 1)
                    .onAppear {
                        startFlickering()
                    }
            }
        }
        .padding()
        .onAppear {
            connectionManager.game?.gameName = "liar_poker"
            connectionManager.isAvailableToPlay = true
            connectionManager.startAdvertising()
        }
        .onDisappear(){
            connectionManager.game?.gameName = ""
            connectionManager.isAvailableToPlay = false
            connectionManager.stopAdvertising()
//            game.gameType = .join
        }
        // the requester receives an invite from the host (choose to accept or deny that request)
        // this alert pops up if our connectionManager receives an Invite from the host.
        
        .alert("Received \(showAcceptAlert ? "invite" : "request") from \(connectionManager.receivedInviteFrom?.displayName ?? "Unknown")", isPresented: $connectionManager.receivedInvite) {
            if !showAcceptAlert {
                Button("Accept") {
                    if let invitationHandler = connectionManager.invitationHandler {
                        game.host = Player(turn: 1, card_count: 1, name: connectionManager.receivedInviteFrom?.displayName ?? "Unknown")
                        showAcceptAlert = true
                        
                        // Accept the invitation for the first session
                        invitationHandler(true, connectionManager.session)
                        
                        // Set the delegate for the second session
//                        connectionManager.session.delegate = self
                        
                        // Introduce a delay to wait for the connection to be established
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Adjust the delay as needed
                            
                            // Handle the data received from the second session
                            print("Received data from:", connectionManager.receivedInviteFrom?.displayName ?? "Unknown")
                            print("Received data:", connectionManager.receivedPlayers)
                            print(connectionManager.paired)
                            
                            // Update UI or perform other actions based on the received data
                            flickerToggle.toggle()
                            invited.toggle()
                        }
                    }
                }
                Button("Reject") {
                    if let invitationHandler = connectionManager.invitationHandler {
                        invitationHandler(false, nil)
                    }
                }
            }
            else {
                Button("Accept") {
                    startGame.toggle()
                    if let invitationHandler = connectionManager.invitationHandler {
                        if !connectionManager.receivedPlayers.isEmpty {
                            invitationHandler(true, connectionManager.session)
                            game.players = connectionManager.receivedPlayers
                            print(game.players)
//                            print(game.players)
                        } else {
                            print(connectionManager.receivedData ?? [])
                        }
                    }
                }

                Button("Reject") {
                    startGame = false
                }
            }
        }
    }
    
    private func startFlickering() {
        // Start flickering animation /
        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            flickerToggle.toggle()
        }
    }
}

struct MPJoinView_Previews: PreviewProvider {
    static var previews: some View {
        MPJoinView(startGame: .constant(false))
            .environmentObject(MPConnectionManager(yourName: "1", gameName: "liar_poker"))
            .environmentObject(GameService())
    }
}
