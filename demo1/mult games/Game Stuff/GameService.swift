//
//  GameService.swift
//  XsAndOs
//
//  Created by Eric Oh on 2/26/24.
//

import SwiftUI
//
//  GameService.swift
//  XsAndOs
//
//  Created by Eric Oh on 2/26/24.
//

import SwiftUI

@MainActor
class GameService: ObservableObject{
    @Published var players: [Player] = []
    @Published var host: Player = Player(turn: 0, card_count: 0, name: "")
    @Published var clicked: Bool = false
    @Published var gameOver = false
    @Published var prefixSum: [Int] = []
    @Published var gameName: String = ""
    @Published var topIndex: Int = 0
    @Published var deck: [String] = []
    
    var gameType = GameType.undetermined
    
    var currentPlayer: Player? {
        for player in players {
            if player.isTurn {
                return player
            }
        }
        return nil
    }
    
    var gameStarted: Bool {
        for player in players{
            if player.isTurn {
                return true
            }
        }
        return false
    }
    
    func restartCardCount(){
        for index in players.indices {
            players[index].card_count = 0
            players[index].cards = [""]
        }
    }
    
    func dealGameStart(){
        let cardMan = CardManager()
        let card = cardMan.cards
        deck = card
    }
    
    func prefixSumOp(){
        prefixSum = [0]
        
        let cardMan = CardManager()
        let card = cardMan.cards
        
        for index in players.indices {
            if let lastSum = prefixSum.last {
                prefixSum.append(lastSum + players[index].card_count)
            } else {
                prefixSum.append(players[index].card_count)
            }
        }
        
        for index in players.indices {
            let start = prefixSum[index]
            let end = prefixSum[index + 1]
            let range = start..<end
            players[index].cards = Array(card[range])
        }
    }
    
    func setupGame(gameType: GameType){
        switch gameType {
        case .join:
            self.gameType = .join
        case .host:
            self.gameType = .host
        case .start:
            self.gameType = .start
        case .undetermined:
            break
        }
    }
    
    func reset() {
        for var player in players{
            player.isTurn = false
            player.card_count = 0
            gameOver = false
        }
    }
    
    func checkIfOver() {
        for player in players{
            if player.isLoser {
                gameOver = true
            }
        }
        gameOver = false
    }
    
    func toggleCurrent() {
        if let currentIndex = players.firstIndex(where: { $0.isTurn }) {
            players[currentIndex].isTurn.toggle()
            
            let nextIndex = (currentIndex + 1) % players.count
            players[nextIndex].isTurn.toggle()
        }
    }
    
    func updateTurn(turn: Int){
        for var player in players{
            if turn == player.turn {
                player.isTurn.toggle()
            }
        }
    }
    
    func makeMove(){
        checkIfOver()
        if !gameOver {
            toggleCurrent()
        }
    }
}


//@MainActor
//class GameService: ObservableObject{
//    @Published var player1 = Player(gamePiece: .x, name: "Player 1")
//    @Published var player2 = Player(gamePiece: .o, name: "Player 2")
//    @Published var possibleMoves = Move.all
//    @Published var movesTaken = [Int]()
//    @Published var gameOver = false
//    @Published var gameBoard = GameSquare.reset
//
//    var gameType = GameType.single
//
//    var currentPlayer: Player{
//        if player1.isCurrent {
//            return player1
//        }
//        else{
//            return player2
//        }
//    }
//
//    var gameStarted: Bool {
//        player1.isCurrent || player2.isCurrent
//    }
//
//    var boardDisabled: Bool {
//        gameOver || !gameStarted
//    }
//
//    func setupGame(gameType: GameType, player1Name: String, player2Name: String){
//        switch gameType {
//        case .single:
//            self.gameType = .single
//            player2.name = player2Name
//        case .peer:
//            self.gameType = .peer
//        case .undetermined:
//            break
//        }
//        player1.name = player1Name
//    }
//
//    func reset() {
//        player1.isCurrent = false
//        player2.isCurrent = false
//        movesTaken.removeAll()
//        player1.moves.removeAll()
//        player2.moves.removeAll()
//        gameOver = false
//        possibleMoves = Move.all
//        gameBoard = GameSquare.reset
//    }
//
//    func updateMoves(index: Int){
//        if player1.isCurrent {
//            player1.moves.append(index + 1)
//            gameBoard[index].player = player1
//        }
//        else{
//            player2.moves.append(index + 1)
//            gameBoard[index].player = player2
//        }
//    }
//
//    func checkIfWinner(){
//        if player1.isWinner || player2.isWinner {
//            gameOver = true
//        }
//    }
//
//    func toggleCurrent() {
//        player1.isCurrent.toggle()
//        player2.isCurrent.toggle()
//    }
//
//    func makeMove(at index: Int){
//        if gameBoard[index].player == nil {
//            withAnimation {
//                updateMoves(index: index)
//            }
//            checkIfWinner()
//            if !gameOver {
//                if let matchingIndex = possibleMoves.firstIndex(where: {$0 == (index + 1)}){
//                    possibleMoves.remove(at: matchingIndex)
//                }
//                toggleCurrent()
//            }
//            if possibleMoves.isEmpty {
//                gameOver = true
//            }
//        }
//    }
//}
