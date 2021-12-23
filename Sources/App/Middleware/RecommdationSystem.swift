//
//  SwiftUIView.swift
//  
//
//  Created by JacksonTmm on 23/12/2021.
//

import Vapor
import PythonKit
import FluentPostgresDriver


struct RecommandMiddleWare : Middleware{
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        //Load Python Algorithm
        let sys = Python.import("sys")
        sys.path.append("./py/Cons_sim/")

        
//        guard let postgresSql = (req.db as? PostgresDatabase)?.sql() else {
//            return req.eventLoop.future(error: Abort(.badRequest,reason:"DB INTERNAL ERROR"))

        let recommand = Python.import("main")
        let data = Array<Int>(recommand.getRecommandMovies([1,2,3,4,5]))

        let movieIds = data!.map{String($0)}
        request.headers.add(name: "recommandIds", value: movieIds.joined(separator: ","))
        
        return  next.respond(to: request)
    }
        
}

struct ReferenDataMiddleware : Middleware{
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        print("Fetching Datas here!!!")
        return next.respond(to: request)
    }
}


