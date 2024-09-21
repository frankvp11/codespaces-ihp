module Web.Controller.CommentsReactions where

import Web.Controller.Prelude
import Web.View.CommentsReactions.Index
import Web.View.CommentsReactions.New
import Web.View.CommentsReactions.Edit
import Web.View.CommentsReactions.Show

instance Controller CommentsReactionsController where
    action CommentsReactionsAction = do
        commentsReactions <- query @CommentsReaction |> fetch
        render IndexView { .. }

    action NewCommentsReactionAction = do
        let commentsReaction = newRecord
        render NewView { .. }

    action ShowCommentsReactionAction { commentsReactionId } = do
        commentsReaction <- fetch commentsReactionId
        render ShowView { .. }

    action EditCommentsReactionAction { commentsReactionId } = do
        commentsReaction <- fetch commentsReactionId
        render EditView { .. }

    action UpdateCommentsReactionAction { commentsReactionId } = do
        commentsReaction <- fetch commentsReactionId
        commentsReaction
            |> buildCommentsReaction
            |> ifValid \case
                Left commentsReaction -> render EditView { .. }
                Right commentsReaction -> do
                    commentsReaction <- commentsReaction |> updateRecord
                    setSuccessMessage "CommentsReaction updated"
                    redirectTo EditCommentsReactionAction { .. }

    action CreateCommentsReactionAction = do
        let commentsReaction = newRecord @CommentsReaction
        commentsReaction
            |> buildCommentsReaction
            |> ifValid \case
                Left commentsReaction -> render NewView { .. } 
                Right commentsReaction -> do
                    commentsReaction <- commentsReaction |> createRecord
                    setSuccessMessage "CommentsReaction created"
                    redirectTo CommentsReactionsAction

    action DeleteCommentsReactionAction { commentsReactionId } = do
        commentsReaction <- fetch commentsReactionId
        deleteRecord commentsReaction
        setSuccessMessage "CommentsReaction deleted"
        redirectTo CommentsReactionsAction

buildCommentsReaction commentsReaction = commentsReaction
    |> fill @'["emoji", "commentId"]
