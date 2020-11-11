//
//  ExecutionState.swift
//  XO-game
//
//  Created by Антон Васильченко on 11.11.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

class ExecutionState: GameState {
    var isCompleted = false
    
    private(set) var gameViewController: GameViewController?
    private(set) var gameboard: Gameboard?
    private(set) var gameboardView: GameboardView?
    
    init(
         gameViewController: GameViewController,
         gameboard: Gameboard,
         gameboardView: GameboardView
    ) {
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }
    
    
    func begin() {
        guard let gameViewController = gameViewController, let gameboard = gameboard else {return}
        Invoker.shared.executeCommand(gameVC: gameViewController, gameboard: gameboard)
    }
    
    func addMark(at position: GameboardPosition) {
        
    }
    
    
}
