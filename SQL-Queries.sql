USE spotify_streaming_history;
 
-- 1. Total Number of Streams and Average Duration: 
-- Count the total number of streams. 
-- Calculate the average duration of streams in minutes.
SELECT COUNT(*) AS num_streams, 
AVG(ms_played) / 60000 AS avg_min_played FROM spotify_history;

-- 2. Highest stream duration
SELECT MAX(ms_played) AS highest_stream_duration
FROM spotify_history;

-- 3. Artists with the Highest Total Play Duration
SELECT track_name, artist_name, SUM(ms_played) AS munites_played
FROM spotify_history
GROUP BY track_name, artist_name
ORDER BY munites_played DESC
Limit 10;

-- 4. Explore details about the artist with the highest stream
SELECT * FROM spotify_history
WHERE artist_name = 'John Mayer'

-- 5. Top 10 Most Skipped Tracks 
SELECT track_name, artist_name, COUNT(skipped) AS num_skipped
FROM spotify_history
WHERE skipped = 'TRUE'
GROUP BY artist_name, track_name, skipped
ORDER BY num_skipped DESC
LIMIT 10;

-- 6. Most Frequently Used Streaming Platforms
SELECT platform, COUNT(*) number_of_stream FROM spotify_history
GROUP BY platform
ORDER BY number_of_stream DESC;

-- 7. Top 10 Most Played Tracks
SELECT track_name, artist_name, COUNT(*) AS num_of_times_played
FROM spotify_history
GROUP BY track_name, artist_name, ms_played
ORDER BY num_of_times_played DESC
LIMIT 10;

-- 8. Average Duration of Tracks Based on Start Reason
SELECT reason_start, 
ROUND(AVG(ms_played) / 1000, 2) AS avg_playtime_sec
FROM spotify_history
GROUP BY reason_start
ORDER BY avg_playtime_sec DESC;


-- 10. Impact of Shuffle Mode on Stream Duration: 
-- Compare the average stream duration between tracks played with shuffle (shuffle = TRUE) versus without shuffle (shuffle = FALSE).`
SELECT 
    shuffle,
    COUNT(*) AS total_tracks,
    ROUND(AVG(ms_played) / 1000, 2) AS avg_playtime_sec
FROM spotify_history
GROUP BY shuffle;

-- 11. Distribution of Stream End Reasons: Analyze the reasons (reason_end) why tracks were ended (e.g., natural end, user skip, etc.).
--Calculate the percentage distribution of these reasons.
SELECT reason_end, COUNT(reason_end) AS num_reason
FROM spotify_history
GROUP BY reason_end
ORDER BY num_reason DESC;

-- 12. cPercentage Distribution of Track Start Reasons
SELECT 
    reason_start, 
    COUNT(*) AS total_count,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM spotify_history), 2) AS percentage
FROM spotify_history
GROUP BY reason_start
ORDER BY percentage DESC;


-- 13. Tracks with Longest Continuous Plays: Identify tracks that were played continuously for the longest durations without interruption. 
-- This involves analyzing consecutive rows where reason_end is not due to user action (e.g., skipped)

SELECT 
    track_name, 
    artist_name, 
    SUM(ms_played) / 1000 AS total_playtime_sec
FROM spotify_history
WHERE reason_end NOT IN ('skipped', 'end_of_queue', 'unknown') 
GROUP BY track_name, artist_name
ORDER BY total_playtime_sec DESC
LIMIT 10;
