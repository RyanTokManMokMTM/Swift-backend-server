import Fluent
import Vapor

/*
 ORM:
 -->Used for algoritgmn(may need)
 Actor
 Director
 Genre
 
 //For the actor and director ,according to algorithmn ?????????
 
 */

func routes(_ app: Application) throws {
    try app.register(collection: ListMovieController()) //片單內容
    try app.register(collection: ListController())      //片單
    try app.register(collection: CommentController())   //文章留言
    try app.register(collection: ArticleController())   //討論區文章
    // try app.register(collection: MovieAPIController())  //電影資訊
    try app.register(collection: UserController())      //登入註冊
    try app.register(collection: APIController())     //API stuff
}
