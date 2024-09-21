module Web.View.CommentsReactions.Edit where
import Web.View.Prelude

data EditView = EditView { commentsReaction :: CommentsReaction }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit CommentsReaction</h1>
        {renderForm commentsReaction}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "CommentsReactions" CommentsReactionsAction
                , breadcrumbText "Edit CommentsReaction"
                ]

renderForm :: CommentsReaction -> Html
renderForm commentsReaction = formFor commentsReaction [hsx|
    {(textField #emoji)}
    {(textField #commentId)}
    {submitButton}

|]