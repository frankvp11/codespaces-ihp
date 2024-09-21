module Web.View.CommentsReactions.New where
import Web.View.Prelude

data NewView = NewView { commentsReaction :: CommentsReaction }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New CommentsReaction</h1>
        {renderForm commentsReaction}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "CommentsReactions" CommentsReactionsAction
                , breadcrumbText "New CommentsReaction"
                ]

renderForm :: CommentsReaction -> Html
renderForm commentsReaction = formFor commentsReaction [hsx|
    {(textField #emoji)}
    {(textField #commentId)}
    {submitButton}

|]