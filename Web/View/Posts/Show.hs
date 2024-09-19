module Web.View.Posts.Show where
import Web.View.Prelude
import qualified Text.MMark as MMark

-- Updated data type to include post and emoji counts
data ShowView = ShowView { post :: Include' ["comments", "posts_reactions"] Post }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <div class="post-container">
            <h1>{post.title}</h1>
            <p>{post.createdAt |> timeAgo}</p>
            <div>{post.body |> renderMarkdown}</div>

            <!-- Render emoji counts and selection bar for the post -->
            {renderEmojiSelection post.id}


        </div>
            <a href={NewCommentAction post.id}> Add Comment </a>
            <div>{forEach post.comments renderComment}</div>

        <!-- Custom styles for hover functionality -->
        <style>
            .emoji-selection {
                display: none;
                margin-top: 10px;
            }

            .post-container:hover .emoji-selection {
                display: block;
            }

            .emoji-button {
                border: none;
                background: none;
                font-size: 24px;
                cursor: pointer;
                margin: 0 5px;
            }

            .emoji-count {
                display: inline-block;
                margin: 0 10px;
            }

            .post-container {
                position: relative;
                padding: 10px;
                background-color: #f9f9f9;
                border-radius: 8px;
                transition: background-color 0.3s;
            }

            .post-container:hover {
                background-color: #f0f0f0;
            }
        </style>
    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Posts" PostsAction
                            , breadcrumbText "Show Post"
                            ]

renderMarkdown text =
    case text |> MMark.parse "" of
        Left error -> "Something went wrong"
        Right markdown -> MMark.render markdown |> tshow |> preEscapedToHtml

renderComment comment = [hsx|
    <div class="mt-4">
        <h5>{comment.author}</h5>
        <p>{comment.body}</p>
    </div>
|]

-- Function to render emoji counts
-- renderEmojiCount :: (Text, Int) -> Html
-- renderEmojiCount (emoji, count) = [hsx|
--     <div class="emoji-count">
--         {emoji} <span>({count})</span>
--     </div>
-- |]

-- Function to render the emoji selection bar
renderEmojiSelection :: Id Post -> Html
renderEmojiSelection postId = [hsx|
    <form method="POST" action={CreatePostsReactionAction} class="emoji-selection">
        <div class="form-group">
            <!-- Hidden input to store postId -->
            <input type="hidden" name="postId" value={postId} />
            
            <!-- Render several emoji buttons for users to select -->
            {forEach emojis (\emoji -> renderEmojiButton emoji postId)}
        </div>
    </form>
|]
    where
        -- List of common emojis
        emojis = ["😀", "👍", "❤️", "😂", "🎉", "😢", "😡", "👏", "👀", "🤔"]

-- Function to render an individual emoji button
renderEmojiButton :: Text -> Id Post -> Html
renderEmojiButton emoji postId = [hsx|
    <button type="submit" class="emoji-button" name="emojiType" value={emoji}>
        {emoji}
    </button>
|]
