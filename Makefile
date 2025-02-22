build:
	 find posts/* -printf "%f\n" | xargs -I {} sh -c "markdown posts/{} > /tmp/blog-{}.html; cat src/header.html /tmp/blog-{}.html > blog/{}.html" 
