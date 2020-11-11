//
//  Invoker.swift
//  XO-game
//
//  Created by Антон Васильченко on 11.11.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

final class Invoker {
    
    static let shared = Invoker()
    
    private let moveCount = 5
    
    private var commands: [Command] = []
    
    func addMoveCommand(_ command: Command) -> Bool {
        commands.append(command)
        let playerCommands = commands.filter { $0.player == command.player }
        return playerCommands.count == moveCount
    }
    
    func executeCommand(gameVC: GameViewController, gameboard: Gameboard) {
        let player1Commands = commands.filter { $0.player == .first }
        let player2Commands = commands.filter { $0.player == .second }
        
        var newCommands: [Command] = []
        for index in (0 ..< 5) {
            newCommands.append(player1Commands[index])
            newCommands.append(player2Commands[index])
        }
        
        DispatchQueue.global().async {
            newCommands.forEach {
                $0.execute()
                let referee = Referee(gameboard: gameboard)
                if let winner = referee.determineWinner() {
                    let state = GameEndedState(winner: winner, gameViewController: gameVC)
                    state.begin()
                }
                sleep(1)
            }
            newCommands = []
            self.commands = []
        }
        
    }
    
    func checkMoves() -> Bool {
        return commands.count == moveCount * 2
    }
}
