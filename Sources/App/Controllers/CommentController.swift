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
        comments.put("update",use: update)
        comments.group("delete"){ com in
            com.delete(":commentID",use: delete)
        }
    }

    //--------------------------------get留言--------------------------------//
   
    func index(req: Request) throws -> EventLoopFuture<[Comment]> {
        
        guard let articleID = req.parameters.get("articleID") as UUID? else{
            throw Abort(.badRequest)
        }
        
        return  Comment.query(on: req.db)
            .with(\.$user)
            .join(Article.self, on: \Comment.$article.$id == \Article.$id)
            .filter(Article.self, \Article.$id == articleID )
            .sort(\.$updatedOn, .descending)
            .all()
  
    }
    
    //--------------------------------新增留言--------------------------------//
   
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
    
    //--------------------------------更新留言內容--------------------------------//
    
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let update = try req.content.decode(UpdateComment.self)

        return Comment.find(update.CommentID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{
                $0.Text = update.Text
                $0.LikeCount = update.LikeCount
                return $0.update(on: req.db).transform(to: .ok)
            }

    }
    
    //--------------------------------刪除留言--------------------------------//
   
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Comment.find(req.parameters.get("commentID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{ $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    
   
}
