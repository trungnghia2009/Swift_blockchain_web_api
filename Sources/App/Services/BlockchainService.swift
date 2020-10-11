//
//  File.swift
//  
//
//  Created by trungnghia on 10/10/20.
//

import Foundation
import Vapor

class BlockchainService {
    
    private (set) var blockchain: Blockchain!
    
    init() {
        self.blockchain = Blockchain(genesisBlock: Block())
    }
    
    func getBlockchain() -> Blockchain {
        return self.blockchain
    }
    
    func getNextBlock(transactions: [Transaction]) -> Block {
        let block = self.blockchain.getNextBlock(transactions: transactions)
        self.blockchain.addBlock(block)
        return block
    }
    
    func registerNodes(nodes: [BlockchainNode]) -> [BlockchainNode] {
        return self.blockchain.registerNodes(nodes: nodes)
    }
    
    func getNodes() -> [BlockchainNode] {
        return self.blockchain.nodes
    }
    
    func resolve(completion: @escaping (Blockchain) -> ()) {
        let nodes = self.blockchain.nodes
        for node in nodes {
            let url = URL(string: "\(node.address)/blockchain")!
            URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
                guard let self = self else { return }
                if let data = data {
                    let blockchain = try! JSONDecoder().decode(Blockchain.self, from: data)
                    
                    // Comparing
                    if self.blockchain.blocks.count > blockchain.blocks.count {
                        completion(self.blockchain)
                    } else {
                        self.blockchain = blockchain
                        completion(blockchain)
                    }
                }
            }.resume()
        }
    }
    
    
}
