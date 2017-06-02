/* this gets the number of articles that were retrieved
   at given time stamp / api call */
SELECT
	[retrieval.time],
	COUNT(*) as articles_retrieved
FROM top_news
GROUP BY [retrieval.time]