//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/6/3.
//

import Foundation
import Fluent
import Vapor

struct CommentController: RouteCollection{
    
    func boot(routes: RoutesBuilder) throws {
        
        let comments = routes.grouped("comment")
        comments.get(":articleID",use: index)
        comments.post(use: create)
        comments.group("delete"){ com in
            com.delete(":commentID",use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Comment]> {
        
        guard let articleID = req.parameters.get("articleID") as UUID? else{
            throw Abort(.badRequest)
        }
        
        return  Comment.query(on: req.db)
            .with(\.$user)
            .join(Article.self, on: \Comment.$article.$id == \Article.$id)
            .filter(Article.self, \Article.$id == articleID )
            .all()
  
    }
   
    
    func create(req: Request) throws -> EventLoopFuture<Comment> {
        let todo = try req.content.decode(CommentTodo.self)
        
        return User.query(on: req.db)
            .filter(\.$UserName == todo.UserName)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap{ usr in
                Article.query(on: req.db)
                    .filter(\.$id == todo.ArticleID)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap{ art in
                        let comment = Comment(Text: todo.Text, user: usr, article: art, LikeCount: todo.LikeCount)
                        return comment.create(on: req.db).map{ comment }
                    }
            }
    }
   
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Comment.find(req.parameters.get("commentID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{ $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    
   
}
