import Fluent
import Vapor


func routes(_ app: Application) throws {
    try app.register(collection: ListMovieController()) //片單內容
    try app.register(collection: ListController())      //片單
    try app.register(collection: CommentController())   //文章留言
    try app.register(collection: ArticleController())   //討論區文章
    try app.register(collection: MovieAPIController())  //電影資訊
    try app.register(collection: UserController())      //登入註冊

        
//    try app.register(collection: SearchController())     //Search stuff
    
    //Group our all rounte with api prefix
    app.group("api"){ api in
        //all every request with uri /api/... will get in here to routing
        
        //controller instance
        let playgroundControllor = PlaygroundController()
        
//        let search = api.grouped("search")
        let playground = api.grouped("playground")
        
        //Searching route
        
        // /api/playground/....
        //GragAndDrop playground Item route
        playground.get("getGenre", use: playgroundControllor.getGenre)
        playground.get("getActor", use: playgroundControllor.getActor)
        playground.get("getDirector",use: playgroundControllor.getDirector)
//
//
        
        
    }
    
    

}
