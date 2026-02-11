//
//  GameModels.swift
//  MultiPlayer
//
//  Created by Eric Oh on 2/26/24.
//

//
//  GameModels.swift
//  MultiPlayer
//
//  Created by Eric Oh on 2/26/24.
//

import SwiftUI

enum GameType {
    case join, host, start, undetermined
    
    var description: String {
        switch self{
        case .join:
            return "Enter the host's game code to join their game."
        case .host:
            return "Host game for others to join."
        case .start:
            return ""
        case .undetermined:
            return ""
        }
    }
}


struct Player: Identifiable, Codable, Equatable {
    var id = UUID()
    var isClicker = false
    var turn: Int
    var card_count: Int
    var name: String
    var cards: [String] = [""]
    var isTurn = false
    
    var isLoser: Bool {
        return card_count == 6
    }
    
    func data() -> Data?{
        try? JSONEncoder().encode(self)
    }
}

//
//import SwiftUI
//
//enum GameType {
//    case join, host, undetermined
//
//    var description: String {
//        switch self{
////      case .join:
//            return "Enter the host's game code to join their game."
//        case .host:
//            return "Host game for others to join."
//        case .undetermined:
//            return ""
//        }
//    }
//}
//
//
//enum GamePiece: String {
//    case x, o
//    var image: Image {
//        Image(self.rawValue)
//    }
//}
//
//
//
//struct Player {
//    let gamePiece: GamePiece
//    var name: String
//    var moves: [Int] = []
//    var isCurrent = false
//    var isWinner: Bool {
//        for moves in Move.winningMoves {
//            if moves.allSatisfy(self.moves.contains){
//                return true
//            }
//        }
//        return false
//    }
//}
//
//enum Move {
//    static var all = [1,2,3,4,5,6,7,8,9]
//
//    static var winningMoves = [
//        [1,2,3],
//        [4,5,6],
//        [7,8,9],
//        [1,4,7],
//        [2,5,8],
//        [3,6,9],
//        [1,5,9],
//        [3,5,7]
//    ]
//}
