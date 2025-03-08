build:	
	mkdir -p public/
	find posts/* -printf "%f\n" | xargs -I {} sh -c "markdown posts/{} > /tmp/public-{}.html; cat src/header.html /tmp/public-{}.html > public/{}.html" 
