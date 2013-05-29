local file = io.open("Easily3.html", "r")
if file then
	local html = file:read("*a")
	file:close()
	--print(html)
	file = io.open("version", "r")
	if file then
		local version = file:read("*a")
		file:close()
		print("version=" .. version)
		local repl = string.gsub(html, "version=%d+", "version=" .. version)
		--print(repl)
		file = io.open("Easily3.html","w")
		if file then
			file:write(repl)
			file:close()
		end
	end
end
