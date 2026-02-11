//
//  kings.swift
//  demo1
//
//  Created by Eric Oh on 2/6/24.
//

import SwiftUI

struct king_instruction: View {
    var body: some View{
        ZStack{
            Color(.black)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .overlay(
                    ScrollView{
                        Text("Welcome to King's Cup, a lively card game designed for a group of three or more people. Prepare for an evening filled with laughter, challenges, and a bit of unpredictability.\n\nHow to play: Each player takes turns drawing a card from the shuffled deck. The drawn card corresponds to a specific task, as outlined below.\n\nCard Tasks:\n1. Ace (Paranoia): Ask the person next to you a question that can be answered with someone in the group. The person being asked must respond with an answer, and they can choose to do rock-paper-scissors with the person mentioned in the answer. If they win, they get to know the question; if they lose, they don't.\n\n2. Two (You): Assign someone in the group to drink for that round.\n\n3. Three (Me): You drink.\n\n4. Four (Whores): Everyone who identifies as female drinks.\n\n5. Five (Drive): Play a game of vroom-skirt (interpret creatively).\n\n6. Six (Dicks): All men in the group take a drink.\n\n7. Seven (Heaven): Everyone points to the sky. The last person to point loses and drinks.\n\n8. Eight (Mate): The person who drew this card picks someone to partner up with, and both partners drink for the whole game.\n\n9. Nine (Rhyme): The person who draws this card says a word. Each person in clockwise order must say a word that rhymes with that word. The last person who cannot rhyme or repeats a word drinks.\n\n10. Ten (Categories): The person who draws this card says a category. Each person in clockwise order must say a word that belongs to that category. The last person who cannot think of a word or repeats a word drinks.\n\n11. Jack (Never Have I Ever): Play a game of 'Never Have I Ever' with three strikes.\n\n12. Queen (Question Master): The person who draws this card becomes the Question Master. They must get someone to answer their question throughout the game. If they fail, they drink when the new Question Master is assigned.\n\n13. King (Rule Enforcer): The person who draws this card creates a rule that lasts until the end of the game.\n\nAdditional Twists: Throughout the round, two people at random will be assigned to drink, just to keep things interesting!")
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

struct Kings: View{
    @State private var cards: [String] = []
    @State private var complete: Bool = false
    @State private var curIndex: Int = 0
    @State private var drinkPenalty: Int = 2
    @State private var rand1: Int = -1
    @State private var rand2: Int = -1
    @State private var yi: Bool = false
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors:[.orange.adjustBrightness(by: 0.8), .yellow], startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
//            Image("background")
//                .resizable()
//                .ignoresSafeArea()
            
            if complete{
                Image("complete")
                    .resizable()
                    .frame(width: 300, height: 300)
            }
            
            else if yi{
                VStack{
                    Image("you're_it")
                        .resizable()
                        .frame(width: 300, height: 300)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Button(action: {
                        drank()
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                    }
                }
            }
            
            else {
                VStack {
//                    Spacer()
//                        .frame(height: 150)
                    
                    Text("Kings Cup")
                        .font(.largeTitle)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Text("Drink Penalty Count: " + String(drinkPenalty))
                        .font(.title)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Text("Current card count: " + String(curIndex + 1))
                        .font(.title2)
                    
                    Spacer()
//                        .frame(height: 20)
                    
                    
                    if curIndex < cards.count {
                        Image(cards[curIndex])
                            .resizable()
                            .frame(width: 200, height: 280)
                    }
                    
                    Spacer()
//                        .frame(height: 20)
                    
                    
                    Button(action: {
                        nextCard()
                    }) {
                        Image(systemName: "arrowshape.right.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear{
            let cardMan = CardManager()
            cards = cardMan.cards
            rand1 = Int.random(in: 0..<52)
            rand2 = Int.random(in: 0..<52)
        }
    }
    
    
    func nextCard(){
        curIndex += 1
        
        if curIndex == rand1 || curIndex == rand2 {
            yi = true
        }
        
        if curIndex == 52{
            complete = true
        }
    }
    
    func drank(){
        yi = false
        drinkPenalty -= 1
    }
    
}
