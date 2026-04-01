CREATE TABLE post (
                      post_id SERIAL PRIMARY KEY,
                      user_id INT NOT NULL,
                      content TEXT,
                      tags TEXT[],
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                      is_public BOOLEAN DEFAULT TRUE
);

CREATE TABLE user_like (
                           user_id INT NOT NULL,
                           post_id INT NOT NULL,
                           liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           PRIMARY KEY (user_id, post_id)
);

INSERT INTO post (user_id, content, tags, created_at, is_public) VALUES
                                                                     (1, 'Toi vua di du lich Da Nang', ARRAY['travel','danang'], NOW() - INTERVAL '2 days', TRUE),
                                                                     (2, 'Hoc PostgreSQL rat hay', ARRAY['study','database'], NOW() - INTERVAL '10 days', TRUE),
                                                                     (3, 'Chia se kinh nghiem du lich Ha Noi', ARRAY['travel','hanoi'], NOW() - INTERVAL '5 days', TRUE),
                                                                     (1, 'Hom nay toi hoc SQL Index', ARRAY['study','sql'], NOW() - INTERVAL '1 days', TRUE),
                                                                     (4, 'Bai viet rieng tu', ARRAY['private'], NOW() - INTERVAL '3 days', FALSE),
                                                                     (2, 'Check in Sai Gon', ARRAY['travel','saigon'], NOW() - INTERVAL '6 days', TRUE),
                                                                     (5, 'Huong dan hoc Python', ARRAY['study','python'], NOW() - INTERVAL '8 days', TRUE),
                                                                     (3, 'Review chuyen di Hue', ARRAY['travel','hue'], NOW() - INTERVAL '4 days', TRUE);

INSERT INTO user_like (user_id, post_id, liked_at) VALUES
                                                       (1,1,NOW() - INTERVAL '1 days'),
                                                       (2,1,NOW() - INTERVAL '1 days'),
                                                       (3,2,NOW() - INTERVAL '2 days'),
                                                       (4,3,NOW() - INTERVAL '3 days'),
                                                       (5,4,NOW() - INTERVAL '1 days'),
                                                       (1,5,NOW() - INTERVAL '2 days'),
                                                       (2,6,NOW() - INTERVAL '5 days'),
                                                       (3,7,NOW() - INTERVAL '6 days'),
                                                       (4,8,NOW() - INTERVAL '2 days');

SELECT * FROM post
WHERE is_public = TRUE AND content ILIKE '%du lich%';

CREATE INDEX idx_post_content_lower
    ON post (LOWER(content));

EXPLAIN ANALYZE
SELECT * FROM post
WHERE LOWER(content) LIKE '%du lich%';

SELECT * FROM post WHERE tags @> ARRAY['travel'];

CREATE INDEX idx_post_tags ON post USING GIN (tags);

EXPLAIN ANALYZE
SELECT * FROM post WHERE tags @> ARRAY['travel'];

CREATE INDEX idx_post_recent_public
    ON post(created_at DESC)
    WHERE is_public = TRUE;

SELECT * FROM post
WHERE is_public = TRUE AND created_at >= NOW() - INTERVAL '7 days';

CREATE INDEX idx_post_user_created
    ON post(user_id, created_at DESC);

EXPLAIN ANALYZE
SELECT *
FROM post
WHERE user_id IN (2,3,4)
  AND is_public = TRUE
ORDER BY created_at DESC
LIMIT 10;