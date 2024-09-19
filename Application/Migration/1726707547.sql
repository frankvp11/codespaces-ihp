ALTER TABLE comments ALTER COLUMN post_id DROP NOT NULL;
ALTER TABLE comments ADD COLUMN comment_id UUID DEFAULT null;
ALTER TABLE reactions DROP COLUMN post_id;
ALTER TABLE reactions DROP COLUMN comment_id;
ALTER TABLE reactions ALTER COLUMN emoji SET NOT NULL;
CREATE INDEX comments_comment_id_index ON comments (comment_id);
CREATE INDEX reactions_created_at_index ON reactions (created_at);
ALTER TABLE comments ADD CONSTRAINT comments_ref_comment_id FOREIGN KEY (comment_id) REFERENCES comments (id) ON DELETE NO ACTION;
