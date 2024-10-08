ALTER TABLE comments ADD COLUMN comment_id UUID DEFAULT null;
DROP TRIGGER ar_did_delete_comments ON comments;
DROP TRIGGER ar_did_delete_posts ON posts;
DROP TRIGGER ar_did_delete_posts_reactions ON posts_reactions;
DROP TRIGGER ar_did_insert_comments ON comments;
DROP TRIGGER ar_did_insert_posts ON posts;
DROP TRIGGER ar_did_insert_posts_reactions ON posts_reactions;
DROP TRIGGER ar_did_update_comments ON comments;
DROP TRIGGER ar_did_update_posts ON posts;
DROP TRIGGER ar_did_update_posts_reactions ON posts_reactions;
CREATE INDEX comments_comment_id_index ON comments (comment_id);
ALTER TABLE comments ADD CONSTRAINT comments_ref_comment_id FOREIGN KEY (comment_id) REFERENCES comments (id) ON DELETE NO ACTION;
