//
//  higher_or_lower.swift
//  demo1
//
//  Created by Eric Oh on 2/6/24.
//

import SwiftUI

struct HOL_instruction: View {
    var body: some View{
        ZStack{
            Color(.black)
                .ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .overlay(
                    ScrollView{
                        Text("Welcome to the 'Higher or Lower' challenge! In this game, you'll be testing your intuition and luck as you navigate through three stacks of cards. Here's how to play:\n\nObjective: Your goal is to successfully predict whether the next card drawn from the deck will be higher, lower, or equal to the card on the top of the current stack.\n\nGameplay:\n1. You begin with the first stack. The top card of this stack is your starting point.\n\n2. Guess whether the next card will be higher, lower, or equal to the card on top of the current stack.\n\n3. If your guess is correct, you continue with the same stack. If incorrect, you move on to the next stack.\n\n4. The order of the cards is from 2 (lowest) to Ace (highest).\n\n5. If you successfully navigate through all three stacks and finish the deck, you win the game!\n\n6. However, if you make an incorrect guess and exhaust all three stacks, unfortunately, you lose.\n\nTips:\n1. Pay attention to the cards on each stack and try to anticipate the sequence.\n2. Trust your instincts but remember that luck plays a role too.\n\nGood luck! May your guesses be accurate as you aim to conquer all three stacks and emerge victorious in the 'Higher or Lower' challenge!")
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

struct HOL: View {
    @State private var cards: [String] = []
    @State private var currentStackIndex: Int = 0
    @State private var curIndex: Int = 3
    @State private var stack1: Int = 0
    @State private var stack2: Int = 1
    @State private var stack3: Int = 2
    @State private var winCount: Int = 52
    @State private var loss: Bool = false
    @State private var win: Bool = false
    


    var body: some View {
        ZStack {
            LinearGradient(colors:[.red, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
//            Image("background")
//                .resizable()
//                .ignoresSafeArea()
            
            if win {
                Image("you_win")
                    .resizable()
                    .frame(width: 300, height: 200)
            }
            
            else if loss {
                VStack {
                    Image("you_lose")
                        .resizable()
                        .frame(width: 300, height: 200)
                    
                    Text("You got " + String(curIndex) + " correct.")
                        .font(.largeTitle)
                }
            }
            
            else {
                
                VStack {
                    Spacer()
                        .frame(height: 50)
                    
                    Text("Higher or Lower?")
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Text("Guess " + String(winCount) + " to win")
                        .font(.title)
                        .bold()
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Text("Current card count: " + String(curIndex))
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    HStack{
                        Spacer()
                        
                        if stack1 < cards.count{
                            if currentStackIndex == 0 {
                                Image(cards[stack1])
                                    .resizable()
                                    .frame(width: 100, height: 140)
                                    .shadow(color: .black, radius: 15)
                            }
                            else {
                                Image(cards[stack1])
                                    .resizable()
                                    .frame(width: 100, height: 140)
                            }
                        }
                        
                        Spacer()
                        
                        if stack2 < cards.count{
                            if currentStackIndex == 1 {
                                Image(cards[stack2])
                                    .resizable()
                                    .frame(width: 100, height: 140)
                                    .shadow(color: .black, radius: 15)
                            }
                            else {
                                Image(cards[stack2])
                                    .resizable()
                                    .frame(width: 100, height: 140)
                            }
                        }
                        
                        Spacer()
                        
                        if stack3 < cards.count{
                            if currentStackIndex == 2 {
                                Image(cards[stack3])
                                    .resizable()
                                    .frame(width: 100, height: 140)
                                    .shadow(color: .black, radius: 15)
                            }
                            else{
                                Image(cards[stack3])
                                    .resizable()
                                    .frame(width: 100, height: 140)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            makeGuess(action: .higher)
                        }) {
                            Image(systemName: "arrow.up.circle")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color(.systemPink))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            makeGuess(action: .lower)
                        }) {
                            Image(systemName: "arrow.down.circle")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color(.systemPink))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            makeGuess(action: .equal)
                        }) {
                            Image(systemName: "equal.circle")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color(.systemPink))
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear{
            let cardMan = CardManager()
            cards = cardMan.cards
        }
    }

    func makeGuess(action: ActionType) {
        if curIndex == winCount - 1 {
            win = true
            print("You win")
            return
        }
        
        let nextCard = cards[curIndex]
        
        print(currentTopCard(), nextCard)

        if checkGuess(topCard: currentTopCard(), nextCard: nextCard, action: action) {
            if currentStackIndex == 0 {
                stack1 = curIndex
            }
            else if currentStackIndex == 1{
                stack2 = curIndex
            }
            else{
                stack3 = curIndex
            }
            print("Correct guess")
        } else {
            if currentStackIndex == 0 {
                stack1 = curIndex
            }
            else if currentStackIndex == 1{
                stack2 = curIndex
            }
            else{
                stack3 = curIndex
            }
            currentStackIndex += 1

            if currentStackIndex < 3 {
                print("Incorrect guess. Moving to the next stack.")
                print(currentStackIndex)
            } else {
                loss = true
                print("Player loses")
            }
        }
        
        curIndex += 1
    }

    func currentTopCard() -> String {
        if currentStackIndex == 0 {
            return cards[stack1]
        }
        else if currentStackIndex == 1 {
            return cards[stack2]
        }
        else{
            return cards[stack3]
        }
    }

    func checkGuess(topCard: String?, nextCard: String, action: ActionType) -> Bool {
        guard let topCard = topCard else {
            // Unable to make a guess without a top card
            return false
        }

        switch action {
        case .higher:
            return compareCards(card1: topCard, card2: nextCard) < 0
        case .lower:
            return compareCards(card1: topCard, card2: nextCard) > 0
        case .equal:
            return compareCards(card1: topCard, card2: nextCard) == 0
        }
    }

    func compareCards(card1: String, card2: String) -> Int {
        
        let components1 = card1.components(separatedBy: "_")
        let components2 = card2.components(separatedBy: "_")

        if let num1 = Int(components1.first ?? ""), let num2 = Int(components2.first ?? "") {
            let result = num1 - num2
            return result
        } else {
            return 0
        }
    }
}
