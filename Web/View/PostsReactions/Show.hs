module Web.View.PostsReactions.Show where
import Web.View.Prelude

data ShowView = ShowView { postsReaction :: PostsReaction }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show PostsReaction</h1>
        <p>{postsReaction}</p>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "PostsReactions" PostsReactionsAction
                            , breadcrumbText "Show PostsReaction"
                            ]