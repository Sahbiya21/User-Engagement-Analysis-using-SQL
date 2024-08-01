CREATE TABLE Posts (
    post_id INT PRIMARY KEY,
    post_content TEXT,
    post_date TIMESTAMP
);
Select * From POSTS
	
INSERT INTO Posts (post_id, post_content, post_date)
VALUES
    (1, 'Mountain...', '2024-07-25 10:00:00'),
    (2, 'Exploring the beauty of nature...', '2024-07-26 15:30:00'),
    (3, 'Unveiling the latest tech trends...', '2024-07-27 12:00:00'),
    (4, 'Journey into the world of literature...', '2024-07-28 09:45:00'),
    (5, 'Capturing the essence of city life...', '2024-07-29 16:20:00')

--Create User Reactions Table
CREATE TABLE UserReactions (
    reaction_id INT PRIMARY KEY,
    user_id INT,
    post_id INT,
    reaction_type VARCHAR(10) CHECK (reaction_type IN ('like', 'comment', 'share')),
    reaction_date TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);

-- Insert sample data into User Reactions Table
INSERT INTO UserReactions (reaction_id, user_id, post_id, reaction_type, reaction_date)
VALUES
    (1, 101, 1, 'like', '2024-07-26 10:15:00'),
    (2, 102, 1, 'comment', '2024-07-25 11:30:00'),
    (3, 103, 1, 'share', '2024-07-26 12:45:00'),
    (4, 101, 2, 'like', '2024-07-26 15:45:00'),
    (5, 102, 2, 'comment', '2024-07-27 09:20:00'),
    (6, 104, 2, 'like', '2024-07-27 10:00:00'),
    (7, 105, 3, 'comment', '2024-07-27 14:30:00'),
    (8, 101, 3, 'like', '2024-07-28 08:15:00'),
    (9, 103, 4, 'like', '2024-07-28 10:30:00'),
    (10, 105, 4, 'share', '2024-07-29 11:15:00'),
    (11, 104, 5, 'like', '2024-07-29 16:30:00'),
    (12, 101, 5, 'comment', '2024-07-30 09:45:00');

Select * From UserReactions

SELECT
    p.post_id,
    p.post_content,
    COUNT(CASE WHEN ur.reaction_type = 'like' THEN 1 END) AS num_likes,
    COUNT(CASE WHEN ur.reaction_type = 'comment' THEN 1 END) AS num_comments,
    COUNT(CASE WHEN ur.reaction_type = 'share' THEN 1 END) AS num_shares
FROM
    Posts p
LEFT JOIN
    UserReactions ur ON p.post_id = ur.post_id
WHERE
    p.post_id = 4 -- Replace with the desired post_id
GROUP BY
    p.post_id, p.post_content;

SELECT
    DATE(ur.reaction_date) AS reaction_day,
    COUNT(DISTINCT ur.user_id) AS distinct_users,
    COUNT(*) AS total_reactions,
    AVG(COUNT(*)) OVER (PARTITION BY DATE(ur.reaction_date)) AS avg_reactions_per_user
FROM
    UserReactions ur
WHERE
    ur.reaction_date BETWEEN '2024-07-26' AND '2024-08-31' -- Replace with desired time period
GROUP BY
    reaction_day;

SELECT
    p.post_id,
    p.post_content,
    SUM(
        CASE WHEN ur.reaction_type = 'like' THEN 1 ELSE 0 END +
        CASE WHEN ur.reaction_type = 'comment' THEN 1 ELSE 0 END +
        CASE WHEN ur.reaction_type = 'share' THEN 1 ELSE 0 END
    ) AS total_reactions
FROM
    Posts p
LEFT JOIN
    UserReactions ur ON p.post_id = ur.post_id
WHERE
    ur.reaction_date BETWEEN (current_date - INTERVAL '1 WEEK') AND current_date
GROUP BY
    p.post_id, p.post_content
ORDER BY
    total_reactions DESC
LIMIT
    3;
