module Web.View.PostsReactions.Edit where
import Web.View.Prelude

data EditView = EditView { postsReaction :: PostsReaction }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit PostsReaction</h1>
        {renderForm postsReaction}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "PostsReactions" PostsReactionsAction
                , breadcrumbText "Edit PostsReaction"
                ]

renderForm :: PostsReaction -> Html
renderForm postsReaction = formFor postsReaction [hsx|
    {(textField #emoji)}
    {(textField #postId)}
    {submitButton}

|]