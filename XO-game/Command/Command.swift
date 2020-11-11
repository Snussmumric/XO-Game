//
//  Command.swift
//  XO-game
//
//  Created by Антон Васильченко on 11.11.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

final class Command {
    let player: Player
    let position: GameboardPosition
    
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    
    init(player: Player, position: GameboardPosition, gameboard: Gameboard, gameboardView: GameboardView) {
        self.player = player
        self.position = position
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }
    
    func execute() {
        DispatchQueue.main.async {
            guard let gameboardView = self.gameboardView, let gameboard = self.gameboard else { return }
            gameboard.setPlayer(self.player, at: self.position)
            gameboardView.removeMarkView(at: self.position)
            gameboardView.placeMarkView(self.player.markViewPrototype.copy(), at: self.position)
        }
    }
    
}
