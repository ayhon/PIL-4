old_c2 = coroutine.create(function(co, ...)
	print(...)
	local args = {coroutine.resume(co, 20)}
	print(table.unpack(args)) 
	print(coroutine.resume(co,5,4,3,2,1))
end)

old_c1 = coroutine.create(function(co,...)
	print(...)
	local args = {coroutine.yield(10)}
	print(table.unpack(args))                                      
	return 1,2,3,4,5 
end)

-- coroutine.resume(c2, c1, 3, 4, 5)

c1 = coroutine.create(
	function (c2, ...)
		print("1-: Entramos en c1 con parámetros",...)
		print("1-: Pasamos a c2 con argumentos 1, 2, 3")
		print("1-: Aún no hemos ejecutado c2, así que su estado es",
			  coroutine.status(c2))
		local args = {coroutine.resume(c2, c1, 1, 2, 3)}
		print("1-: Ahora, el estado de c2 pasa a ser",
			  coroutine.status(c2))
		print("1-: Hemos vuelto de c2 con los valores: ", table.unpack(args))
		print("1-: Regresamos a c2 con una carita sonriente")
		args = {coroutine.resume(c2, ":)")}
		print("1-: Hemos regresado de c2 con el valor",table.unpack(args))
		print("1-: Continuamos la ejecución, pasando una carita sacando la lengua")
		args = {coroutine.resume(c2, ":P")}
		print("1-: Volvemos de c2 a c1, con el valor", table.unpack(args))
		print("1-: Ahora, el estado de c2 es ",
			  coroutine.status(c2), "pues ha terminado de ejcutarse")
		print("1-: Y llegamos al final de c1")
	end
)

function f3()
	print("--: Hago `yield` desde otra función!")
	return coroutine.yield("Holas de f3")
end

c2 = coroutine.create(
	function (c1, ...)
		print("-2: Entramos en c2 con parámetros",...)
		print("-2: Al estar en otra rutina distinta, dejamos a c1 en estado",
		      coroutine.status(c1))
		print("-2: Sin embargo, ahora c2 está en estado",
			  coroutine.status(c2))
		print("-2: Devolvemos a c1 el valor \"¬\"")
		local args = {coroutine.yield("¬")}
		print("-2: Estamos en c2 de nuevo. Recibimos", table.unpack(args))
		-- print("------")
		print("-2: Ahora entramos en la función f3")
		args = {f3()}
		print("-2: Del `yield` de f3 recibimos", table.unpack(args))
		-- print("------")
		print("-2: Termina la ejecución de c2, devolviendo 3.14")
		return 3.14
	end
)

print("Iniciamos la corutina c1 con c2 como parámetro (Y más)")
coroutine.resume(c1, c2, 42)
print("Terminamos la ejecución de la prueba")
