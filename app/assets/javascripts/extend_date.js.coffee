Date::toStrMySQLDate = ->
	yyyy = @getFullYear().toString()
	if @getDate() < 10
		dd = "0"+@getDate().toString()
	else
		dd = @getDate().toString() 
	if @getMonth() < 10
		mm = "0" + (@getMonth()+1).toString()
	else
		mm = (@getMonth+1).toString()
	return yyyy+"-"+mm+"-"+dd


Date::toStrMySQLDateTime = ->
	yyyy = @getFullYear().toString()
	if @getDate() < 10
		dd = "0"+@getDate().toString()
	else
		dd = @getDate().toString() 
	if @getMonth() < 10
		mm = "0" + (@getMonth()+1).toString()
	else
		mm = (@getMonth+1).toString()
	if @getHours() < 10
		hh = "0"+@getHours().toString()
	else
		hh = @getHours().toString()
	if @getMinutes < 10
		mt = "0"+@getMinutes().toString()
	else
		mt = @getMinutes().toString()
	return yyyy+"-"+mm+"-"+dd+" "+hh+":"+mt