module Web.View.CommentsReactions.Index where
import Web.View.Prelude

data IndexView = IndexView { commentsReactions :: [CommentsReaction] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewCommentsReactionAction} class="btn btn-primary ms-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>CommentsReaction</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach commentsReactions renderCommentsReaction}</tbody>
            </table>
            
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "CommentsReactions" CommentsReactionsAction
                ]

renderCommentsReaction :: CommentsReaction -> Html
renderCommentsReaction commentsReaction = [hsx|
    <tr>
        <td>{commentsReaction}</td>
        <td><a href={ShowCommentsReactionAction commentsReaction.id}>Show</a></td>
        <td><a href={EditCommentsReactionAction commentsReaction.id} class="text-muted">Edit</a></td>
        <td><a href={DeleteCommentsReactionAction commentsReaction.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]