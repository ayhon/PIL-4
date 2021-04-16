function plot(r, M, N)
	local p = io.write
	p("P1\n",M,"\n",N,"\n")
	for i = 1, N do
		local y = (N - i*2)/N
		for j = 1, M do
			local x = (2*j - M)/M
			p(r(x,y) and "1" or "0")
		end
		p("\n")
	end

end

function disk(cx,cy,r)
	return function (x,y)
		return (x-cx)^2 + (y-cy)^2 <= r^2
	end
end

function translate(c, dx,dy)
	return function (x,y)
		return c(x-dx, y-dy)
	end
end

function difference(a,b)
	return function (x,y)
		return a(x,y) and not b(x,y)
	end
end

c = disk(0,0,0.5)
plot(difference(c, translate(c, 0.3, 0)), 500, 500)
