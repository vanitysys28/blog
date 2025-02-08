
# Table of Contents



It all started when watching videos on YouTube. I was watching all new released videos from a set of channels, and I would quickly get lost and forget which one I saw or didn't.

For this particular reason, an idea came to my mind to create a Chrome extension that would inject a button on every YouTube video webpage, displaying how much of a video has been watched.

At first, the idea was the following : listening for events on the video [HTMLMediaElement](https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement), particularly the [play](https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/play_event) and [pause](https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/pause_event) events.

Everytime one of this event would be fired, the current video time would be logged, and associated to the associated start or end of the segment.

    function pausedChecker(){
        document.getElementsByTagName("video")[0].addEventListener('pause', () => {
    	return getVideoCurrentTime()
        })
    }
    
    function playingChecker(){
        document.getElementsByTagName("video")[0].addEventListener('play', () => {
    	return getVideoCurrentTime()
        })
    }
    
    function getVideoID(){
        return new URL(document.URL).searchParams.get('v')
    }
    
    function getVideoCurrentTime(){
        return document.getElementsByTagName("video")[0].currentTime
    }

This would correctly log all the data to the console, but the purpose was to store it correctly.

Knowing that the extension will be shared to potential users in the near future, a data storage solution needed to be found, fitting with that Chrome extension environment.

To keep things as simple as possible, storing the data in [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage) seems to be the best idea, knowing there is no project to make the data accessible across multiple devices, hence removing the requirement for a database.

localStorage would be analyzed everytime for the presence of a previously set item, and the array storing the data would be overwritten.

    var videoDataCollection = []
    
    function storeVideoData(){
        var videoid = getVideoID()
        var time = getVideoCurrentTime()
        var videoData = {id: videoid, playtime: time}
        videoDataCollection.push(videoData)
    }
    
    function backupVideoData(data) {
        localStorage.setItem('watchd', data);
    }
    
    function fetchLocalStorage(){
        if (JSON.parse(localStorage.getItem("watchd"))) {
    	videoDataCollection = JSON.parse(localStorage.getItem("watchd"))
        }
    }
    
    function main(){
        fetchLocalStorage()
        storeVideoData()
        backupVideoData(videoDataCollection)
    }

This piece of code would be the beginning of the real thinking process.

Multiple issues arise from the code above, one of which is the following :

-   How to distinguish the start and the end of a watched segment?

After analyzing the video element properties, the [played property](https://www.w3schools.com/jsref/prop_video_played.asp) would be of great help, being able to build segments directly from the ranges stored in these objects.

    function getSegmentsPlayed(){
        var segmentsPlayed = []
    
        for(var i = 0; i < document.getElementsByTagName("video")[0].played.length; i++) { 
    	var intervalStart = document.getElementsByTagName("video")[0].played.start(i)
    	var intervalEnd = document.getElementsByTagName("video")[0].played.end(i)
    	segmentsPlayed.push(intervalStart + ":" + intervalEnd)
        }
    
        var videoData = {id: getVideoID(), playtime: segmentsPlayed}
        return videoData
    }

I didn't really realize how bad of a decision it would be to use a delimiter to differentiate the start and the end of the segment.

For this reason, a quick adjustment was made, and this data would be kept in an object instead, with appropriate keys.

    segmentsPlayed.push({start: intervalStart, end: intervalEnd})

I talked previously about multiple issues.
The biggest of them all is by far the handling of data concerning a similar video.

Therefore, the array containing all the data needed to be checked for possible duplicated id value in all the objects stored.

    function checkDuplicateVideoData(){
        var index = videoDataCollection.findIndex(video => video.id == getVideoID())
        if (index !== -1) {
    	videoDataCollection.splice(index, 1);
        } 
    }
    
    function pausedChecker(){
        document.getElementsByTagName("video")[0].addEventListener('pause', () => {
    	checkDuplicateVideoData()
    	storeVideoData()
        })
    }
    
    function playingChecker(){
        document.getElementsByTagName("video")[0].addEventListener('play', () => {
    	checkDuplicateVideoData()
    	storeVideoData()
        })
    }

This seemed to do the work, up until I decided to close the browser, reopen it, and discover that all my previous stored data would be gone and replaced by the new ranges stored in the played property.

The played property was a god send in that project, helping for a precise tracking of the played ranges.
But this data vanishes in the void once the video is exited, whether it is after closing the browser, or navigating to another video when binge watching.

This solution needed to be improved.

    function checkDuplicateVideoData() {
        var videoIndex = getDuplicateVideoDataIndex()
        if (videoIndex !== -1) {
    	return true
        }
    }
    
    function storeVideoData() {
        if (!checkDuplicateVideoData) {
    	var videoData = {
    	    id: getVideoID(),
    	    segments: getSegmentsPlayed()
    	}
    	videoDataCollection.push(videoData)
        }
    
        if (checkDuplicateVideoData) {
    	var videoIndex = getDuplicateVideoDataIndex()
    	videoDataCollection[videoIndex].segments = getSegmentsPlayed()
        }
    }
    }

And this is how the first working state of the extension was reached!

This article doesn't describe another set of encountered issues and improvements that was brought to the project, but it was published to better explain the whole methodology that was used while building that little piece of software.

Another article is on the way, talking about overlaps, the button injection and other little tweaks.

If you are interested by the project, do not hesitate to come check it on: <https://github.com/vanitysys28/watchd>

It is open source for now, and PR requests or comments are more than welcome.

The extension is also available on the Chrome Web Store, on the following link: <https://chromewebstore.google.com/detail/watchd/cjdkmjpbhgkbjgfhcflccchhhffkhhjd>

