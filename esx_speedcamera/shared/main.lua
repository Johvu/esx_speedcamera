function tableContains(table, value)
	for i = 1,#table do
	  if (table[i] == value) then
		return true
	  end
	end
	return false
  end