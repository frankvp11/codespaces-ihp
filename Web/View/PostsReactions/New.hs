module Web.View.PostsReactions.New where
import Web.View.Prelude

data NewView = NewView { postsReaction :: PostsReaction }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New PostsReaction</h1>
        {renderForm postsReaction}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "PostsReactions" PostsReactionsAction
                , breadcrumbText "New PostsReaction"
                ]

renderForm :: PostsReaction -> Html
renderForm postsReaction = formFor postsReaction [hsx|
    {(textField #emoji)}
    {(textField #postId)}
    {submitButton}

|]