-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TABLE posts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);
CREATE TABLE comments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    post_id UUID NOT NULL,
    author TEXT NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);
CREATE INDEX comments_post_id_index ON comments (post_id);
CREATE TABLE comments_reactions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    emoji TEXT NOT NULL,
    comment_id UUID NOT NULL
);
CREATE INDEX comments_reactions_created_at_index ON comments_reactions (created_at);
CREATE INDEX comments_reactions_comment_id_index ON comments_reactions (comment_id);
CREATE TABLE posts_reactions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    emoji TEXT NOT NULL,
    post_id UUID NOT NULL
);
CREATE INDEX posts_reactions_created_at_index ON posts_reactions (created_at);
CREATE INDEX posts_reactions_post_id_index ON posts_reactions (post_id);
ALTER TABLE comments_reactions ADD CONSTRAINT comments_reactions_ref_comment_id FOREIGN KEY (comment_id) REFERENCES comments (id) ON DELETE NO ACTION;
ALTER TABLE comments ADD CONSTRAINT comments_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE NO ACTION;
ALTER TABLE posts_reactions ADD CONSTRAINT posts_reactions_ref_post_id FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE NO ACTION;


CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    email TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    locked_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    failed_login_attempts INT DEFAULT 0 NOT NULL
);
