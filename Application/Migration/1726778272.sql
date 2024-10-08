DROP TABLE reactions;
CREATE TABLE comments_reactions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    emoji TEXT NOT NULL,
    comment_id UUID NOT NULL
);
CREATE INDEX comments_reactions_created_at_index ON comments_reactions (created_at);
CREATE INDEX comments_reactions_comment_id_index ON comments_reactions (comment_id);
CREATE TABLE posts_reactions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    emoji TEXT NOT NULL,
    post_id UUID NOT NULL
);
CREATE INDEX posts_reactions_created_at_index ON posts_reactions (created_at);
CREATE INDEX posts_reactions_post_id_index ON posts_reactions (post_id);
ALTER TABLE comments_reactions ADD CONSTRAINT comments_reactions_ref_comment_id FOREIGN KEY (comment_id) REFERENCES comments (id) ON DELETE NO ACTION;
ALTER TABLE posts_reactions ADD CONSTRAINT posts_reactions_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE NO ACTION;
