module Web.View.CommentsReactions.Show where
import Web.View.Prelude

data ShowView = ShowView { commentsReaction :: CommentsReaction }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show CommentsReaction</h1>
        <p>{commentsReaction}</p>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "CommentsReactions" CommentsReactionsAction
                            , breadcrumbText "Show CommentsReaction"
                            ]