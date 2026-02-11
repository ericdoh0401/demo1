// check out firebase

import SwiftUI
import os.log
//import GameKit

struct Liar_instruction: View {
    var body: some View{
        ZStack{
            Color(.black)
                .ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .overlay(
                    ScrollView{
                        Text("Welcome to 'BS Poker'. Each player starts with 2 cards and takes turns guessing the highest poker hand on the table. Guesses escalate until someone calls 'bs.' If the last guess exists, the caller takes an sip; otherwise, the guesser takes it. The game continues with escalating hands until someone reaches 6 cards and loses. Strategies include mixing lies with truths and table position tactics. Aces are high/low, straights can wrap, and table talk is encouraged.")
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

struct Liar_Start_View: View {
    @EnvironmentObject var game: GameService
    @StateObject var connectionManager: MPConnectionManager
    @State private var gameType: GameType = .undetermined
    @AppStorage("yourName") var yourName = ""
    @State private var opponentName = ""
    @State private var gameCodeID = ""
    @FocusState private var focus: Bool
    @State private var startGame = false
    @State private var changeName = false
    @State private var newName = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var constant: Bool = true
    
    init(yourName: String){
        self.yourName = yourName
        _connectionManager = StateObject(wrappedValue: MPConnectionManager(yourName: yourName, gameName: "liar_poker"))
    }
    
    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()
            
            VStack {
                Picker("Select Game", selection: $gameType) {
                    Text("Select Game Type").tag(GameType.undetermined)
                    Text("Join Game").tag(GameType.join)
                    Text("Host Game").tag(GameType.host)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 2))
                .accentColor(.primary)
                
                Text(gameType.description)
                    .padding()
                VStack {
                    switch gameType {
                    case .join:
                        MPJoinView(startGame: $startGame)
                            .environmentObject(connectionManager)
                    case .host:
                        MPHostsView(startGame: $startGame)
                            .environmentObject(connectionManager)
                    case .start:
                        EmptyView()
                    case .undetermined:
                        EmptyView()
                    }
                }
                .padding()
                .textFieldStyle(.roundedBorder)
                .focused($focus)
                .frame(width: 350)
                
                if gameType == .undetermined {
                    Text("Your gamerID is \(yourName)")
                    
                    Spacer()
                        .frame(height: 50)
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                    Spacer()
                        .frame(height: 50)
                    
                    Button("Change my gamerID"){
                        changeName.toggle()
                    }
                    .frame(maxWidth: 200, maxHeight: 50)
                    .background(Color.blue)
                    .cornerRadius(20)
                    .padding()
                    .bold()
                }
                else if gameType == .join {
                    EmptyView()
                }
                else{
                    EmptyView()
                }
                Spacer()
            }
            .padding()
            .fullScreenCover(isPresented: $startGame) {
                Liar_Game_View()
                    .environmentObject(connectionManager)
            }
            .alert("Change Name", isPresented: $changeName, actions: {
                TextField("New name", text: $newName)
                Button("OK", role: .destructive){
                    yourName = newName
                    exit(-1)
                }
                Button("Cancel", role: .cancel){}
            }, message: {
                Text("Tapping on the OK button will quit the application so you can relaunch to use your changed name.")
            })
        }
        .onAppear(){
            self.game.gameName = "liar_poker"
            print(self.game.gameName)
        }
    }
}

struct StartView_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Liar_Start_View(yourName: "Sample5")
            .environmentObject(GameService())
    }
}
