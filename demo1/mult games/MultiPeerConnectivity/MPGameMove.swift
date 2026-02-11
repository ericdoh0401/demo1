//
//  MPGameMove.swift
//  MultiPlayer
//
//  Created by Eric Oh on 2/26/24.
//

import Foundation


struct MPGameMove: Codable {
    enum Action: Int, Codable {
        case start, nextPlayer, nextRound, report, end
    }
    let action: Action
    let playerName: String?
    let reportInitiated: Bool
    let players: [Player]

    func data() -> Data?{
        try? JSONEncoder().encode(self)

    }
}
