module Web.Controller.PostsReactions where

import Web.Controller.Prelude
import Web.View.PostsReactions.Index
import Web.View.PostsReactions.New
import Web.View.PostsReactions.Edit
import Web.View.PostsReactions.Show

instance Controller PostsReactionsController where
    action PostsReactionsAction = do
        postsReactions <- query @PostsReaction |> fetch
        render IndexView { .. }

    action NewPostsReactionAction = do
        let postsReaction = newRecord
        render NewView { .. }


    action ShowPostsReactionAction { postsReactionId } = do
        postsReaction <- fetch postsReactionId
        render ShowView { .. }

    action EditPostsReactionAction { postsReactionId } = do
        postsReaction <- fetch postsReactionId
        render EditView { .. }

    action UpdatePostsReactionAction { postsReactionId } =  do
        postsReaction <- fetch postsReactionId
        postsReaction
            |> buildPostsReaction
            |> ifValid \case
                Left postsReaction -> render EditView { .. }
                Right postsReaction -> do
                    postsReaction <- postsReaction |> updateRecord
                    setSuccessMessage "PostsReaction updated"
                    redirectTo EditPostsReactionAction { .. }

    action CreatePostsReactionAction = autoRefresh do
        let postsReaction = newRecord @PostsReaction

        postsReaction
            |> buildPostsReaction
            |> ifValid \case
                Left postsReaction -> render NewView { .. } 
                Right postsReaction -> do
                    postsReaction <- postsReaction |> createRecord
                    redirectTo ShowPostAction { postId = get #postId postsReaction }

    action DeletePostsReactionAction { postsReactionId } = do
        postsReaction <- fetch postsReactionId
        deleteRecord postsReaction
        setSuccessMessage "PostsReaction deleted"
        redirectTo PostsReactionsAction

buildPostsReaction postsReaction = postsReaction

    |> fill @'["emoji", "postId"]
