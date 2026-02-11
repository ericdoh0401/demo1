//
//  coin.swift
//  demo1
//
//  Created by Eric Oh on 2/15/24.
//

// Roll Heads: Tally
// Roll Tails: One of two options
    // 1) Choose to drink that much
    // 2) Roll again for the chance to assign (tally + 1) drinks amongst the group
        // a) if you roll heads, you drink and keep on going
        // b) if you roll tails, you assign the (tally + 1) drinks

import SwiftUI

struct Coin: View {
    @State private var curState: Bool = false
    @State private var isHeads: Bool = true
    @State private var degreesToFlip: Int = 0
    @State private var curPlayer: Int = 1
    @State private var headCount: Int = 0
    @State private var activate: Bool = false
    @State private var base_length: Int = -1
    @State private var textValue: String = ""
    @State private var feelingLucky: Bool = false
    @State private var pass: Bool = false
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(UIColor(red: 5/255, green: 30/255, blue: 100/255, alpha: 1)), .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            if base_length == -1{
                VStack{
                    HStack{
                        Spacer()
                        
                        Text("Player count:")
                        TextField("Max 10 players", text: $textValue)
                            .textFieldStyle(.roundedBorder)
                        
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Button(action: {
                        if textValue == "" {
                            base_length = 2
                        } else {
                            base_length = Int(textValue)!
                        }
                    }) {
                        Text("Enter")
                            .bold()
                            .foregroundColor(.black)
                            .frame(width: 200, height: 25)
                    }
                    .background(Color.green)
                    .clipShape(.capsule)
                }
            }
            
            else{
                if pass{
                    Text("You need to take " + String(headCount) + " sip(s)!")
                        .font(.title)
                        .bold()
                    
                    Button(action:{
                        pass.toggle()
                        headCount = 0
                        }){
                            Text("Complete!")
                                .bold()
                                .foregroundColor(.black)
                                .frame(width: 200, height: 60)
                        }
                        .background(Color.green)
                        .clipShape(.capsule)
                        .offset(y: 70)
                }
                else if feelingLucky{
                    if isHeads {
                        VStack{
                            Text("You rolled Heads!")
                                .font(.title)
                                .bold()
                                .frame(alignment: .center)
                            
                            Spacer()
                                .frame(height: 30)
                            
                            Text("Take " + String(headCount - 1) + " sip(s) and keep flipping!")
                                .font(.title)
                                .bold()
                                .frame(alignment: .center)
                            
                            Spacer()
                                .frame(height: 30)
                            
                            Button(action: {
                                feelingLucky.toggle()
                                headCount = 0
                            }) {
                                Text("Complete!")
                                    .bold()
                                    .foregroundColor(.black)
                                    .frame(width: 200, height: 60)
                            }
                            .background(Color.green)
                            .clipShape(.capsule)
                        }
                    }
                    else {
                        VStack {
                            Text("Assign " + String(headCount + 1) + " sip(s) between/among the group")
                                .font(.title)
                                .bold()
                                .padding(.trailing, 20)
                                .frame(alignment: .center)

                            Spacer().frame(height: 30)

                            Button(action: {
                                activate.toggle()
                                feelingLucky.toggle()
                                headCount = 0
                                curPlayer = (curPlayer % base_length) + 1
                                
                            }) {
                                Text("Complete!")
                                    .bold()
                                    .foregroundColor(.black)
                                    .frame(width: 200, height: 60)
                            }
                            .background(Color.green)
                            .clipShape(.capsule)
                        }
                    }
                }
                else{
                    ZStack{
                        CupShape(cupWidth: 740, cupTopWidth: 220)
                            .frame(height: 720)
                            .offset(y: 220)
                            .foregroundColor(Color(UIColor(red: 10/255.0, green: 7/255.0, blue: 40/255.0, alpha: 1)))
                        
                        CupShape(cupWidth: 700, cupTopWidth: 200)
                            .frame(height: 700)
                            .offset(y: 220)
                            .foregroundColor(Color(UIColor(red: 101/255.0, green: 7/255.0, blue: 40/255.0, alpha: 1)))
                    }
                    
                    Circle()
                        .frame(width: curState ? 120 : 0)
                        .foregroundColor(Color(UIColor(red: 103/255.0, green: 76/255.0, blue: 40/255.0, alpha: 1)))
                        .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 0, z: 0))
                    
                    Circle()
                        .frame(width: curState ? 0 : 120)
                        .foregroundColor(Color(UIColor(red: 103/255.0, green: 76/255.0, blue: 40/255.0, alpha: 1)))
                        .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 0, z: 0))
                    
                    VStack{
                        Spacer()
                        
                        VStack{
                            Text("Player " + String(curPlayer) + "'s Turn")
                            Text("Sip Count: " + String(headCount))
                        }
                        .font(.title)
                        .foregroundColor(.white)
                        .offset(y: -100)
                        
                        Spacer()
                            .frame(height: 100)
                        
                        CoinFig(curState: $curState, isHeads: $isHeads)
                            .rotation3DEffect(Angle(degrees: Double(degreesToFlip)), axis: (x: 1, y: 0, z: 0))
                        //                    .rotationEffect(Angle(degrees: 0), anchor: .center)
                        
                        Spacer()
                            .frame(height: 110)
                        
                        if !activate{
                            Button(action: {
                                degreesToFlip = 0
                                flipCoin()
                            }) {
                                Text("Flip Coin")
                                    .bold()
                                    .foregroundColor(.black)
                                    .frame(width: 200, height: 60)
                            }
                            .background(Color.green)
                            .clipShape(.capsule)
                            .offset(y: 70)
                        }
                        else{
                            HStack{
                                Button(action: {
                                    withAnimation {
                                        degreesToFlip = 0
                                        flipCoin()
                                    }
                                    
                                    // This closure will be executed when the animation completes
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.05) {
                                        feelingLucky.toggle()
                                    }
                                }) {
                                    Text("Feeling Lucky?")
                                        .bold()
                                        .foregroundColor(.black)
                                        .frame(width: 150, height: 60)
                                }
                                .background(Color.red)
                                .clipShape(.capsule)
                                .offset(y: 70)
                                
                                Spacer()
                                    .frame(width: 50)
                                
                                Button(action: {
                                    degreesToFlip = 0
                                    curPlayer = (curPlayer % base_length) + 1
                                    activate.toggle()
                                    pass.toggle()
                                    // needs a display saying that they need to drink
                                    // that much.
                                    //                                flipCoin()
                                }) {
                                    Text("I'll pass")
                                        .bold()
                                        .foregroundColor(.black)
                                        .frame(width: 150, height: 60)
                                }
                                .background(Color.green)
                                .clipShape(.capsule)
                                .offset(y: 70)
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    func reset() {
        curState.toggle()
    }
    
    func flipCoin() {
        withAnimation(Animation.easeInOut(duration: 1)){
            let random = Int.random(in: 5...12)
            
            degreesToFlip = (random * 180)
            
            isHeadsOrTails()
            curState.toggle()
        }
//        reset()
    }
    
    func isHeadsOrTails() {
        let div = (degreesToFlip / 180)
        (div % 2 == 0) ? (isHeads = true) : (isHeads = false)
        if isHeads {
            activate = false
            headCount += 1
        }
        else {
            degreesToFlip += 180
            activate = true
        }
        print(activate)
    }
}

struct CoinFig: View {
    @Binding var curState: Bool
    @Binding var isHeads: Bool
    
    var body: some View {
        ZStack {
            
            CoinSide(color: Color(UIColor(red: 205/255.0, green: 127/255.0, blue: 50/255.0, alpha: 1)), text: isHeads ? "person.circle" : "number.circle")
                .opacity(curState ? 1 : 0)
                .offset(y: curState ? 0 : 20)
            
            CoinSide(color: Color(UIColor(red: 205/255.0, green: 127/255.0, blue: 50/255.0, alpha: 1)), text: isHeads ? "person.circle" : "number.circle")
                .opacity(curState ? 0 : 1)
                .offset(y: curState ? 20 : 0)
        }
    }
}

struct CoinSide: View {
    var color: Color
    var text: String
    
    var body: some View {
        Circle()
            .frame(width: 100)
            .foregroundColor(color)
            .overlay(
                Image(systemName: text)
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 50, height: 50)
            )
            .overlay(
                Circle()
                    .stroke(Color(UIColor(red: 180/255.0, green: 127/255.0, blue: 40/255.0, alpha: 1)), lineWidth: 5) // Adjust the lineWidth as needed
            )
            .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 0, z: 0))
    }
}


struct coin_instruction: View {
    var body: some View{
        ZStack{
            Color(.black)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .overlay(
                    ScrollView{
                        Text("Embark on the Coin Toss Challenge with your friends. Strategize, take risks, and enjoy the moments as you play this exciting game. Here's how to play:\n\nSetup: Each player begins with a clean slate, ready to tally their sips.\n\nThe Coin Toss:\n1. Landing on Heads adds to your sip tally.\n\n2. Consecutive Heads increase your tally with each flip, and you'll have to drink that much unless Tails intervenes.\n\n3. A mysterious Tails presents you with a choice:\n\n - Option 1 (I'll pass): Play it safe. Accept sips equal to your current tally and pass the coin to the next player.\n\n - Option 2 (Feeling Lucky?): Embrace the risk! Spin the coin again. If Heads, drink the accumulated sips and continue the challenge. If Tails, distribute (tallies + 1) sips among your friends.")
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

#Preview {
    Coin()
}
