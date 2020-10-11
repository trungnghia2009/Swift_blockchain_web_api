import Vapor

func routes(_ app: Application) throws {
    
    // For blockchain
    let blockChainController = BlockchainController()
    app.get("hello", use: blockChainController.greet)
    app.get("blockchain", use: blockChainController.getBlockchain)
    
    // Centralize
    app.post("mine") { req -> Block in
        let data = try req.content.decode(Transaction.self)
        return blockChainController.mine(req: req, transaction: data)
    }
    
    // Add nodes
    app.post("nodes", "register") { req -> [BlockchainNode] in
        let data = try req.content.decode([BlockchainNode].self)
        let nodes = blockChainController.registerNodes(req: req, nodes: data)
        print("Total nodes: \(nodes.count)")
        return nodes
    }
    
    app.get("nodes", use: blockChainController.getNodes)
    
    // Resolve conflict
    app.get("resolve", use: blockChainController.resolve)
}
