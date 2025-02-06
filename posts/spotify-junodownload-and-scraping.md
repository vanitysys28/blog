#+TITLE: Spotify, Junodownload & Scraping
#+DATE: 2024-08-04
#+DRAFT: false
#+SUMMARY: Discovering music with Spotify and Junodownload, scraping the latter, and feeding it to playlists.

Listening to music of all kind is made really easy nowadays thanks to streaming platforms like Spotify. Anyone can find their favorite music and sort it in playlist based on their tastes or categories they see fit. An algorithm is also nicely trained to make us discover brand new songs through the [[https://www.spotify.com/mt/safetyandprivacy/understanding-recommendations][recommendations]] or the [[https://community.spotify.com/t5/FAQs/Spotify-Radio-how-does-it-work/ta-p/4757060][radio]] feature.

Everything is great until the algorithm isn't able to offer exactly the kind of music you are looking for. Sometimes, it is even simply showcasing songs coming from albums that are already in your playlists, or were previously searched for. In that situation, it's becoming harder to discover unpopular new releases and to populate a playlist that might become stale after hundreds of hours of listening, and being forwarded the same songs even on [[https://www.reddit.com/r/spotify/comments/10k9b84/should_shuffle_mode_be_100_random/][shuffle]].

Some websites are great sources to discover new releases for precise genres. [[https://www.junodownload.com/][Junodownload]] is one of them when it comes to electronic music, and the [[https://www.junodownload.com/all/this-week/releases/][new releases page]] makes it a breeze to find brand new music for your tastes. Seeing the amount of brand new songs I could add to my playlists and discover, I needed to find a way to feed them to Spotify quick and easy.

Python would be a great tool for the job, and the [[https://www.crummy.com/software/BeautifulSoup/][Beautiful Soup]] library would help me scrape the precious data I needed. After prompting the user for the genre they prefer, and their desired time span, getting the information was as easy as this:

#+begin_src python
  now = datetime.datetime.now().strftime('%Y%m%d%H%M%S')

  def scrapeJuno(genre, timespan):
    url = 'https://www.junodownload.com/' + genre + '/' + timespan + '/releases/?items_per_page=100'
    soup = BeautifulSoup(requests.get(url).text, features='html.parser')
#+end_src

Even by ensuring the page was displaying as much items as possible, a large time span would usually cause results to be displayed across multiple pages, and I needed to find a solution to make sure that no new releases would be left behind. The pagination is easily accessible in the document body, and a simple loop implementation with subsequent requests to the URL contained in the href attribute would help me miss no data.

#+begin_src python
   while len(soup.find_all('a',{'title':'Next Page'})) > 0:
        soup = BeautifulSoup(requests.get(url).text, features='html.parser')

        if len(soup.find_all('a',{'title':'Next Page'})) > 0:
            url = soup.find('a',{'title':'Next Page'})['href']
#+end_src

With this issue out of the way, the only thing left was to extract the data I needed to feed to Spotify : the artist, the album and the label. In the early stages of developing this script, I thought the artist/track name combination would be enough, but I often ended up with unrelated songs being added to my playlists. The label would greatly help in helping Spotify API find the right song, and I am happy that Junodownload makes it easily available on their website:

#+begin_src python
  file = open('data/' + now + '.txt','a',encoding='utf-8')

       for data in soup.find_all('div', {'class':'col-12 col-md order-4 order-md-3 mt-3 mt-md-0 pl-0 pl-md-2'}):
	   artist = data('div', {'class':'col juno-artist'})[0].get_text()
	   album = data('a', {'class':'juno-title'})[0].get_text().replace('(Explicit)','')
	   label = data('a', {'class':'juno-label'})[0].get_text()
	   if data('div', {'class':'col pl-2 jq_highlight'}):
	       tracks = data('div', {'class':'col pl-2 jq_highlight'})[0].get_text().rsplit('-', 1)[0]

	   with open('data/' + now + '.txt'):
	       file.write(entry)
	       file.write('\n')
#+end_src

Your developer eyes maybe caught the fact that all data is being stored in unique files. This was required if I wanted to avoid duplicate data in the playlists. [[https://developer.spotify.com/documentation/web-api][Spotify Web API]], contrary to the Spotify client, doesn't offer any way to check for duplicates. Therefore, all previous data files are being looped through to check if a label/album combination was already scraped in the past.

#+begin_src python
  filecontents = ''

    for files in os.listdir('data/'):
        with open('data/' + files) as f:
            filecontents += f.read()

  entry = 'label:"' + label + '" ' + album

  with open('data/' + now + '.txt'
       if entry not in filecontents:
	    file.write(entry)
	    file.write('\n')
#+end_src

After creating a brand new playlist on my Spotify client, and putting my hands on the playlist ID, it was just a matter of finding the right track, and adding it to the playlist. The whole API could have been played with using the [[https://requests.readthedocs.io/en/latest/][Requests library]], but the lightweight [[https://spotipy.readthedocs.io/en/2.24.0/][Spotipy]] library made the whole process much simpler. After creating the required app on the Spotify Developers Dashboard, the following lines of code would automatically add all the songs to my playlist:

#+begin_src python
  def addToSpotifyPlaylist():
    load_dotenv()

    client_id = os.getenv('CLIENT_ID')
    client_secret = os.getenv('CLIENT_SECRET')
    playlist_id = os.getenv('PLAYLIST_ID')

    scope = 'playlist-modify-private,playlist-modify-public'

    sp = spotipy.Spotify(auth_manager=SpotifyOAuth(client_id,client_secret,redirect_uri='http://localhost:8888/callback',scope=scope))

    file = open('data/' + now + '.txt',encoding='utf-8')
    lines = file.readlines()
    for line in lines:
        if sp.search(q=line, limit=20,type='track')['tracks']['items']:
            searchresults = sp.search(q=line, limit=20,type='track')['tracks']['items']
            for item in searchresults:
                if item['album']['name'] in line:
                    albumid = item['album']['id']
                    albumtracks = sp.album_tracks(albumid)['items']
                    for tracks in albumtracks:
                        playlistadd = sp.playlist_add_items(playlist_id,[tracks['uri']],position=None)  
                    break
#+end_src

In a matter of seconds, I would be served with a playlist containing possibly more than 1,000 new songs to listen to, and the happiness to have built that little entertaining script. The code can certainly be optimized and cleaned, with functions being separated into smaller ones for clarity, but anyone interested by that project can check it in the publicly available [[https://github.com/vanitysys28/juno-playlist-creator][github repo]].
