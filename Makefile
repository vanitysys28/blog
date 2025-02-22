build:
	 find posts/* -printf "%f\n" | xargs -I {} sh -c "markdown posts/{} > posts/{}.html; cat src/header.html posts/{}.html > blog/{}.html" 
	 rm posts/*.html 
