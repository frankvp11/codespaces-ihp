module Web.Controller.Posts where

import Web.Controller.Prelude
import Web.View.Posts.Index
import Web.View.Posts.New
import Web.View.Posts.Edit
import Web.View.Posts.Show
import qualified Text.MMark as MMark
import Control.Lens (none, non)
import Application.Script.Prelude (fetchCount)
import Web.View.PostsReactions.Edit (EditView(postsReaction))

instance Controller PostsController where
    action PostsAction = do
        posts <- query @Post
            |> orderByDesc #createdAt 
            |> fetch
        render IndexView { .. }

    action NewPostAction = do
        let post = newRecord
        render NewView { .. }

    action ShowPostAction { postId } = autoRefresh do
        post <- fetch postId
            >>= pure . modify #comments (orderByDesc #createdAt)
            >>= fetchRelated #comments

        reactions <- query @PostsReaction
            |> filterWhere (#postId, get #id post)
            |> distinctOn #emoji
            |> fetch
        
        reactions <- mapM (\r -> do
                            count <- query @PostsReaction
                                |> filterWhere (#postId, post.id)
                                |> filterWhere (#emoji, r.emoji)
                                |> fetchCount
                            pure (r.emoji, count)     
                    ) reactions
        -- commentsReactions should have the shape: [Id, [(Emoji, Count)]]
        commentReactionsRaw <- query @CommentsReaction
            |> filterWhereIn (#commentId, get #id <$> get #comments post)
            |> fetch
        commentsReactions <- mapM (\cr -> do
                        count <- query @CommentsReaction
                            |> filterWhere (#commentId, get #commentId cr)
                            |> filterWhere (#emoji, get #emoji cr)
                            |> fetchCount
                        pure (get #commentId cr, [(get #emoji cr, count)])
            ) commentReactionsRaw





        render ShowView { post = post, postReactions = reactions, commentsReactions = commentsReactions }

    action EditPostAction { postId } = do
        post <- fetch postId
        render EditView { .. }

    action UpdatePostAction { postId } = do
        post <- fetch postId
        post
            |> buildPost
            |> ifValid \case
                Left post -> render EditView { .. }
                Right post -> do
                    post <- post |> updateRecord
                    setSuccessMessage "Post updated"
                    redirectTo EditPostAction { .. }

    action CreatePostAction = do
        let post = newRecord @Post
        post
            |> buildPost
            |> ifValid \case
                Left post -> render NewView { .. } 
                Right post -> do
                    post <- post |> createRecord
                    setSuccessMessage "Post created"
                    redirectTo PostsAction

    action DeletePostAction { postId } = do
        post <- fetch postId
        deleteRecord post
        setSuccessMessage "Post deleted"
        redirectTo PostsAction

buildPost post = post
    |> fill @'["title", "body"]
    |> validateField #title nonEmpty
    |> validateField #body nonEmpty
    |> validateField #body isMarkdown

isMarkdown :: Text -> ValidatorResult
isMarkdown text =
    case MMark.parse "" text of
        Left _ -> Failure "Please provide valid Markdown"
        Right _ -> Success
