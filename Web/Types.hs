module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types
import IHP.LoginSupport.Types -- <---- ADD THIS IMPORT

data WebApplication = WebApplication deriving (Eq, Show)


data StaticController = WelcomeAction deriving (Eq, Show, Data)

data PostsController
    = PostsAction
    | NewPostAction
    | ShowPostAction { postId :: !(Id Post) }
    | CreatePostAction
    | EditPostAction { postId :: !(Id Post) }
    | UpdatePostAction { postId :: !(Id Post) }
    | DeletePostAction { postId :: !(Id Post) }
    deriving (Eq, Show, Data)

data CommentsController
    = CommentsAction
    | NewCommentAction {postId:: !(Id Post)}
    | ShowCommentAction { commentId :: !(Id Comment) }
    | CreateCommentAction
    | EditCommentAction { commentId :: !(Id Comment) }
    | UpdateCommentAction { commentId :: !(Id Comment) }
    | DeleteCommentAction { commentId :: !(Id Comment) }
    deriving (Eq, Show, Data)

data PostsReactionsController
    = PostsReactionsAction
    | NewPostsReactionAction
    | ShowPostsReactionAction { postsReactionId :: !(Id PostsReaction) }
    | CreatePostsReactionAction
    | EditPostsReactionAction { postsReactionId :: !(Id PostsReaction) }
    | UpdatePostsReactionAction { postsReactionId :: !(Id PostsReaction) }
    | DeletePostsReactionAction { postsReactionId :: !(Id PostsReaction) }
    deriving (Eq, Show, Data)


instance HasNewSessionUrl User where
    newSessionUrl _ = "/NewSession"

type instance CurrentUserRecord = User

data SessionsController
    = NewSessionAction
    | CreateSessionAction
    | DeleteSessionAction
    deriving (Eq, Show, Data)

data UsersController
    = UsersAction
    | NewUserAction
    | ShowUserAction { userId :: !(Id User) }
    | CreateUserAction
    | EditUserAction { userId :: !(Id User) }
    | UpdateUserAction { userId :: !(Id User) }
    | DeleteUserAction { userId :: !(Id User) }
    deriving (Eq, Show, Data)

data CommentsReactionsController
    = CommentsReactionsAction
    | NewCommentsReactionAction
    | ShowCommentsReactionAction { commentsReactionId :: !(Id CommentsReaction) }
    | CreateCommentsReactionAction
    | EditCommentsReactionAction { commentsReactionId :: !(Id CommentsReaction) }
    | UpdateCommentsReactionAction { commentsReactionId :: !(Id CommentsReaction) }
    | DeleteCommentsReactionAction { commentsReactionId :: !(Id CommentsReaction) }
    deriving (Eq, Show, Data)
