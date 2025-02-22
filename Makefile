build:
	 find posts/* -printf "%f\n" | xargs -I {} sh -c "markdown posts/{} > posts/{}.html; cat files/header.html posts/{}.html > public/{}.html" 
	 rm posts/*.html 
