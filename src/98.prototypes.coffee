HTMLDivElement.prototype.down = () ->
	@style.display = 'none'
	code = @getAttribute 'ondown'
	eval code if code

HTMLDivElement.prototype.up = () ->
	@style.display = 'block'
	code = @getAttribute 'onup'
	eval code if code
