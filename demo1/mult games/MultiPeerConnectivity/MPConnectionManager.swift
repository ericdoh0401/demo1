//
//  MPConnectionManager.swift
//  MultiPlayer
//
//  Created by Eric Oh on 2/25/24.
//

import MultipeerConnectivity
import os.log

extension String  {
    static var serviceName = "demo1"
}

class MPConnectionManager: NSObject, ObservableObject {
    let serviceType = String.serviceName
    let session: MCSession
    let myPeerID: MCPeerID
    let nearbyServiceAdvertiser: MCNearbyServiceAdvertiser
    let nearbyServiceBrowser: MCNearbyServiceBrowser
    let curGameName: String

    var game: GameService?

    func setup(game: GameService){
        self.game = game
    }

    @Published var availablePeers = [MCPeerID]()
    @Published var joinedPeers = [MCPeerID]()
    @Published var hosts = [MCPeerID]()
    @Published var receivedInvite: Bool = false
    @Published var receivedInviteFrom: MCPeerID?
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?
    @Published var paired: Bool = false
    @Published var prefixSum: [Int] = []
    @Published var receivedPlayers: [Player] = []
    @Published var receivedData: Data?
    @Published var reportedClick: Bool = false
    @Published var receivedCards: [String] = []
    @Published var receivedIndex: Int = 0

    var isAvailableToPlay: Bool = false {
        didSet{
            if isAvailableToPlay {
                startAdvertising()
            } else {
                stopAdvertising()
            }
        }
    }

    init(yourName: String, gameName: String){
        myPeerID = MCPeerID(displayName: yourName)
        session = MCSession(peer: myPeerID)
        let discoveryInfo = ["gameName": gameName]
        curGameName = gameName
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        nearbyServiceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        super.init()
        session.delegate = self
        nearbyServiceAdvertiser.delegate = self
        nearbyServiceBrowser.delegate = self
    }

    deinit {
        stopBrowsing()
        stopAdvertising()
    }
    
    
    func startAdvertising() {
        nearbyServiceAdvertiser.startAdvertisingPeer()
    }


    func stopAdvertising(){
        nearbyServiceAdvertiser.stopAdvertisingPeer()
    }

    func startBrowsing(){
        nearbyServiceBrowser.startBrowsingForPeers()
    }

    func stopBrowsing(){
        nearbyServiceBrowser.stopBrowsingForPeers()
        availablePeers.removeAll()
    }
    
    func absurd(){
        print("HELLO WORLD")
    }
    
    func startGameForAllPlayers(){
        self.paired = true
    }
    
    func send(gameMove: MPGameMove){
        if !session.connectedPeers.isEmpty {
            do {
                if let data = gameMove.data(){
                    try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                }
            }
            catch{
                print("error sending \(error.localizedDescription)")
            }
        }
    }
    
    func sendNext(index: Int) {
        if !session.connectedPeers.isEmpty {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(index)
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                print("Error occurred", error)
            }
        }
    }
    
    func sendCards(cards: [String]) {
        if !session.connectedPeers.isEmpty {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(cards)
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                print("Error occurred", error)
            }
        }
    }
    
    func send2(players: [Player]) {
        if !session.connectedPeers.isEmpty {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(players) // Use equality check operator here
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                print("Error occurred:", error)
            }
        }
    }
    
    func report(clicked: Bool){
        if !session.connectedPeers.isEmpty {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(clicked)
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            }
            catch {
                print("click did not go through")
            }
        }
    }
}

extension MPConnectionManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        DispatchQueue.main.async {
            if (!self.availablePeers.contains(peerID) && !self.joinedPeers.contains(peerID)) {
                if let foundGameName = info?["gameName"] {
                    if self.curGameName == foundGameName{
                        print("Found peer: \(peerID.displayName)")
                        // Append the peerID to availablePeers
                        self.availablePeers.append(peerID)
                    }
                }
            }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        guard let index = availablePeers.firstIndex(of: peerID) else { return }
        DispatchQueue.main.async {
            self.availablePeers.remove(at: index)
        }
    }
}


extension MPConnectionManager: MCNearbyServiceAdvertiserDelegate{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        DispatchQueue.main.async{
            self.receivedInvite = true
            self.receivedInviteFrom = peerID
            self.invitationHandler = invitationHandler
        }
    }
}


extension MPConnectionManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            DispatchQueue.main.async {
                self.paired = false
                self.isAvailableToPlay = true
                self.joinedPeers.removeAll()
                if let index = self.hosts.firstIndex(of: peerID) {
                    self.hosts.remove(at: index)
                }
            }
        case .connected:
            self.paired = true
            self.joinedPeers.append(peerID)
        default:
            DispatchQueue.main.async {
                self.paired = false
                self.isAvailableToPlay = true
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let newIndex = try? JSONDecoder().decode(Int.self, from: data){
            DispatchQueue.main.async {
                self.receivedIndex = newIndex
            }
        }
        
        if let playerInfo = try? JSONDecoder().decode([Player].self, from: data){
            DispatchQueue.main.async {
                self.receivedPlayers = playerInfo
            }
        }
        
        if let clicked = try? JSONDecoder().decode(Bool.self, from: data){
            DispatchQueue.main.async {
                self.reportedClick = clicked
            }
        }
        
        if let cards = try? JSONDecoder().decode([String].self, from: data){
            DispatchQueue.main.async {
                self.receivedCards = cards
            }
        }

        if let gameMove = try? JSONDecoder().decode(MPGameMove.self, from: data) {
            DispatchQueue.main.async {
                switch gameMove.action {
                case .start:
                    self.game?.players = gameMove.players
                case .report:
                    guard gameMove.playerName != nil else {
                        return
                    }
                    self.game?.reset()
                case .nextPlayer:
                    self.game?.makeMove()
                case .nextRound:
                    self.game?.reset()
                case .end:
                    self.session.disconnect()
                    self.isAvailableToPlay = true
                }
            }
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }

}
