import Fluent
import Vapor


func routes(_ app: Application) throws {
    
    try app.register(collection: CommentController())   //文章留言
    try app.register(collection: ArticleController())   //討論區文章
    try app.register(collection: MovieAPIController())  //電影資訊
    try app.register(collection: UserController())      //登入註冊
    
    

//    //----------------------------測試----------------------------//
//    //ROUTE GROUPS
//    let users = app.grouped("user")
//
//    // /users (show)
//    users.get { req in
//        User.query(on: req.db).all()
//    }
//
//    // /users/id (find)
//    users.get(":userID") { req -> EventLoopFuture<User> in
//        User.find(req.parameters.get("userID"), on: req.db)
//            .unwrap(or: Abort(.notFound))   //找不到userID就回傳not found
//    }
//
//    // /users PUT (update)
//    users.put { req -> EventLoopFuture<HTTPStatus> in
//        let user = try req.content.decode(User.self)    // content = body of http request
//
//        return User.find(user.id, on: req.db)
//            .unwrap(or: Abort(.notFound))   //找不到userID就回傳not found
//            .flatMap{
//                $0.UserName=user.UserName
//                $0.Email=user.Email
//                $0.Password=user.Password
//                return $0.update(on: req.db).transform(to: .ok)
//            }
//    }
//
//    // /users POST (create)
//    users.post { req -> EventLoopFuture<User> in
//        let user = try req.content.decode(User.self)    // content = body of http request
//        return user.create(on: req.db).map { user }
//    }
//
//    // /users DELETE (delete)
//    users.delete(":userID") { req -> EventLoopFuture<HTTPStatus> in
//        User.find(req.parameters.get("userID"), on: req.db)
//            .unwrap(or: Abort(.notFound))   //找不到userID就回傳not found
//            .flatMap{
//                $0.delete(on:req.db)
//            }.transform(to: .ok)
//    }
    

}
