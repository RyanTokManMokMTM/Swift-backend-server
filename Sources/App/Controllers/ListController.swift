//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/9/24.
//

import Foundation
import Fluent
import Vapor

struct ListController: RouteCollection{
    
    func boot(routes: RoutesBuilder) throws {
        
        let lists = routes.grouped("list")
        lists.get(use: GetAllList)
        lists.group("my"){ lis in
            lis.get(":userID",use: GetMyList)
        }
        
//        lists.post(use: create)
//        lists.group("delete"){ lis in
//            lis.delete(":commentID",use: delete)
//        }
    }

    func GetAllList(req: Request) throws -> EventLoopFuture<[List]> {

        return  List.query(on: req.db)
            .with(\.$user)
            .all()

    }
    
    func GetMyList(req: Request) throws -> EventLoopFuture<[List]> {

        guard let userID = req.parameters.get("userID") as UUID? else{
            throw Abort(.badRequest)
        }
        
        return  List.query(on: req.db)
            .with(\.$user)
            .filter(List.self, \List.$user.$id == userID )
            .all()

    }
//
//
//    func create(req: Request) throws -> EventLoopFuture<Comment> {
//        let todo = try req.content.decode(CommentTodo.self)
//
//        return User.query(on: req.db)
//            .filter(\.$UserName == todo.UserName)
//            .first()
//            .unwrap(or: Abort(.notFound))
//            .flatMap{ usr in
//                Article.query(on: req.db)
//                    .filter(\.$id == todo.ArticleID)
//                    .first()
//                    .unwrap(or: Abort(.notFound))
//                    .flatMap{ art in
//                        let comment = Comment(Text: todo.Text, user: usr, article: art, LikeCount: todo.LikeCount)
//                        return comment.create(on: req.db).map{ comment }
//                    }
//            }
//    }
//
//    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
//        return Comment.find(req.parameters.get("commentID"), on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap{ $0.delete(on: req.db) }
//            .transform(to: .ok)
//    }
//
    
   
}
