build:
	find posts/ -type f | xargs -I {} sh -c "markdown {} > {}.html" && mv posts/*.html public/
