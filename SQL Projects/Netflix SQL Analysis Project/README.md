# Comprehensive Analysis of Netflix Content Using SQL  

### Short Summary:  
Performed an in-depth analysis of Netflix's content library using SQL to uncover key trends and insights. Extracted and processed data to identify seasonal trends in content addition, genre popularity, common content ratings, and production by country. Applied advanced SQL techniques such as data filtering, string splitting, and aggregation to analyze the distribution of movies and TV shows across various dimensions. The analysis provided actionable insights into content release patterns, popular genres, and frequent collaborators (actors, directors).

### ABOUT Dataset
**The “netflix_titles” dataset contains the following columns:  **

•	**show_id:** Unique identifier for each show.  
•	**type:**  Type of the content (e.g., Movie, TV Show).  
•	**title:**  Title of the show or movie.  
•	**director:**  Director of the show/movie (can be missing for some rows).   
•	**cast:**  List of cast members.  
•	**country:**  Country where the show/movie was produced.    
•	**date_added:**  Date when the show/movie was added to Netflix.  
•	**release_year:**  Year when the show/movie was released.  
•	**rating:**  Content rating (e.g., PG-13, TV-MA).  
•	**duration:**  Duration of the content (e.g., in minutes for movies or number of seasons for TV shows).  
•	**listed_in:**  Categories/genres the content belongs to.  
•	**description:**  Short description of the content.

#  Potential Questions or Tasks for Analysis:  
## 1.	Basic Analysis:
o-	What is the distribution between movies and TV shows on Netflix?  
o-	How many unique directors are in the dataset? Who are the most prolific directors?  
o-	What are the top 10 countries producing the most content on Netflix?  

## 2.	Time-Based Analysis:
o-	How has the number of movies/TV shows added to Netflix changed over the years?  
o-	What are the trends in Netflix content release by year?  
o-	What is the oldest movie or TV show available on Netflix?

## 3.	Genre-Based Analysis:
o-	Which genres are the most popular on Netflix (based on the listed_in column)?  
o-	How many shows/movies fall into each genre category (e.g., "TV Dramas", "Documentaries")?

## 4.	Rating Analysis:
o-	What are the most common content ratings (e.g., PG-13, TV-MA) in the dataset?  
o-	How does the distribution of content ratings differ between movies and TV shows?
	
## 5.	Duration Analysis:
o-	What is the average duration of movies on Netflix?  
o-	How many TV shows have multiple seasons, and how many are single-season shows?

## 6.	Country Analysis:
o-	Which countries produce the most TV shows and movies for Netflix?  
o-	What is the distribution of Netflix content across different countries?

## 7.	Cast & Director Analysis:  
o-	Which actors or actresses appear most frequently in Netflix content?  
o-	Which directors have directed the most content on Netflix?

## 8.	Release Trends:
o-	Analyze the seasonal trends in content addition (e.g., are more shows added during certain times of the year?).  
o-	Find out the busiest month for content additions historically.
