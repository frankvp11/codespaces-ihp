module Web.View.PostsReactions.Index where
import Web.View.Prelude

data IndexView = IndexView { postsReactions :: [PostsReaction] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewPostsReactionAction} class="btn btn-primary ms-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>PostsReaction</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach postsReactions renderPostsReaction}</tbody>
            </table>
            
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "PostsReactions" PostsReactionsAction
                ]

renderPostsReaction :: PostsReaction -> Html
renderPostsReaction postsReaction = [hsx|
    <tr>
        <td>{postsReaction}</td>
        <td><a href={ShowPostsReactionAction postsReaction.id}>Show</a></td>
        <td><a href={EditPostsReactionAction postsReaction.id} class="text-muted">Edit</a></td>
        <td><a href={DeletePostsReactionAction postsReaction.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]