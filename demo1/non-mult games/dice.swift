//
//  dice.swift
//  demo1
//
//  Created by Eric Oh on 2/6/24.
//

import SwiftUI

struct dice_instruction: View {
    var body: some View{
        ZStack{
            Color(.black)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .overlay(
                    ScrollView{
                        Text("Welcome to Liar's Dice! Like BS poker, the objective is to claim what dice combinations exist between everyone's die by making predictions or bluffing when necessary. People who are rightly accused of bluffing or incorrectly accuse someone of bluffing take a drink.\n\nSetup: Each player receives a set of five dice.\n\nGameplay:\n1. The first player, the 'caller,' starts the round by making a bid, stating a quantity and a face value (e.g., 'three 3's' or 'four 2's'). The first bid must have a quantity more than the number of players (eg., if there are four players, the caller can start with 'five 6's' but not 'three 6's').\n\n2. The next player must either raise the bid by increasing the quantity or the face value, challenge the previous bid, or reset the bid by calling 1's. For example, 'four 2's' is higher than 'three 6's' and lower than 'four 3's'.\n\n3. The number 1 on a dice is a wildcard and can represent any number. This means that 2's are the lowest face value in the beginning.\n\n4. A player can reset the bid at any point by calling any number of 1's, even if the quantity is lower than the current bid. After this, 1's no longer act as wild cards in that round and are now the new lowest face value under 2's.\n\n5. If a player challenges the bid, all dice are revealed. If the bid was correct, the challenger takes a drink and restarts the round; if incorrect, the bidder takes a drink and everyone rerolls their die.\n\n6. Having one of every number in consecutive order counts as having no numbers. In particular, '2, 3, 4, 5, 6' or '1, 2, 3, 4, 5' would count as having no die and override the role of 1 as a wildcard.")
                            .foregroundColor(.white)
                            .font(.system(size:15))
                            .padding()
                    }
                )
                .frame(width: 350, height: 600)
                .foregroundColor(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            Spacer()
                .frame(height: 75)
        }
    }
}

struct Dice: View {
    @State private var covered: Bool = true;
    @State private var dice1: Int = -1
    @State private var dice2: Int = -1
    @State private var dice3: Int = -1
    @State private var dice4: Int = -1
    @State private var dice5: Int = -1
    @State private var base: String = "dice"
    
    var body: some View{
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            if covered{
                VStack{
                    Spacer()
                    
                    Button(action: {
                        cover_state()
                    }){
                        Image(systemName: "lock.fill")
                            .resizable()
                            .frame(width: 80, height: 120)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        shuffle()
                    }){
                        Image(systemName: "shuffle.circle")
                            .resizable()
                            .frame(width: 120, height: 120)
                    }
                    
                    Spacer()
                }
            }
            else{
                VStack{
                    Spacer()
                    
                    Button(action: {
                        cover_state()
                    }){
                        Image(systemName: "lock.open.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                    }
                    
                    Spacer()
                    
                    HStack{
                        Spacer()
                        
                        Image(base + String(dice1))
                            .resizable()
                            .frame(width: 100, height: 100)
                        
                        Spacer()
                        
                        Image(base + String(dice2))
                            .resizable()
                            .frame(width: 100, height: 100)
                        
                        Spacer()
                        
                        Image(base + String(dice3))
                            .resizable()
                            .frame(width: 100, height: 100)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack{
                        Spacer()
                        
                        Image(base + String(dice4))
                            .resizable()
                            .frame(width: 100, height: 100)
                        
                        Spacer()
                        
                        Image(base + String(dice5))
                            .resizable()
                            .frame(width: 100, height: 100)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                }
            }
        }
        .onAppear(){
            dice1 = Int.random(in: 1..<7)
            dice2 = Int.random(in: 1..<7)
            dice3 = Int.random(in: 1..<7)
            dice4 = Int.random(in: 1..<7)
            dice5 = Int.random(in: 1..<7)
        }
    }
    func cover_state(){
        covered = !covered
    }
    
    func shuffle(){
        dice1 = Int.random(in: 1..<7)
        dice2 = Int.random(in: 1..<7)
        dice3 = Int.random(in: 1..<7)
        dice4 = Int.random(in: 1..<7)
        dice5 = Int.random(in: 1..<7)
    }
}
