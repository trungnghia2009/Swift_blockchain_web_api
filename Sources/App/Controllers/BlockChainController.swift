//
//  File.swift
//  
//
//  Created by trungnghia on 10/10/20.
//

import Vapor

class BlockchainController {
    
    private (set) var blockchainService: BlockchainService!
    
    init() {
        self.blockchainService = BlockchainService()
    }
    
    func greet(req: Request) -> EventLoopFuture<Response> {
        return "Welcome to Blockchain".encodeResponse(for: req)
    }
    
    func getBlockchain(req: Request) -> Blockchain {
        return self.blockchainService.getBlockchain()
    }
    
    func mine(req: Request, transaction: Transaction) -> Block {
        return self.blockchainService.getNextBlock(transactions: [transaction])
    }
    
    func registerNodes(req: Request, nodes: [BlockchainNode]) -> [BlockchainNode] {
        return self.blockchainService.registerNodes(nodes: nodes)
    }
    
    func getNodes(req: Request) -> [BlockchainNode] {
        return self.blockchainService.getNodes()
    }
    
    func resolve(req: Request) -> EventLoopFuture<Blockchain> {
        let promise: EventLoopPromise<Blockchain> = req.eventLoop.makePromise()
        blockchainService.resolve {
            promise.succeed($0)
        }
        
        return promise.futureResult
    }
}
