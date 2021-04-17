function integrate(f, eps)
	eps = eps or 1e-4
	return function (x)
		if 0 < x then eps = -eps end
		rv = 0
		for i = 0, x, eps do
			rv = rv + f(i)*eps
		end
		return rv
	end
end
-- f' = (f(x + eps) - f(x)) / eps
-- f' · eps = f(x+eps) - f(x)
-- f(0) + f' · eps = f(eps)
