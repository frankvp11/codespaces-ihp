module Web.View.Posts.Show where
import Web.View.Prelude
import qualified Text.MMark as MMark

-- Updated data type to include post and emoji counts
data ShowView = ShowView { 
    post :: Include "comments" Post,
    postReactions :: [(Text, Int)],
    commentsReactions :: [(Id Comment, [(Text, Int)])] -- New field for comment reactions
}

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <div class="post-container">
            <h1>{post.title}</h1>
            <p>{post.createdAt |> timeAgo}</p>
            <div>{post.body |> renderMarkdown}</div>
            {renderReactions postReactions}
            {renderEmojiSelection post.id}

            <!-- Add Comment Link -->
            <a href="#" id="add-comment-link" class="add-comment-link">Add Comment</a>

            <!-- Comment Form (Initially Hidden) -->
            <div id="comment-form" class="comment-form">
                {renderCommentForm (Just post.id) Nothing}
            </div>
        </div>

        <div class="comments-section">
             {renderComments post.comments commentsReactions Nothing}
        </div>

        <!-- Custom styles for hover functionality and comment form -->
        <style>
            /* Emoji selection for posts */
            .post-emoji-selection {
                display: none;
                justify-content: start; /* Align emojis to the left */
                gap: 10px; /* Space between emoji buttons */
                margin-top: 10px;
            }

            .post-container:hover .post-emoji-selection {
                display: flex;
            }

            /* Emoji selection for comments */
            .comment-content {
                position: relative;
            }

            .comment-emoji-selection {
                position: absolute;
                top: 10px;
                right: 10px;
                display: none;
                gap: 5px;
            }

            .comment-content:hover .comment-emoji-selection {
                display: flex;
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

            /* Styles for Add Comment functionality */
            .add-comment-link {
                display: inline-block;
                margin-top: 15px;
                color: #007bff;
                cursor: pointer;
                text-decoration: none;
            }

            .add-comment-link:hover {
                text-decoration: underline;
            }

            .comment-form {
                display: none; /* Hidden by default */
                margin-top: 15px;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                background-color: #fefefe;
            }

            /* Indentation and styling for nested comments */
            .comment {
                margin-top: 20px;
                padding: 15px;
                background-color: #f1f1f1;
                border-radius: 5px;
                position: relative;
                transition: background-color 0.3s;
            }

            .comment.indented {
                margin-left: 40px;
                background-color: #e9e9e9;
                border-left: 4px solid #ccc;
            }

            .comment .add-comment-link {
                margin-top: 10px;
            }

            /* Styles for comment reactions */
            .comment-reactions {
                margin-top: 10px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
        </style>

        <!-- JavaScript to handle Add Comment toggle and Emoji Selection on Hover -->
<!-- JavaScript to handle Add Comment toggle and Emoji Selection on Hover -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        // Toggle for main Add Comment link
        const addCommentLink = document.getElementById("add-comment-link");
        const commentForm = document.getElementById("comment-form");

        addCommentLink.addEventListener("click", function(event) {
            event.preventDefault(); // Prevent default link behavior
            if (commentForm.style.display === "none" || commentForm.style.display === "") {
                commentForm.style.display = "block";
            } else {
                commentForm.style.display = "none";
            }
        });

        // Toggle for nested Add Comment links
        const nestedAddCommentLinks = document.querySelectorAll(".nested-add-comment-link");

        nestedAddCommentLinks.forEach(function(link) {
            link.addEventListener("click", function(event) {
                event.preventDefault();
                const commentId = this.getAttribute("data-comment-id");
                const nestedForm = document.getElementById(`comment-form-${commentId}`);
                if (nestedForm.style.display === "none" || nestedForm.style.display === "") {
                    nestedForm.style.display = "block";
                } else {
                    nestedForm.style.display = "none";
                }
            });
        });

        // Handle Hover for Emoji Selection on Comments
        const commentContents = document.querySelectorAll(".comment-content");

        commentContents.forEach(function(content) {
            content.addEventListener("mouseenter", function() {
                const emojiSelection = this.querySelector(".comment-emoji-selection");
                if (emojiSelection) {
                    emojiSelection.classList.add("show");
                }
            });

            content.addEventListener("mouseleave", function() {
                const emojiSelection = this.querySelector(".comment-emoji-selection");
                if (emojiSelection) {
                    emojiSelection.classList.remove("show");
                }
            });
        });
    });
</script>
    |]
        where
            breadcrumb = renderBreadcrumb
                                [ breadcrumbLink "Posts" PostsAction
                                , breadcrumbText "Show Post"
                                ]

renderMarkdown text =
    case text |> MMark.parse "" of
        Left _error -> "Something went wrong"
        Right markdown -> MMark.render markdown |> tshow |> preEscapedToHtml

-- Recursive function to render comments and their sub-comments with reactions
renderComments :: [Comment] -> [(Id Comment, [(Text, Int)])] -> Maybe (Id Comment) -> Html
renderComments allComments commentReactions mParentId = 
    let
        -- Filter comments based on the current parentId
        filteredComments = filter (\c -> get #commentId c == mParentId) allComments
    in
        forEach filteredComments (\comment -> renderComment allComments commentReactions comment)

-- Updated renderComment function to handle indentation, reactions, and sub-comments
renderComment :: [Comment] -> [(Id Comment, [(Text, Int)])] -> Comment -> Html
renderComment allComments commentReactions comment = [hsx|
    <div class={commentClass comment}>
        <!-- Main Content of the Comment -->
        <div class="comment-content">
            <h5>{comment.author}</h5>
            <p>{comment.body}</p>

            <!-- Add Comment Link -->
            <a href="#" data-comment-id={comment.id} class="add-comment-link nested-add-comment-link">Add Comment</a>

            <!-- Comment Form (Initially Hidden) -->
            <div id={"comment-form-" <> (tshow comment.id)} class="comment-form">
                {renderCommentForm (Just (get #postId comment)) (Just comment.id)}
            </div>

            <!-- Emoji Reactions Display -->
            {renderCommentReactions comment.id commentReactions}

            <!-- Emoji Selection on Hover -->
            {renderCommentEmojiSelection comment.id}
        </div>

        <!-- Render Sub-Comments -->
        <div class="sub-comments">
            {renderComments allComments commentReactions (Just comment.id)}
        </div>
    </div>
|]
    where
        -- Determine CSS classes based on the nesting level
        commentClass :: Comment -> Text
        commentClass comment =
            case get #commentId comment of
                Nothing -> "comment"
                Just _  -> "comment indented"

-- Function to render the emoji selection bar for comments
renderCommentEmojiSelection :: Id Comment -> Html
renderCommentEmojiSelection commentId = [hsx|
    <div class="comment-emoji-selection">
        {forEach emojis (\emoji -> renderCommentEmojiButton emoji commentId)}
    </div>
|]
    where
        -- List of common emojis
        emojis = ["😀", "👍", "❤️", "😂", "🎉", "😢", "😡", "👏", "👀", "🤔"]

-- Function to render an individual emoji button for comments
renderCommentEmojiButton :: Text -> Id Comment -> Html
renderCommentEmojiButton emoji commentId = [hsx|
    <form method="POST" action={CreateCommentsReactionAction} class="emoji-button-form">
        <!-- Hidden input to store commentId -->
        <input type="hidden" name="commentId" value={commentId} />
        
        <!-- Hidden input to store the selected emoji -->
        <input type="hidden" name="emoji" value={emoji} />
        
        <!-- Emoji button -->
        <button type="submit" class="emoji-button" aria-label={"React with " <> emoji}>
            {emoji}
        </button>
    </form>
|]

-- Function to render the emoji selection bar for posts
renderEmojiSelection :: Id Post -> Html
renderEmojiSelection postId = [hsx|
    <div class="post-emoji-selection">
        {forEach emojis (\emoji -> renderEmojiButton emoji postId)}
    </div>
|]
    where
        -- List of common emojis
        emojis = ["😀", "👍", "❤️", "😂", "🎉", "😢", "😡", "👏", "👀", "🤔"]

-- Function to render an individual emoji button for posts
renderEmojiButton :: Text -> Id Post -> Html
renderEmojiButton emoji postId = [hsx|
    <form method="POST" action={CreatePostsReactionAction} class="emoji-button-form">
        <!-- Hidden input to store postId -->
        <input type="hidden" name="postId" value={postId} />
        
        <!-- Hidden input to store the selected emoji -->
        <input type="hidden" name="emoji" value={emoji} />
        
        <!-- Emoji button -->
        <button type="submit" class="emoji-button" aria-label={"React with " <> emoji}>
            {emoji}
        </button>
    </form>
|]

-- Function to render reactions for posts
renderReactions :: [(Text, Int)] -> Html
renderReactions reactions = [hsx|
    <div class="reactions">
        {forEach reactions renderReaction}
    </div>
|]

renderReaction :: (Text, Int) -> Html
renderReaction (emoji, count) = [hsx|
    <div class="emoji-count">
        {emoji} <span>({count})</span>
    </div>
|]

-- Function to render reactions for comments
renderCommentReactions :: Id Comment -> [(Id Comment, [(Text, Int)])] -> Html
renderCommentReactions commentId commentReactions =
    case lookup commentId commentReactions of
        Nothing -> mempty
        Just reactions -> [hsx|
            <div class="comment-reactions">
                {forEach reactions renderReaction}
            </div>
        |]
    where
        renderReaction :: (Text, Int) -> Html
        renderReaction (emoji, count) = [hsx|
            <div class="emoji-count">
                {emoji} <span>({count})</span>
            </div>
        |]

-- Function to render the comment form
renderCommentForm :: Maybe (Id Post) -> Maybe (Id Comment) -> Html
renderCommentForm postId commentId = [hsx|
    <form method="POST" action={CreateCommentAction}>
        
        <!-- Hidden input to store postId -->
        <input type="hidden" name="postId" value={postId} />
        <!-- Hidden input to store parentCommentId -->
        <input type="hidden" name="commentId" value={commentId} />
        
        <div class="form-group">
            <label for="author">Author</label>
            <input name="author" class="form-control" required />
        </div>
        <div class="form-group">
            <label for="body">Comment</label>
            <textarea name="body" class="form-control" rows="3" required></textarea>
        </div>
        <button type="submit" class="btn btn-primary">Submit</button>
    </form>
|]

